<#
.SYNOPSIS
Adds Full mailbox permissions (without automapping) to every mailbox. Useful for admins that need complete access to Exchange mailboxes.

.DESCRIPTION
Connect to Office 365
Set $Admin to email address of admin.
#>

$Admin = ""

Get-Mailbox -ResultSize unlimited -Filter {(RecipientTypeDetails -eq 'UserMailbox') -and (Alias -ne 'Admin')} | Add-MailboxPermission -User $Admin -AccessRights fullaccess -InheritanceType all -AutoMapping $false