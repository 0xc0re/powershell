<#

.SYNOPSIS
This script will connect to Office 365 PowerShell (Azure Active Directory & Exchange Online).

.DESCRIPTION
I recommend saving this script in a scripts folder and adding the folder to your path. Then you can run the script from anywhere at anytime.
You need to install the Microsoft.NET Framework 4.5 and Windows Management Framework 3.0 or later.
Execution policy must be RemoteSigned or Unrestricted "Set-ExecutionPolicy RemoteSigned"
Review the link in the notes for more information.

.EXAMPLE
This example will prompt for the admin username and password
./Connect.ps1

.EXAMPLE
This example will use the username and password you specify
./Connect.ps1 -AdminUsername admin@linearbits.com -AdminPassword SecurePassword123!!!

.EXAMPLE
This example will use the username and password you specify
./Connect.ps1 admin@linearbits.com SecurePassword123!!!

.EXAMPLE
(THIS IS NOT SECURE) Edit the script and hardcode your username and password in $AdminUsername & $AdminPassword. You will not be prompted for a username or password.
./Connect.ps1

.LINK
https://technet.microsoft.com/en-us/library/jj984289(v=exchg.160).aspx

#>

Param(
    [Parameter(Mandatory=$False, Position=1)]
    [string]$AdminUsername,

    [Parameter(Mandatory=$False, Position=2)]
    [string]$AdminPassword
)

# Enter your credentials in the empty quotes to hardcode into the script. (WARNING: THIS IS NOT SECURE)
if ($AdminUsername -eq "" -or $AdminPassword -eq "") {
    $AdminUsername = ""
    $AdminPassword = ""
}

# Prompts for Officce 365 credentials if they are not supplied
if ($AdminUsername -eq "" -or $AdminPassword -eq "") {
    $cred = Get-Credential -Message "Enter your office 365 credentials"
} else {
    $encryptedPassword = ConvertTo-SecureString -AsPlainText -Force -String $AdminPassword
    $cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $AdminUsername, $encryptedPassword
}

if ($cred -eq $null) {
    Write-Host "Script cancelled. Enter your credentials to connect to Office 365."
} else {
    # Connect to Azure Active Directory
    Write-Host "CONNECT: " -ForegroundColor Yellow -NoNewline; Write-Host "Azure Active Directory" -ForegroundColor Cyan;
    Import-Module MSOnline
    Connect-MSOLService -Credential $cred

    # Connect to Exchange Online
    Write-Host "CONNECT: " -ForegroundColor Yellow -NoNewline; Write-Host "Exchange Online" -ForegroundColor Cyan;
    $exchOnlineSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell-liveid/" -Authentication Basic -AllowRedirection -Credential $cred
    Import-PSSession $exchOnlineSession -AllowClobber

    # Connect to Skype for Business
    Write-Host "CONNECT: " -ForegroundColor Yellow -NoNewline; Write-Host "Skype for Business" -ForegroundColor Cyan;
    $SkypeSession = New-CsOnlineSession -Credential $cred -Verbose
    Import-PSSession $SkypeSession
}

