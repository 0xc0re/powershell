get-mailbox -ResultSize unlimited | Get-MailboxFolderPermission | where {$_.User.UserType -ne 'Default' -and $_.User.UserType -ne "Anonymous"}
