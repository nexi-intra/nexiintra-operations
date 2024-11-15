<#---
title: VIP cancel future appointments
connection: graph
input: appointmentid.csv
tag: cancel-future-appointments
api: post
---


#>



param (
  [string]$EmailAddress = "JEPPE.JUUL-ANDERSEN@NEXIGROUP.COM"
  
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

throw "https://chatgpt.com/c/67370189-3824-8007-ad88-27b8db14847b"

foreach ($appointment in $appointments) {
  
  Remove-CalendarEvent -Identity $appointment.id -Mailbox $EmailAddress -CancelMessage "This appointment has been canceled as the Jeppe Juul-Andersen is no longer with Nets."
  Write-Host "Appointment canceled: $($appointment.subject)"
  
    
  
}


