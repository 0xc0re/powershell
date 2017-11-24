<#
.SYNOPSIS
Get the DNS information for the unverified domains in Office 365

.DESCRIPTION
Connect to office 365 PowerShell
Change directory to the proper working directory

.NOTES
Version: .01

.LINK
https://technet.microsoft.com/en-us/library/dn705744.aspx

.LINK
https://docs.microsoft.com/en-us/powershell/module/msonline/get-msoldomain?view=azureadps-1.0
#>

Param(
    [Parameter(Position=1)]
    [string]$DnsCsv="Required-DNS-Changes.csv"
)

$Domains = Get-MsolDomain -Status Unverified
$Output = @()

foreach ($Domain in $Domains) {
    $Dns = Get-MsolDomainVerificationDNS -DomainName $Domain.Name

    $Value = "MS=$(($Dns.Label.split('.'))[0])"

    $Output += new-object psobject -Property @{
        'Domain'=$Domain.Name
        'Type'="TXT"
        'Name'="@"
        'TTL'="3600"
        "Value"=$Value
    }
}

$Output | Export-Csv $DnsCsv -NoTypeInformation