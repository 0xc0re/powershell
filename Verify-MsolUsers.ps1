<#
.SYNOPSIS
Runs a number of tests to verify licensed users are properly configured

.DESCRIPTION
Must connect to Office 365 prior to running the script.
* Verifies UPN doesn't end with onmicrosoft.com
* Verifies primary email address doesn't end with onmicrosoft.com
* Checks Errors property for any value
* Verifies license reconcilliation isn't requied
* Verifies the Validation Status is healthy

.NOTES
Version: .01
This script hasn't been fully tested.

#>

$Errors = @()

<#
$Errors += new-object psobject -Property @{
    'User'  = $UPN
    'Error' = $Err
}
#>

$Users = Get-MsolUser -MaxResults 25000

foreach ($User in $Users) {
    $upn = $User.UserPrincipalName
    $count += 1
    Write-Progress -Activity "Reviewing MSOL users for errors" -PercentComplete ($count / $Users.length) -Status $upn

    if ($User.IsLicensed -eq $false) {
        continue
    }

    if ($User.UserPrincipalName -like "*onmicrosoft.com") {
        $Errors += new-object psobject -Property @{'User'=$upn; 'Property'="UserPrincipalName"; 'Error'="Ends in onmicrosoft.com"}
    }

    if ($User.ProxyAddresses | where {$_ -clike "SMTP:*onmicrosoft.com"}) {
        $Errors += new-object psobject -Property @{'User'=$upn; 'Property'="ProxyAddresses"; 'Error'="SMTP contains onmicrosoft.com"}
    }

    if ($User.Errors) {
        $Errors += new-object psobject -Property @{'User'=$upn; 'Property'="Errors"; 'Error'="contains: $($User.ProxyAddresses | where {$_ -clike "SMTP:*onmicrosoft.com"})"}
    }

    if ($User.DirSyncProvisioningErrors) {
        $Errors += new-object psobject -Property @{'User'=$upn; 'Property'="DirSyncProvisioningErrors"; 'Error'="contains: $($User.DirSyncProvisioningErrors)"}
    }

    if ($User.LicenseReconciliationNeeded) {
        $Errors += new-object psobject -Property @{'User'=$upn; 'Property'="LicenseReconciliationNeeded"; 'Error'="License Reconciliation Needed"}
    }

    if ($User.ValidationStatus -ne "Healthy") {
        $Errors += new-object psobject -Property @{'User'=$upn; 'Property'="ValidationStatus"; 'Error'="Not Healthy"}
    }
}

$Errors | ft