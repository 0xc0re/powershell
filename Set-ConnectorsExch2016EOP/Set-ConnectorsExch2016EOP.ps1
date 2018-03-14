#Don't run this script blindly. It's grabbing any and possibly every connector

$mxRecord = read-host "Customer MX Records provided by Office 365 for their primary domain"

# New-SendConnector -Name "My company to Office 365" -AddressSpaces * -CloudServicesMailEnabled $true -Fqdn mail.contoso.com -RequireTLS $true -DNSRoutingEnabled $false -SmartHosts  contoso-com.mail.protection.outlook.com -TlsAuthLevel  CertificateValidation
$sendconnector = get-sendconnector
$sendconnector | Set-SendConnector -MaxMessageSize 100MB -ConnectionInactivityTimeOut 00:15:00
$sendconnector | Set-SendConnector -DNSRoutingEnabled $false -RequireTLS $true -SmartHosts $mxRecord -TlsAuthLevel CertificateValidation

New-TransportRule "Spam To Junk" -HeaderContainsMessageHeader "X-Forefront-Antispam-Report" -HeaderContainsWords "SFV:SPM" -SetSCL 6
New-TransportRule "Bypass On-Premise Spam Filter Route To Junk" -HeaderContainsMessageHeader "X-Forefront-Antispam-Report" -HeaderContainsWords "SFV:SKS" -SetSCL 6

$ReceiveConnector = Get-ReceiveConnector "Default Frontend*"
$ReceiveConnector = Set-ReceiveConnector -RemoteIPRanges "23.103.132.0/22, 23.103.136.0/21, 23.103.144.0/20, 23.103.198.0/23, 23.103.200.0/22, 23.103.212.0/22, 40.92.0.0/14, 40.107.0.0/17, 40.107.128.0/18, 52.100.0.0/14, 65.55.88.0/24, 65.55.169.0/24, 94.245.120.64/26, 104.47.0.0/17, 134.170.132.0/24, 134.170.140.0/24, 157.55.234.0/24, 157.56.110.0/23, 157.56.112.0/24, 207.46.51.64/26, 207.46.100.0/24, 207.46.163.0/24, 213.199.154.0/24, 213.199.180.128/26, 216.32.180.0/23, 2a01:111:f400:7c00::/542a01:111:f400:fc00::/54, 2a01:111:f403::/48"
