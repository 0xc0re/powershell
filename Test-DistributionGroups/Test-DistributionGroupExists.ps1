<#
.SYNOPSIS
Checks If Distribution Groups exist

.DESCRIPTION
Must connect to Office 365 PowerShell before running the script
Expects a CSV named 'DistributionGroups.csv' to be located in the working directory.
#>

Param(
    [string]$CsvPath="DistributionGroups.csv"
)

$O365Groups = Get-DistributionGroup -ResultSize unlimited
$Groups = Import-Csv $CsvPath

$MissingGroups = @()

foreach ($Group in $Groups) {
    $O365Group = $O365Groups | where {$_.PrimarySmtpAddress -eq $Group.Identity}
    
    if ($O365Group) {
        Write-Host $Group.Identity -ForegroundColor Green
    } else {
        $MissingGroups += new-object psobject -Property @{
            'Identity'=$Group.Identity;
            'Error'="Group Not Found"
        }
    }
}

if ($MissingGroups.length -gt 0) {
    $MissingGroups | Export-Csv Test-DistributionGroupExists-Errors.csv -NoTypeInformation
}