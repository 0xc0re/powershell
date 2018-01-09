<#
.SYNOPSIS
Imports csv and add the permissions to Office 365 mailboxes / users

.DESCRIPTION
Connect to Office 365 prior to running the script.

.NOTES
Version: .01

.LINK

#>

Param(
    [string]$CsvPath="MailboxPermissions.csv"
)

$Permissions = Import-Csv $CsvPath

foreach ($Permission in $Permissions) {
    Write-Host "Identity: $($Permission.Identity) User: $($Permission.User)" -ForegroundColor Green
    Add-MailboxPermission -Identity $Permission.Identity -User $Permission.User -AccessRights $Permission.AccessRights -InheritanceType $Permission.InheritanceType -AutoMapping ($Permission.AutoMapping -ne 'FALSE')
}