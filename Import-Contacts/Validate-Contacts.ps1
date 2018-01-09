<#
.SYNOPSIS
Validates contacts in Office 365 for a list of Exchange contact.

.DESCRIPTION
Connect to Office 365
cd to working directory (import csv should be in working location and it will create the output file in this location.)
map input csv to fields
#>

$ContactListPath = "contacts.csv"
$Results = @()

Import-Csv -Path $ContactListPath | %{
    $Contact = Get-MailContact $_.EmailAddress

    if ($Contact) {
        if ($Contact.DisplayName -ne $_.DisplayName) {
            $Results += new-object psobject -Property @{'identity'=$_.EmailAddress; 'error'="Field Wrong"; 'OldValue'=$Contact.DisplayName; 'field'="DisplayName"; 'ExpectedValue'=$_.DisplayName}
        }

        if ($Contact.PrimarySmtpAddress -ne $_.EmailAddress) {
            $Results += new-object psobject -Property @{'identity'=$_.EmailAddress; 'error'="Field Wrong"; 'OldValue'=$Contact.PrimarySmtpAddress; 'field'="EmailAddress"; 'ExpectedValue'=$_.EmailAddress}
        }

        forEach ($ProxyAddress in $_.ProxyAddresses.split(',')) {
            if ($Contact.EmailAddresses -notcontains $ProxyAddress) {
                $Results += new-object psobject -Property @{'identity'=$_.EmailAddress; 'error'="Field Wrong"; 'OldValue'=$Contact.EmailAddresses; 'field'="ProxyAddresses"; 'ExpectedValue'=$ProxyAddress}
            }
        }
    } else {
        $Results += new-object psobject -Property @{'identity'=$_.EmailAddress; 'error'="Contact Missing"; 'OldValue'=""; 'field'=""; 'ExpectedValue'=""}
    }
}

$Results | ft