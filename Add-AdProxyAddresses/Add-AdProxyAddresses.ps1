<#
.SYNOPSIS
Adds proxy addresses to already existing users in AD

.DESCRIPTION
Expects a CSV named 'ProxyAddresses.csv' to be located in the working directory.

.NOTES
Version: 0.1
#>

Param(
    [string]$CsvPath="ProxyAddresses.csv"
)

Import-Module ActiveDirectory

$Users = Import-Csv $CsvPath
$UsersWithError = @()
$Results = @()

foreach ($User in $Users) {
    $Account = ""
    $Account = Get-ADUser -Identity $User.sAMAccountName -Properties sAMAccountName,mail,proxyAddresses

    if ($Account -eq "") {
        $UsersWithError += new-object psobject -Property @{'identity'=$User.sAMAccountName;'error'="Couldn't find account"}
        continue
    }
}

if ($UsersWithError.length -gt 0) {
    $UsersWithError | Export-Csv UsersWithErrors.csv -NoTypeInformation
}