$Mailboxes = Get-Mailbox -ResultSize unlimited | where {$_.ForwardingAddress -ne $null -or $_.ForwardingSmtpAddress -ne $null}
$Export = @()

foreach ($Mailbox in $Mailboxes) {
    write-host $Mailbox.PrimarySmtpAddress -ForegroundColor Green

    $ForwardingMailbox = Get-Mailbox $Mailbox.ForwardingAddress

    if ($ForwardingMailbox) {
        $Export += new-object psobject -Property @{
            'Identity'=$Mailbox.PrimarySmtpAddress
            'DeliverToMailboxAndForward'=$Mailbox.DeliverToMailboxAndForward
            'ForwardingSMTPAddress'=$ForwardingMailbox.PrimarySmtpAddress
        }
    }
}

$Export | Export-Csv Export-MailForwarding.csv -NoTypeInformation