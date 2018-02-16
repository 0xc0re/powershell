$People = Import-Csv people2.csv

foreach ($P in $People) {
    #$mbx = New-Mailbox -Shared -Name "$($P.first) $($P.last)" -DisplayName "$($P.first) $($P.last)" -Alias "$($P.first).$($P.last)" -PrimarySmtpAddress $P.email
    
    $mbx = get-mailbox $p.email
    $mbx | Add-MailboxPermission -User john.gruber -AccessRights FullAccess -AutoMapping:$false
    $mbx | Add-MailboxPermission -User workplace -AccessRights FullAccess -AutoMapping:$false
    $mbx | Set-Mailbox -GrantSendOnBehalfTo workplace -DeliverToMailboxAndForward $true -ForwardingSMTPAddress workplace@gitbit.org -CustomAttribute1 "bot"
    
    $User = Get-MsolUser -UserPrincipalName $p.email
    $User | Set-MsolUser -Department $P.department -Title $P.title
    <#
    #Set-User -Identity "$($P.first).$($P.last)@themisdigital.com" -Manager $P.manager
    Set-UserPhoto "$($P.first).$($P.last)@themisdigital.com" -PictureData ([System.IO.File]::ReadAllBytes("C:\Users\john.gruber\Google Drive\gitbit\characters\$($P.photo).png")) -confirm:$false
    #>
}
