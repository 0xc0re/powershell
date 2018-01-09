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
Version: 0.02

.LINK
New-Mailbox: https://technet.microsoft.com/en-us/library/aa997663(v=exchg.160).aspx
Set-MailboxJunkEmailConfiguration: https://technet.microsoft.com/en-us/library/dd979780(v=exchg.160).aspx
Set-MsolUser: https://docs.microsoft.com/en-us/powershell/module/msonline/set-msoluser?view=azureadps-1.0
Set-Mailbox: https://technet.microsoft.com/en-us/library/bb123981(v=exchg.160).aspx
#>

Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$Alias,

    [Parameter(Mandatory=$True,Position=2)]
    [string]$Password,

    [Parameter(Mandatory=$True,Position=3)]
    [string]$Name,

    [string]$Company="",
    [string]$Notes=""

)

# Create Mailbox
$EncryptedPassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Mbx = New-Mailbox -Alias $Alias -Name $Name -Room -EnableRoomMailboxAccount $true -RoomMailboxPassword $EncryptedPassword

# Disable Junk email filter
$Mbx | Set-MailboxJunkEmailConfiguration –Enabled $False

# Set Password to never expire
Set-MsolUser -UserPrincipalName $Mbx.UserPrincipalName -PasswordNeverExpires $true

# Hide mailbox from address books
Set-Mailbox $Mbx.UserPrincipalName -HiddenFromAddressListsEnabled $true

# Set the company. This should be set to the customer runnning the script if another tenant is sending the email. For example, If I run a script from the TierPoint tenant for our customer MTE then I set the company to MTE
if ($Company) { Set-User $Mbx.UserPrincipalName -Company $Company }

# Notes about why the mailbox is used.
if ($Notes) { Set-User $Mbx.UserPrincipalName -Notes $Notes }