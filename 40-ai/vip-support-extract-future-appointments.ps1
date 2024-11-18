<#---
title: VIP get future appointments

connection: exchange, graph
output: future_appointments.json
tag: get-future-appointments
api: post
---


#>
# PowerShell Script: Automate Calendar Management for Departed VIPs

# Step 1: Check if mailbox exists and recover if necessary
param (
  [string]$EmailAddress = "JEPPE.JUUL-ANDERSEN@NEXIGROUP.COM",
  [datetime]$CheckDate = "2024-11-01"
  
)

#region init
if ($null -eq $env:WORKDIR ) {
  $env:WORKDIR = join-path $psscriptroot ".." ".koksmat" "workdir"
}
$workdir = $env:WORKDIR

if (-not (Test-Path $workdir)) {
  New-Item -Path $workdir -ItemType Directory | Out-Null
}

$workdir = Resolve-Path $workdir
write-host "Workdir: $workdir"
$JsonFilePath = Join-Path -Path $workdir "future_appointments.json"

write-host "Output: $JsonFilePath"



# Function to retrieve meeting invitations from Microsoft Graph
function Get-UserInvitations {
  param (
    [string]$AccessToken,
    [string]$UserPrincipalName,
    [DateTime]$StartDate
  )

  $Uri = "https://graph.microsoft.com/v1.0/users/$UserPrincipalName/calendar/events`?\$filter=start/dateTime ge '$($StartDate.AddDays(750).ToString("o"))' and start/dateTime le '$($StartDate.ToString("o"))' and isOrganizer eq true"
  
  $headers = @{
    Authorization = "Bearer $AccessToken"
  }

  $AllResults = @()
  $count = 0
  do {
    $count++
    Write-Host "Fetching page $count..."
    # Fetch results
    $response = Invoke-RestMethod -Uri $Uri -Headers $headers -Method Get
    $AllResults += $response.value

    # Check if there's a next page
    $Uri = $response.'@odata.nextLink'
  } while ($Uri -and ($count -le 4000)) # Continue until there are no more pages

  return $AllResults
}

#endregion

# Main Workflow
# Retrieve the access token from the current Exchange Online session
$token = $env:GRAPH_ACCESSTOKEN 




# Calculate start date
$StartDate = $CheckDate
$UserPrincipalName = $EmailAddress 
# Fetch meeting invitations using the token
$Invitations = Get-UserInvitations -AccessToken $token -UserPrincipalName $UserPrincipalName -StartDate $StartDate



# Output invitations
if ($Invitations.Count -eq 0) {
  Write-Output "No invitations found for the specified date range."
}
else {
  foreach ($Invitation in $Invitations) {
    if ($Invitation.isOrganizer -ne $true) {
      continue
    }
    Write-Output "Subject: $($Invitation.subject)"
    Write-Output "Start: $($Invitation.start.dateTime.ToUniversalTime())"
    Write-Output "Organizer: $($Invitation.organizer.emailAddress.name)"
    Write-Output "------------------------------------"
  }
}
Out-File $JsonFilePath -InputObject ($Invitations | ConvertTo-Json -Depth 100) -Force

# }
# else {
#   Write-Host "Mailbox recovery failed or mailbox not found. Exiting script."
# }