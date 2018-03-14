$Server = "" # Server name of the Exchange 2010 Public Folder Server with CAS Role
$DatabaseName = "DBPF01"
$MailboxName = "PFMailbox1"
$Password = "Password123!!!"
$DomainName = (Get-AcceptedDomain | Where {$_.Default -eq 'True'}).domainname.domain

New-MailboxDatabase -Server $Server -Name $DatabaseName -IsExcludedFromProvisioning $true
New-Mailbox -Name $MailboxName -Database $DatabaseName -UserPrincipalName "$($MailboxName)@$($DomainName)" -password (ConvertTo-SecureString -String $Password -AsPlainText -Force)
Set-Mailbox -Identity $MailboxName -HiddenFromAddressListsEnabled $true
Set-MailboxDatabase $DatabaseName -RPCClientAccessServer $Server
