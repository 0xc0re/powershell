<#
.SYNOPSIS
Create distibution lists in Office 365.

.DESCRIPTION
Export Groups to a CSV
Add & verify domains in Office 365
Connect to Office 365
cd to working directory (import csv should be in working location and it will create the output file in this location.)
map input csv to fields
#>

$InputPath = "distributiongroups.csv"
$OutputPath = "Import-DistributionLists-Output.csv"

Import-Csv -Path $InputPath |%{
    New-DistributionGroup -Name $_.Name -DisplayName $_.DisplayName -RequireSenderAuthenticationEnabled $false -PrimarySmtpAddress $_.EmailAddress | Export-Csv $OutputPath -NoTypeInformation -Append

    forEach ($Email in $_.EmailAddresses.split(" ")) {
        if ($_.EmailAddress -ne $Email -and $Email.EndsWith("serverdata.net") -eq $false) {
            Set-DistributionGroup -Identity $_.Name -EmailAddresses @{add=$Email} | Export-Csv $OutputPath -NoTypeInformation -Append
        }
    }

    Set-DistributionGroup -Identity $_.Name -HiddenFromAddressListsEnabled ([Boolean]$_.HideFromAddressBook) | Export-Csv $OutputPath -NoTypeInformation -Append
}