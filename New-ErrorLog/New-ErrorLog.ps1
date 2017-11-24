# This is a placeholder template

$Errors = @()

$Errors += new-object psobject -Property @{
    'Line1'="ID Info"
    'Line2'="Other"    
}

if ($Errors.length -gt 0) {
    $FileName = "$($MyInvocation.MyCommand.Name -replace ".ps1$")-Errors-$(Get-Date -UFormat "%Y-%m-%d-%T").csv"

    $Errors | Export-Csv $FileName -NoTypeInformation

    Write-Host " "
    Write-Host "Errors found. Check the log file $FileName for details" -ForegroundColor Red
} else {
    Write-Host " "
    Write-Host "No errors to report." -ForegroundColor Green
}