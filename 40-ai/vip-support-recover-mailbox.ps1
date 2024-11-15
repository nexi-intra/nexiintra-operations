<#---
title: Recover mailbox 
connection: exchange
tag: recover-mailbox
api: post
---


#>
# PowerShell Script: Automate Calendar Management for Departed VIPs

# Step 1: Check if mailbox exists and recover if necessary
param (
  [string]$EmailAddress = "JEPPE.JUUL-ANDERSEN@NEXIGROUP.COM",
  [datetime]$CheckDate = "2024-11-01"
  
)


Write-Host "Checking mailbox for $EmailAddress..."

# Check if mailbox exists
$mailbox = Get-Mailbox -Identity $EmailAddress -ErrorAction SilentlyContinue
if ($mailbox) {
  Write-Host "Mailbox exists for $EmailAddress."
  return $true
}
$PlainTextPassword = "hAKQYbjyJrJeN4rDdi00ad4nOKFchktDzkcIZ"

# Convert to SecureString
$SecurePassword = ConvertTo-SecureString -String $PlainTextPassword -AsPlainText -Force
  
# Check if mailbox is recoverable
$deletedMailbox = Get-Mailbox -SoftDeletedMailbox -Identity $EmailAddress -ErrorAction SilentlyContinue
if ($deletedMailbox) {
  Write-Host "Recoverable mailbox found for $EmailAddress. Restoring..."
  Undo-SoftDeletedMailbox  $EmailAddress -WindowsLiveID "recovered-$EmailAddress"  -Password $SecurePassword
  Start-Sleep -Seconds 10 # Wait for restoration to complete
  return $true
}

Write-Host "Mailbox not found and not recoverable for $EmailAddress."
return $false
