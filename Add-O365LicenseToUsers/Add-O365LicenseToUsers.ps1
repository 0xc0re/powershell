<#
.SYNOPSIS
Adds licenses to already existing users

.DESCRIPTION
Must connect to Office 365 PowerShell before running the script
Expects a CSV named 'UsersToLicense.csv' to be located in the working directory.

.NOTES
Run Get-MsolAccountSku to determine the SKU to add to the users
#>

Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$AccountSku,

    [string]$CsvPath="UsersToLicense.csv"
)

$Users = Import-Csv $CsvPath
$UsersWithError = @()

foreach ($User in $Users) {
    $MsolUser = Get-MsolUser -UserPrincipalName $User.identity

    if ($MsolUser) {
        Write-Host $User.identity
        Set-MsolUser -UserPrincipalName $User.identity -UsageLocation US
        Set-MsolUserLicense -UserPrincipalName $User.identity -AddLicenses $AccountSku
    } else {
        $UsersWithError += new-object psobject -Property @{'identity'=$User.identity}
    }
}

if ($UsersWithError.length -gt 0) {
    $UsersWithError | Export-Csv UsersWithErrors.csv -NoTypeInformation
}