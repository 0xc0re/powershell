<#
.SYNOPSIS
Sets the maximum send and receive size for Office 365
#>

<#
Get-TransportConfig | fl maxreceivesize,maxsendsize
Get-MailboxPlan | fl name,maxsendsize,maxreceivesize,isdefault
$Mbxs | where {$_.MaxSendSize -ne "150 MB (157,286,400 bytes)" -or $_.MaxReceiveSize -ne "150 MB (157,286,400 bytes)"} | ft name, MaxSendSize, MaxReceiveSize
#>


Get-MailboxPlan | foreach { Set-MailboxPlan $_.name -MaxSendSize 150MB -MaxReceiveSize 150MB }

$Mbxs = Get-Mailbox -Resultsize Unlimited
$Mbxs | where {$_.MaxSendSize -ne "150 MB (157,286,400 bytes)" -or $_.MaxReceiveSize -ne "150 MB (157,286,400 bytes)"} | Set-Mailbox -MaxReceiveSize 150MB -MaxSendSize 150MB

