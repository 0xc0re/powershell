$AdminEmail = ""

​Enable-OrganizationCustomization
New-ManagementRoleAssignment -Role ApplicationImpersonation -User $AdminEmail
Set-MsolUser -UserPrincipalName $AdminEmail -PasswordNeverExpires $true
​