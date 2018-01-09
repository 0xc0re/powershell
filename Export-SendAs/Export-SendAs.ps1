$Mailboxes = Get-Mailbox -ResultSize unlimited
$Export = @()

foreach ($Mailbox in $Mailboxes) {
    write-host $Mailbox.PrimarySmtpAddress -ForegroundColor Green
    $Permissions = $Mailbox | Get-ADPermission | where { ($_.ExtendedRights -like "*Send-As*") -and ($_.IsInherited -eq $false) -and -not ($_.User -like "NT AUTHORITY\SELF") }

    foreach ($Permission in $Permissions) {
        $UserMailbox = get-mailbox $Permission.User.RawIdentity
        
        if ($UserMailbox) {
            $Export += new-object psobject -Property @{
                'Identity'=$Mailbox.PrimarySmtpAddress
                'Trustee'=$UserMailbox.PrimarySmtpAddress
            }
        }
    }
}

$Export | Export-Csv Export-SendAs.csv -NoTypeInformation