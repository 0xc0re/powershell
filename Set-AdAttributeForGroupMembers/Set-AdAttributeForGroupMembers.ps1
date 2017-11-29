<#
.SYNOPSIS
Sets the extensionAttribute12 to sync for anyone in the O365 group.

.DESCRIPTION
create a scheduled task:
    Security: Run whether user is logged on or not.
    Trigger: Weekly - Mon-Fri at noon. Stop taksk if it runs longer than 30 minutes.
    Action: Powershell.exe
    Action arguments: c:\scripts\galsync-monitor.ps1
    Settings: Stop the task if it runs longer than 1 hour

.NOTES
Version: 0.01
#>

Import-Module ActiveDirectory

$EmailUsername = ""
$EmailPassword = ""
$encryptedPassword = ConvertTo-SecureString -AsPlainText -Force -String $EmailPassword
$cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $EmailUsername, $encryptedPassword
$Subject = "Set sync for o365 members"
$Body = "This script runs on  server. It sets the extensionAttribute12 AD attribute to sync for anyone in the o365 group. Then AD Connect filters by the attribute`r`n"

$Members = Get-ADGroupMember 'O365' | Where-Object { $_.objectClass -eq 'user' } | Get-ADUser -Properties Name,distinguishedname,cn,extensionAttribute12,SamAccountName,ObjectClass

$Syncing = Get-ADUser -filter {extensionAttribute12 -eq "sync"} -Properties Name,distinguishedname,cn,extensionAttribute12,SamAccountName,ObjectClass

$Errors = ""
$Actions = ""

foreach ($SyncedUser in $Syncing) {
    if ($SyncedUser.ObjectClass -eq "user") {
        $Member = $Members | where {$_.SID -eq $SyncedUser.SID}
    
        if ($Member) { } else {
            $Actions += "clearing extensionAttribute12 for $($SyncedUser.SamAccountName)`r`n`r`n"
            $SyncedUser | Set-ADUser -Clear extensionAttribute12
        }
    } else {
        $Errors += "SyncedUser doesn't have ObjectClass of 'user': $SyncedUser`r`n"
    }
}

foreach ($Member in $Members) {
    if ($Member.ObjectClass -eq "user") {
        if ($Member.extensionAttribute12 -and $Member.extensionAttribute12 -eq 'sync') { } else {
            $Actions += "Setting extensionAttribute12 for $($Member.SamAccountName)`r`n`r`n"
            $Member | Set-ADUser -Replace @{extensionAttribute12="sync"}
        }
    } else {
        $Errors += "Member doesn't have ObjectClass of 'user': $Member`r`n"
    }
}

$Body += "`r`n*** Actions ***`r`n"
$Body += $Actions
$Body += "`r`n`r`n*** Errors ***`r`n"
$Body += $Errors

if ($Errors.Length -gt 0) {
    Send-MailMessage -To "" -From $EmailUsername -Subject $Subject -Body $Body -Credential $cred -SmtpServer "smtp.office365.com" -usessl
}