<#
.SYNOPSIS
Add proxy addresses to contacts in Office 365 for a list of Exchange contact.

.DESCRIPTION
Connect to Office 365
cd to working directory (import csv should be in working location and it will create the output file in this location.)
map input csv to fields
#>

$ContactListPath = "contacts.csv"
$OutputPath = "Import-Contacts-Output.csv"

Import-Csv -Path $ContactListPath | %{
    Write-Host $_.EmailAddress -ForegroundColor Green

    forEach ($ProxyAddress in $_.ProxyAddresses.split(',')) {
        write-host "     $ProxyAddress"
        Set-MailContact -Identity $_.EmailAddress -EmailAddresses @{Add=$ProxyAddress}
    }
}