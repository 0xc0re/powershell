<#
.SYNOPSIS
Import resource mailboxes from CSV

.DESCRIPTION
Connect to Office 365
cd to working directory (import csv should be in working location and it will create the output file in this location.)
map input csv to fields
#>

Param(
    [string]$CsvPath="ResourceMailboxes.csv"
)

$Resources = Import-Csv $CsvPath
$Results = @()

foreach ($Resource in $Resources) {
    $Mbx = New-Mailbox -DisplayName $Resource.DisplayName -Room -PrimarySmtpAddress $Resource.Email -Alias $Resource.Alias -Name $Resource.Name

    $ProxyAddresses = $Resource.ProxyAddresses.split(',')
    foreach ($ProxyAddress in $ProxyAddresses) {
        if ($ProxyAddress.StartsWith('smtp:')) {
            $ProxyAddress.Substring(5)
            Set-Mailbox $Resource.Email -EmailAddresses @{add=$ProxyAddress.Substring(5)}
        }
    }
}