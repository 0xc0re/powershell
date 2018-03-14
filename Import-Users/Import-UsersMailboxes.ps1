<#
.SYNOPSIS
Imports users from Intermedia to Office 365

.DESCRIPTION
Export Users to a CSV
Add & verify domains in Office 365
Connect to Office 365
cd to working directory (import csv should be in working location and it will create the output file in this location.)
Run (Get-MsolAccountSku) to get the license sku
map input csv to fields
#>

# Create users in Office 365 for a list of users.

$UserListPath = "mailboxes.csv"
$sku = "reseller-account:O365_BUSINESS_PREMIUM"

Import-Csv -Path $UserListPath | foreach {
    write-host $_.EmailAddress -ForegroundColor Green
    $User = Get-MsolUser -UserPrincipalName $_.EmailAddress
    if ($User -eq $null) {
        Write-Host "     Could not find user!" -ForegroundColor Magenta
    } else {
        $User | Set-MsolUser -UsageLocation "US"

        if (($User.Licenses | select -expand AccountSkuId) -notcontains $sku) {
            Set-MsolUserLicense -UserPrincipalName $_.EmailAddress -AddLicenses $sku
        }
    }
    Write-Host " "
}