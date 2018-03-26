<#
.SYNOPSIS
Address lists only update once per day in Office 365. This script will cause OOffice 365 to think there's been an update to each mailbox and contact and force the address lists to update.

.DESCRIPTION
Connect to Office 365 using a global admin credentials.
Run the script.
Wait for it to complete.
#>

$mailboxes = Get-Mailbox -Resultsize Unlimited
$count = $mailboxes.count
$i=0

Write-Host
Write-Host "$count Mailboxes Found" -ForegroundColor Green

foreach($mailbox in $mailboxes){
  $i++
  Set-Mailbox $mailbox.UserPrincipalName -SimpleDisplayName $mailbox.SimpleDisplayName -WarningAction silentlyContinue
  Write-Progress -Activity "Updating Mailboxes [$count]..." -Status $i
}

$mailusers = Get-MailUser -Resultsize Unlimited
$count = $mailusers.count
$i=0

Write-Host
Write-Host "$count Mail Users Found" -ForegroundColor Green

foreach($mailuser in $mailusers) {
  $i++
  Set-MailUser $mailuser.UserPrincipalName -SimpleDisplayName $mailuser.SimpleDisplayName -WarningAction silentlyContinue
  Write-Progress -Activity "Updating Mail Users [$count]..." -Status $i
}

$distgroups = Get-DistributionGroup -Resultsize Unlimited
$count = $distgroups.count
$i=0

Write-Host
Write-Host "$count Distribution Groups Found" -ForegroundColor Green

foreach($distgroup in $distgroups) {
  $i++
  Set-DistributionGroup $distgroup.DistinguishedName -SimpleDisplayName $distgroup.SimpleDisplayName -WarningAction silentlyContinue
  Write-Progress -Activity "Updating Distribution Groups. [$count].." -Status $i
}

$Contacts = Get-MailContact -Resultsize Unlimited
$count = $Contacts.count
$i=0

Write-Host
Write-Host "$count Contacts Found" -ForegroundColor Green

foreach($Contact in $Contacts) {
  $i++
  Set-MailContact $Contact.alias -SimpleDisplayName $Contact.SimpleDisplayName -WarningAction silentlyContinue
  Write-Progress -Activity "Updating Contacts. [$count].." -Status $i
}

Write-Host
Write-Host "Address list updates complete" -ForegroundColor Green