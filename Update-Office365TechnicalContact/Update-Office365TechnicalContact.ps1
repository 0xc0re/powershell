<#
.SYNOPSIS
Used to update the Office 365 technical contact so the customer isn't receiving the AD Connect messages directly.

.DESCRIPTION
Connect to Office 365 prior to running script
Create contact for John Gruber
Create Distribution Group and add John Gruber to the group
Hide the contact
Hide the group

.NOTES
Version 0.91
After this script is run you'll need to set the group as the contact for Office 365 support.


.LINK
https://technet.microsoft.com/en-us/library/bb124519(v=exchg.160).aspx
https://technet.microsoft.com/en-us/library/aa998856(v=exchg.160).aspx
https://docs.microsoft.com/en-us/powershell/module/msonline/get-msoldomain?view=azureadps-1.0
https://technet.microsoft.com/en-us/library/aa995950(v=exchg.160).aspx
https://technet.microsoft.com/en-us/library/bb124955(v=exchg.160).aspx
#>

$Domain = (Get-MsolDomain | where {$_.Name -like "*onmicrosoft.com" -and $_.Name -notlike "*mail.onmicrosoft.com"}).Name

$Contact = New-MailContact -ExternalEmailAddress "John.Gruber@tierpoint.com" -Name 'John Gruber'
$Group = New-DistributionGroup -Name "Office 365 Managers" -Alias "Office365Managers" -Type "Distribution" -Members john.gruber@tierpoint.com -PrimarySmtpAddress "Office365Managers@$Domain"

$Contact | Set-MailContact -HiddenFromAddressListsEnabled $true
$Group | Set-DistributionGroup -HiddenFromAddressListsEnabled $true -RequireSenderAuthenticationEnabled $false

write-host "Your new group is Office365Managers@$Domain" -ForegroundColor Green

Write-Host "Manually perform the following changes:" -ForegroundColor Green
Write-Host "1. Add the current technical contact to the distribution group." -ForegroundColor Green
Write-Host "2. Update the current technical contact on the Office 365 tenant to be the distribution group." -ForegroundColor Green