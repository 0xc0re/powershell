<#
.SYNOPSIS
Adds the domains listed in the CSV to the Office 365 tenant.

.DESCRIPTION
Connect to office 365 PowerShell
Change directory and setup the Add-O365Domain.csv

.NOTES
Version: .01

.LINK
https://technet.microsoft.com/en-us/library/dn705744.aspx

.LINK
https://docs.microsoft.com/en-us/powershell/module/msonline/get-msoldomain?view=azureadps-1.0

.LINK
https://docs.microsoft.com/en-us/powershell/module/msonline/new-msoldomain?view=azureadps-1.0
#>

Param(
    [Parameter(Position=1)]
    [string]$DomainsCsv="Add-O365Domain.csv"
)

$NewDomains = Import-Csv $DomainsCsv

# Add any missing domains in Office 365
foreach ($NewDomain in $NewDomains) {
    $CurrentDomain = Get-MsolDomain -DomainName $NewDomain.DomainName

    if ($CurrentDomain) {
        write-host "$($NewDomain.DomainName) is already in place."
    } else {
        New-MsolDomain -Name $NewDomain.DomainName
    }
}

# Check for errors
$Errors = @()
foreach ($NewDomain in $NewDomains) {
    $CurrentDomain = Get-MsolDomain -DomainName $NewDomain.DomainName
    
    if ($CurrentDomain) {} 
    else {
        $Errors += new-object psobject -Property @{
            'DomainName'=$NewDomain.DomainName
            'Error'="Domain wasn't added."    
        }
    }
}

# Write errors to log file
if ($Errors.length -gt 0) {
    $FileName = "$($MyInvocation.MyCommand.Name -replace ".ps1$")-Errors-$(Get-Date -UFormat "%Y-%m-%d-%T").csv"

    $Errors | Export-Csv $FileName -NoTypeInformation

    Write-Host " "
    Write-Host "Errors found. Check the log file $FileName for details" -ForegroundColor Red
} else {
    Write-Host " "
    Write-Host "No errors to report." -ForegroundColor Green
}