Param(
    [string]$CsvPath="MailForwarding.csv"
)

$Mbxs = Get-Mailbox -ResultSize unlimited
$Permissions = Import-Csv $CsvPath

foreach ($Permission in $Permissions) {
    write-host "Forwarding $($Permission.Trustee) the ability to send as $($Permission.Identity)" -ForegroundColor Green
    Set-Mailbox -Identity $Permission.Identity -DeliverToMailboxAndForward ($Permission.DeliverToMailboxAndForward -eq "TRUE") -ForwardingSMTPAddress $Permission.ForwardingSMTPAddress
}
