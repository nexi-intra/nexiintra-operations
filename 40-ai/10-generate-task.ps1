# Generate a unique GUID
$guid = [guid]::NewGuid().ToString()

# Define variables
$taskName = "example-task"
$namespace = "magicbox-christianiabpos"
$pvcName = "task-storage-$taskName-$guid"

# Kubernetes Job manifest as a string
$jobManifest = @"
apiVersion: batch/v1
kind: Job
metadata:
  name: $taskName-$guid
  namespace: $namespace
spec:
  template:
    metadata:
      name: $taskName-$guid
    spec:
      containers:
      - name: $taskName
        image: ghcr.io/365admin/meeting-infrastructure-app:latest
        command:
        - pwsh
        - -Command
        - Write-Host 'Hello, Kubernetes!'; Write-Output 'Task complete.';
        env:
        - name: EXCHAPPID
          valueFrom:
            secretKeyRef:
              name: exchange
              key: EXCHAPPID
        - name: EXCHCERTIFICATE
          valueFrom:
            secretKeyRef:
              name: exchange
              key: EXCHCERTIFICATE
        - name: EXCHCERTIFICATEPASSWORD
          valueFrom:
            secretKeyRef:
              name: exchange
              key: EXCHCERTIFICATEPASSWORD
        - name: EXCHORGANIZATION
          valueFrom:
            secretKeyRef:
              name: exchange
              key: EXCHORGANIZATION
        volumeMounts:
        - name: $pvcName
          mountPath: /data
      restartPolicy: Never
      volumes:
      - name: $pvcName
        persistentVolumeClaim:
          claimName: $pvcName
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $pvcName
  namespace: $namespace
  labels:
    usage: task-storage
    task-name: $taskName
    task-id: $guid
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
"@

# Output the manifest to a YAML file in the same directory as the script
$outputFile = Join-Path -Path $PSScriptRoot -ChildPath "task-manifest-$guid.yaml"
$jobManifest | Out-File -FilePath $outputFile -Encoding utf8

# Display the generated YAML file
Write-Host "Manifest written to $outputFile"
Write-Host "Use the following command to apply the manifest:"
Write-Host "kubectl apply -f $outputFile"
