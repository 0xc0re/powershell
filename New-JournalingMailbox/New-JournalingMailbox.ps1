$JournalingDbPath = "F:\ExchangeDatabases\DB1\DB1.edb"
$JournalingDbName = "DbJournaling01"
$JournalMbxName = "journal2018"

New-MailboxDatabase -Name $JournalingDbName -EdbFilePath $JournalingDbPath -Server (Get-ExchangeServer).name
set-MailboxDatabase $JournalingDbName -CircularLoggingEnabled $true -IssueWarningQuota 49GB -ProhibitSendQuota 50GB -ProhibitSendReceiveQuota 50GB
mount-database $JournalingDbName

New-Mailbox -Alias $JournalMbxName -Name $JournalMbxName -Database $JournalingDbName -ResetPasswordOnNextLogon $false -UserPrincipalName "$JournalMbxName@$((Get-AcceptedDomain | where {$_.Default -eq $True}).name)"

Get-MailboxDatabase | foreach { 
    if ($_.name -ne $JournalingDbName) {
        set-mailboxdatabase $_.name -JournalRecipient $JournalMbxName
    }
}

New-JournalRule -Name $JournalMbxName -JournalEmailAddress $JournalMbxName -Scope Global
set-transportconfig -JournalingReportNdrTo "John.gruber@tierpoint.com"