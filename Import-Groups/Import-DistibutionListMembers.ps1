<#
.SYNOPSIS
add members to distibution lists in Office 365.

.DESCRIPTION
Export Group membershiip to a CSV
Create distribution groups
Connect to Office 365
cd to working directory (import csv should be in working location and it will create the output file in this location.)
map input csv to fields
#>

$InputPath = "distributiongroupmembers.csv"
$OutputPath = "Import-DistributionListMembers-Output.csv"

Import-Csv -Path $InputPath |%{
    write-host "$($_.Group) - $($_.Member)" -ForegroundColor Green
    Add-DistributionGroupMember -Identity $_.Group -Member $_.Member | Export-Csv $OutputPath -NoTypeInformation -Append
}