<#---
title: VIP cancel future appointments
connection: graph
input: appointmentid.csv
tag: cancel-future-appointments
api: post
---


#>



param (
  [string]$EmailAddress = "JEPPE.JUUL-ANDERSEN@NEXIGROUP.COM",
  $message = "This appointment has been canceled due to the departure of the organizer."
  
)


if ($null -eq $env:WORKDIR ) {
  $env:WORKDIR = join-path $psscriptroot ".." ".koksmat" "workdir"
}
$workdir = $env:WORKDIR

if (-not (Test-Path $workdir)) {
  New-Item -Path $workdir -ItemType Directory | Out-Null
}

$workdir = Resolve-Path $workdir
write-host "Workdir: $workdir"
$csvFilePath = Join-Path -Path $workdir "appointmentid.csv"

# Load appointments from JSON
$appointments = Import-Csv -Path $csvFilePath

Write-Host "Canceling appointments for $EmailAddress..."

$token = $env:GRAPH_ACCESSTOKEN 
Write-Host "Canceling event for $EmailAddress..."
foreach ($appointment in $appointments) {
  
  # API Endpoint to Cancel the Event
  $Uri = "https://graph.microsoft.com/v1.0/users/$($EmailAddress)/events/$($appointment.id)/cancel"



  # Headers
  $Headers = @{
    "Authorization" = "Bearer $($token)"
    "Content-Type"  = "application/json"
  }

  # Request Body
  $Body = @{
    comment = $Comment
  } | ConvertTo-Json -Depth 1

  # Cancel the Event
  try {
    write-host "Canceling appointment: $($appointment.id)" -ForegroundColor Yellow -NoNewline
    Invoke-RestMethod -Uri $Uri -Headers $Headers -Method Post -Body $Body
    write-host " " -ForegroundColor Green
  }
  catch {
    Write-host "Failed to cancel the event: $_" -ForegroundColor Red
  }
  
  
    
  
}


