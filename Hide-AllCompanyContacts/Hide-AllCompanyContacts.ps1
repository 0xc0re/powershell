<#
.SYNOPSIS
Hide all company contacts from the GAL

.DESCRIPTION
Exports the list of company contacts to a spreadsheet documenting them before the change.
Marks all company contacts as hidden.

.NOTES
connect to Office 365 powershell
change directory to a location for the output
Run the script
wait 24 hours or run Update-AddressBooks.ps1

.LINK
https://github.com/gruberjl/powershell/tree/master/connect
https://technet.microsoft.com/en-us/library/bb124717(v=exchg.160).aspx
https://technet.microsoft.com/en-us/library/aa995950(v=exchg.160).aspx
https://github.com/gruberjl/powershell/tree/master/Update-AddressBooks
#>

$Contacts = Get-MailContact -ResultSize unlimited

$Contacts | Export-Csv "Mail-Contacts-Before-Change.csv" -NoTypeInformation

$Contacts | Set-MailContact -HiddenFromAddressListsEnabled $true