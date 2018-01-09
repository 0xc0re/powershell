<#
.SYNOPSIS

.DESCRIPTION

.NOTES
Version: .01

.LINK

#>

Param(
    [string]$CsvPath="Imports.csv",

    [Parameter(Mandatory=$False, Position=1)]
    [string]$Param
)

$Items = Import-Csv $CsvPath
$Results = @()

foreach ($Item in $Items) {
    $Results += new-object psobject -Property @{'identity'=1; 'error'=$Message; 'message'=$Message; 'OldValue'=$OldValue; 'NewValue'=$NewValue}
}