<#
.SYNOPSIS
Converts a user mailbox to a shared mailbox. Removes all licenses from the account.

.DESCRIPTION
Must connect to Office 365 PowerShell before running the script
Expects a CSV named 'UsersToConvert.csv' to be located in the working directory.

.NOTES
Version 0.1
#>

Param(
    [string]$CsvPath="UsersToConvert.csv"
)

$Users = Import-Csv $CsvPath

foreach ($User in $Users) {
    Write-Host $User.identity
    $Licenses = (Get-MsolUser -UserPrincipalName $User.identity).licenses.AccountSkuId
    Set-Mailbox $User.identity -Type Shared
    foreach ($License in $Licenses) {
        Set-MsolUserLicense -UserPrincipalName $User.identity -RemoveLicenses $License
    }
}