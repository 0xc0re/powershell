<#
.SYNOPSIS
Configures an admin account for easy management of Office 365

.DESCRIPTION
You may need to run `Import-PSSession (New-PSSession -ConfigurationName Microsoft.Exchange -Credential $credential -ConnectionURI https://ps.outlook.com/powershell -Authentication Basic -AllowRedirection) -AllowClobber` to enable-organizationconfiguration

.LINK
https://cloudsupport.exclaimer.com/hc/en-us/articles/115002834769-Enable-OrganizationCustomization-is-prompted-during-the-Office-365-connector-setup-wizard
#>
Param(
    [Parameter(Position=1)]
    [string]$AdminEmail
)

if (!$AdminEmail) {
    $Mbx = get-mailbox 'admin'
    if ($Mbx) {
        $AdminEmail = (get-mailbox 'admin').userprincipalname
    } else {
        $AdminEmail = read-host "Admin Email Address?"
    }
}

Set-MsolUser -UserPrincipalName $AdminEmail -PasswordNeverExpires $true
Set-MailboxRegionalConfiguration -Identity $AdminEmail -Language 1033 -TimeZone "Eastern Standard Time"

<#
$Credential = Get-Credential
Import-PSSession (New-PSSession -ConfigurationName Microsoft.Exchange -Credential $credential -ConnectionURI https://ps.outlook.com/powershell -Authentication Basic -AllowRedirection) -AllowClobber
​Enable-OrganizationCustomization
New-ManagementRoleAssignment -Role ApplicationImpersonation -User $AdminEmail
#>