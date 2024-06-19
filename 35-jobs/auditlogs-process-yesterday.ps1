<#---
title: Audit log process yesterday Cronjob
tag: auditlogsprocessyesterday
api: post
---

#>

param (
  [string]$jobName = "auditlog"
)
if ((Split-Path -Leaf (Split-Path  -Parent -Path $PSScriptRoot)) -eq "sessions") {
  $path = join-path $PSScriptRoot ".." ".."
}
else {
  $path = join-path $PSScriptRoot ".." ".koksmat/"

}

$koksmatDir = Resolve-Path $path

$inputFile = join-path  $koksmatDir "jobs" $jobName "koksmat.json"

if (!(Test-Path -Path $inputFile) ) {
  Throw "Cannot find file at expected path: $inputFile"
} 
$json = Get-Content -Path $inputFile | ConvertFrom-Json
$version = "v$($json.version.major).$($json.version.minor).$($json.version.patch).$($json.version.build)"
$port = "$($json.port)"
$appname = $json.appname
$imagename = $json.imagename
$dnsname = $json.dnsprod



$image = "$($imagename)-app:$($version)"


$envs = @()
function env($name, $value ) {
  if ($null -eq $value) {
    throw "Environment value for $name is not set"
  }
  return @{name = $name; value = $value }
}



$envs += env "APPCLIENT_ID" $env:APPCLIENT_ID
$envs += env "APPCLIENT_SECRET" $env:APPCLIENT_SECRET
$envs += env "APPCLIENT_DOMAIN" $env:APPCLIENT_DOMAIN
$envs += env "NATS" "nats://nats:4222"
$envs += env "POSTGRES_DB" $env:POSTGRES_DB
$configEnv = ""
foreach ($item in $envs) {

  $configEnv += @"
              - name: $($item.name)
                value: $($item.value)

"@
}


$config = @"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: job-$jobName-config-json
data:
  config.json: |
    {
      "key": "value"     
    }

       
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: $jobName
spec:
  schedule: "0 0 3 * *"
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
          - name: job-$jobName
            image: $image
            command: ["/bin/sh", "-c"]
            args:
              - |
                set -e
                cd 
                mkdir workdir
                cd workdir
                
                echo "Starting to extract";
                
                magic-mix download auditlog audit 

                echo "Extraction completed, starting to transform data ...";

                magic-mix upload audit

                echo "Transformation completed, starting to load data ...";

                magic-mix move mix files sharepoint.pageviews events insert_audit_records

                echo "Load completed.";
            env:
$configEnv                           

            volumeMounts:
            - name: config-volume
              mountPath: /config
              readOnly: true
          volumes:
          - name: config-volume
            configMap:
              name: job-$jobName-config-json

          

"@

write-host "Applying config" -ForegroundColor Green

write-host $config -ForegroundColor Gray

$config |  kubectl apply -f -