<#---
title: VIP cancel future appointments

connection: exchange
output: exchange-rooms.json
tag: get-rooms
api: post
---

## Reading rooms from Exchange
This cmdlet is available only in the Exchange Online PowerShell module. For more information, see [About the Exchange Online PowerShell module](https://aka.ms/exov3-module).

Use the Get-EXOMailbox cmdlet to view mailbox objects and attributes, populate property pages, or supply mailbox information to other tasks.

For information about the parameter sets in the Syntax section below, see [Exchange cmdlet syntax](https://learn.microsoft.com/powershell/exchange/exchange-cmdlet-syntax).

#>
# PowerShell Script: Automate Calendar Management for Departed VIPs

# Step 1: Check if mailbox exists and recover if necessary
param (
  [string]$EmailAddress = "JEPPE.JUUL-ANDERSEN@NEXIGROUP.COM",
  [datetime]$CheckDate = "2022-01-01",
  [string]$JsonFilePath = "future_appointments.json"
)
function CheckAndRecoverMailbox {
  param (
    [string]$EmailAddress,
    [datetime]$CheckDate
  )

  Write-Host "Checking mailbox for $EmailAddress..."

  # Check if mailbox exists
  $mailbox = Get-Mailbox -Identity $EmailAddress -ErrorAction SilentlyContinue
  if ($mailbox) {
    Write-Host "Mailbox exists for $EmailAddress."
    return $true
  }

  # Check if mailbox is recoverable
  $deletedMailbox = Get-Mailbox -SoftDeletedMailbox -Identity $EmailAddress -ErrorAction SilentlyContinue
  if ($deletedMailbox) {
    Write-Host "Recoverable mailbox found for $EmailAddress. Restoring..."
    Undo-SoftDeletedMailbox  $EmailAddress
    Start-Sleep -Seconds 10 # Wait for restoration to complete
    return $true
  }

  Write-Host "Mailbox not found and not recoverable for $EmailAddress."
  return $false
}

# Step 2: Extract future appointments
function ExtractFutureAppointments {
  param (
    [string]$EmailAddress,
    [string]$OutputFile
  )

  Write-Host "Extracting future appointments for $EmailAddress..."

  # Connect to mailbox and retrieve appointments
  #$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://outlook.office365.com/powershell -Authentication Basic -Credential (Get-Credential)
  #Import-PSSession $session -DisableNameChecking


  # Define variables
  $UserPrincipalName = "JEPPE.JUUL-ANDERSEN@NEXIGROUP.COM"
  $StartDateTime = (Get-Date -Date "2024-11-13T00:00:00Z").ToString("o")  # ISO 8601 format
  $EndDateTime = (Get-Date).AddYears(1).ToString("o")                    # Adjust the end date as needed

  # Query parameters for filtering events by date range
  $Filter = "start/dateTime ge '$StartDateTime' and end/dateTime le '$EndDateTime'"

  # Get calendar events
  $Events = Get-MgUserCalendarEvent -UserId $UserPrincipalName -Filter $Filter

  # Display the events
  foreach ($Event in $Events) {
    Write-Output "Subject: $($Event.Subject)"
    Write-Output "Start Time: $($Event.Start.DateTime)"
    Write-Output "End Time: $($Event.End.DateTime)"
    Write-Output "----------------------------------------"
  }


  # $appointments = Get-CalendarDiagnosticObjects  $EmailAddress -StartDate (Get-Date) -EndDate (Get-Date).AddYears(1)
  # $futureAppointments = @()

  # foreach ($appointment in $appointments) {
  #   $futureAppointments += [pscustomobject]@{
  #     id        = $appointment.GlobalObjectId
  #     subject   = $appointment.Subject
  #     start     = $appointment.StartTime
  #     end       = $appointment.EndTime
  #     attendees = $appointment.RequiredAttendees | Select-Object DisplayName, EmailAddress
  #   }
  # }

  # Save to JSON file
  $futureAppointments | ConvertTo-Json -Depth 3 | Out-File -FilePath $OutputFile
  Write-Host "Future appointments saved to $OutputFile."
}

# Step 3: Cancel appointments from JSON file
function CancelAppointments {
  param (
    [string]$InputFile,
    [string]$EmailAddress
  )
  throw "Not tested yet"
  Write-Host "Canceling appointments for $EmailAddress..."

  # Load appointments from JSON
  $appointments = Get-Content -Path $InputFile | ConvertFrom-Json

  foreach ($appointment in $appointments) {
    try {
      Remove-CalendarEvent -Identity $appointment.id -Mailbox $EmailAddress -CancelMessage "This appointment has been canceled as the user is no longer available."
      Write-Host "Appointment canceled: $($appointment.subject)"
    }
    catch {
      Write-Host "Failed to cancel appointment: $($appointment.subject)" -ForegroundColor Red
    }
  }
}

# Main Workflow


# Step 1: Check and recover mailbox
if (CheckAndRecoverMailbox -EmailAddress $EmailAddress -CheckDate $CheckDate) {
  # Step 2: Extract future appointments
  ExtractFutureAppointments -EmailAddress $EmailAddress -OutputFile $JsonFilePath

  Write-Host "Review the JSON file at $JsonFilePath and make any necessary changes before proceeding."

  # Optional Pause for Manual Review
  Read-Host "Press Enter to continue with cancellations after reviewing the file"

  # Step 3: Cancel appointments
  CancelAppointments -InputFile $JsonFilePath -EmailAddress $EmailAddress
}
else {
  Write-Host "Mailbox recovery failed or mailbox not found. Exiting script."
}