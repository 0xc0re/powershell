#Get-Mailbox | Get-MailboxPermission | Select {$_.AccessRights}, Deny, InheritanceType, User, Identity, IsInherited, IsValid | Export-Csv Export-MailboxPermissions.csv -NoTypeInformation

$Mailboxes = Get-Mailbox -ResultSize unlimited
$Export = @()

foreach ($Mailbox in $Mailboxes) {
    write-host $Mailbox.PrimarySmtpAddress -ForegroundColor Green
    $Permissions = Get-MailboxPermission $Mailbox | where {$_.IsInherited -eq $false -and $_.User.RawIdentity -ne "NT AUTHORITY\SELF"}

    foreach ($Permission in $Permissions) {
        $UserMailbox = get-mailbox $Permission.User.RawIdentity
        
        if ($UserMailbox) {
            $Export += new-object psobject -Property @{
                'Identity'=$Mailbox.PrimarySmtpAddress
                'User'=$UserMailbox.PrimarySmtpAddress
                'AccessRights'=[string]::join(', ', $Permission.AccessRights)
                'InheritanceType'=$Permission.InheritanceType
            }
        }
    }
}

$Export | Export-Csv Export-MailboxPermissions.csv -NoTypeInformation