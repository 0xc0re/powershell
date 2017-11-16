<#
.SYNOPSIS
Creates a resource mailbox (Room) that can be used to send and receive email alerts.

.DESCRIPTION
Creates a mailbox that can be used to send and receive alerts from PowerShell or other applications.
You must connect to Office 365 before running this script.

To send mail from the mailbox use the following commands:
$encryptedPassword = ConvertTo-SecureString -AsPlainText -Force -String "PassForRoom"
$cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist "Room.mailbox@email.com", $encryptedPassword
Send-MailMessage -To "email@address.com" -From 'Room.mailbox@email.com' -Subject "w/e" -Body 'w/e' -Credential $cred -SmtpServer "smtp.office365.com" -usessl

.NOTES
Version: 0.01

.LINK
New-Mailbox: https://technet.microsoft.com/en-us/library/aa997663(v=exchg.160).aspx
Set-MailboxJunkEmailConfiguration: https://technet.microsoft.com/en-us/library/dd979780(v=exchg.160).aspx
Set-MsolUser: https://docs.microsoft.com/en-us/powershell/module/msonline/set-msoluser?view=azureadps-1.0
#>

Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$Alias,

    [Parameter(Mandatory=$True,Position=2)]
    [string]$Password,

    [Parameter(Mandatory=$True,Position=3)]
    [string]$Name,

    [string]$Company,
    [string]$Notes

)

$EncryptedPassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Mbx = New-Mailbox -Alias $Alias -Name $Name -Room -EnableRoomMailboxAccount $true -RoomMailboxPassword $EncryptedPassword
$Mbx | Set-MailboxJunkEmailConfiguration –Enabled $False
Set-MsolUser -UserPrincipalName $Mbx.UserPrincipalName -PasswordNeverExpires $true

if ($Company) { Set-User $Mbx.UserPrincipalName -Company $Company }
if ($Notes) { Set-User $Mbx.UserPrincipalName -Notes $Notes }