<#
.SYNOPSIS
Update the mail field for users

.DESCRIPTION
Expects a CSV named 'Users.csv' to be located in the working directory.

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
        $Results += new-object psobject -Property @{'identity'=$User.Identity;'error'="Couldn't find account";'oldMailFIeld'="";'newMailFIeld'="";'message'=""}
        continue
    }

    if ($Account.mail -ne $User.mail) {
        $Results += new-object psobject -Property @{'identity'=$User.Identity;'error'="";'message'="Updating mail field";'oldMailFIeld'=$Account.mail;'newMailFIeld'=$User.mail}
        $Account | Set-ADUser -Replace @{mail=$User.mail}
    }
}

$Results | Export-Csv AdMailFieldResults.csv -NoTypeInformation