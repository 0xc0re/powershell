$AdminEmail = ""

Set-MailboxRegionalConfiguration -Identity $AdminEmail -Language 1033 -TimeZone "Eastern Standard Time"

​Enable-OrganizationCustomization
New-ManagementRoleAssignment -Role ApplicationImpersonation -User $AdminEmail
Set-MsolUser -UserPrincipalName $AdminEmail -PasswordNeverExpires $true
​