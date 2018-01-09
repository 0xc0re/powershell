<#
.SYNOPSIS
Create contacts in Office 365 for a list of Exchange contact.

.DESCRIPTION
Connect to Office 365
cd to working directory (import csv should be in working location and it will create the output file in this location.)
map input csv to fields
#>

$ContactListPath = "contacts.csv"
$OutputPath = "Import-Contacts-Output.csv"

Import-Csv -Path $ContactListPath | %{
    Write-Host $_.EmailAddress -ForegroundColor Green
    New-MailContact -Name $_.Name -DisplayName $_.DisplayName -ExternalEmailAddress $_.EmailAddress -FirstName $_.FirstName -LastName $_.LastName | Export-Csv -Path $OutputPath -NoTypeInformation -Append
    Set-Contact $_.Name -Company $_.Company -Department $_.Department -Phone $_.PhoneNumber | Export-Csv -Path $OutputPath -NoTypeInformation -Append
}