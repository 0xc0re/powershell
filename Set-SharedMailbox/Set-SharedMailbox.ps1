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
    $upn = $User.identity
    Write-Host $upn
    $Licenses = (Get-MsolUser -UserPrincipalName $upn).licenses.AccountSkuId
    Set-Mailbox $upn -Type Shared
    foreach ($License in $Licenses) {
        Set-MsolUserLicense -UserPrincipalName $upn -RemoveLicenses $License
    }
}