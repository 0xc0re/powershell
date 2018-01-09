<#
.SYNOPSIS
Adds proxy addresses to already existing users in AD

.DESCRIPTION
Expects a CSV named 'ProxyAddresses.csv' to be located in the working directory.

.NOTES
Version: 0.1
#>

Param(
    [string]$CsvPath="Users.csv"
)

Import-Module ActiveDirectory

$Users = Import-Csv $CsvPath
$Results = @()

foreach ($User in $Users) {
    $Account = ""
    $Account = Get-ADUser -Identity $User.Identity -Properties sAMAccountName,mail,proxyAddresses

    if ($Account -eq "") {
        $Results += new-object psobject -Property @{'identity'=$User.Identity;'error'="Couldn't find account";'oldProxyAddresses'="";'newProxyAddresses'="";'message'=""}
        continue
    }

    if ($Account.proxyAddresses) {
    } else {
        $ProxyString = $Account.proxyAddresses -join ","
        $Results += new-object psobject -Property @{'identity'=$User.Identity;'error'="";'message'="Updating proxyAddresses field";'oldProxyAddresses'=$ProxyString;'newProxyAddresses'=$User.proxyAddresses}
        foreach ($ProxyAddress in $User.proxyAddresses.split(',')) {
            $Account | Set-ADUser -Add @{proxyAddresses=$ProxyAddress}
        }
    }
}

$Results | Export-Csv Add-AdProxyAddressesResults.csv -NoTypeInformation