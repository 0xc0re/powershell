<#
.SYNOPSIS
Checks Email Aliases for the the users in Office 365.

.DESCRIPTION
Must connect to Office 365 PowerShell before running the script
Expects a CSV named 'EmailAliases.csv' to be located in the working directory.
#>

Param(
    [string]$CsvPath="EmailAliases.csv"
)

$Mbxs = Get-Mailbox -ResultSize unlimited
$Users = Import-Csv $CsvPath

$UsersWithError = @()

foreach ($User in $Users) {
    $Mbx = $Mbxs | where {$_.UserPrincipalName -eq $User.Identity}

    if ($Mbx) {
        $Aliases = $Mbx.EmailAddresses.split(',')
        foreach ($Alias in $Aliases) {
            if ($Mbx.EmailAddresses -contains $Alias) {
                Write-Host "$($Mbx.UserPrincipalName) has $($Alias)" -ForegroundColor Green
            } else {
                $UsersWithError += new-object psobject -Property @{
                    'Identity'=$User.Identity;
                    'Error'="Missing Alias: $($User.Aliases)"
                }
            }
        }
    } else {
        $UsersWithError += new-object psobject -Property @{
            'Identity'=$User.Identity;
            'Error'="User Not Found"
        }
    }
}

if ($UsersWithError.length -gt 0) {
    $UsersWithError | Export-Csv Test-EmailAlias-Errors.csv -NoTypeInformation
}