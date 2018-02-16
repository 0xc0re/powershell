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
$outputPath = "Import-Users-Output.csv"
$sku = "reseller-account:EXCHANGESTANDARD"

Import-Csv -Path $UserListPath | foreach {
    New-MsolUser -DisplayName $_.DisplayName -FirstName $_.FirstName -LastName $_.LastName -UserPrincipalName $_.EmailAddress -Title $_.Title -Department $_.Department  -UsageLocation "US" -PhoneNumber $_.PhoneNumber -MobilePhone $_.MobilePhone -Fax $_.Fax -StreetAddress $_.StreetAddress -City $_.City -State $_.State -PostalCode $_.PostalCode -LicenseAssignment $sku
} | Export-Csv -Path $outputPath -NoTypeInformation