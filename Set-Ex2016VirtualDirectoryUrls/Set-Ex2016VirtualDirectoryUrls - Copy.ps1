Param(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$Server,

    [Parameter(Mandatory=$True, Position=2)]
    [string]$HTTPS_FQDN
)

$Server = "manco-ex03-001"
$HTTPS_FQDN = "owa.mungenast.com"
$old = "manco-tempex01"

Get-OWAVirtualDirectory -Server $Server | select Server, InternalURL, ExternalURL
Get-ECPVirtualDirectory -Server $Server | select Server, InternalURL, ExternalURL
Get-OABVirtualDirectory -Server $Server | select Server, InternalURL, ExternalURL
Get-ActiveSyncVirtualDirectory -Server $Server | select Server, InternalURL, ExternalURL
Get-WebServicesVirtualDirectory -Server $Server | select Server, InternalURL, ExternalURL
Get-MapiVirtualDirectory -Server $Server | select Server, InternalURL, ExternalURL

Get-OWAVirtualDirectory -Server $Server | Set-OWAVirtualDirectory -InternalURL "https://$($HTTPS_FQDN)/owa" -ExternalURL "https://$($HTTPS_FQDN)/owa"
Get-ECPVirtualDirectory -Server $Server | Set-ECPVirtualDirectory -InternalURL "https://$($HTTPS_FQDN)/ecp" -ExternalURL "https://$($HTTPS_FQDN)/ecp"
Get-OABVirtualDirectory -Server $Server | Set-OABVirtualDirectory -InternalURL "https://$($HTTPS_FQDN)/oab" -ExternalURL "https://$($HTTPS_FQDN)/oab"
Get-ActiveSyncVirtualDirectory -Server $Server | Set-ActiveSyncVirtualDirectory -InternalURL "https://$($HTTPS_FQDN)/Microsoft-Server-ActiveSync" -ExternalURL "https://$($HTTPS_FQDN)/Microsoft-Server-ActiveSync"
Get-WebServicesVirtualDirectory -Server $Server | Set-WebServicesVirtualDirectory -InternalURL "https://$($HTTPS_FQDN)/EWS/Exchange.asmx" -ExternalURL "https://$($HTTPS_FQDN)/EWS/Exchange.asmx"
Get-MapiVirtualDirectory -Server $Server | Set-MapiVirtualDirectory -InternalURL "https://$($HTTPS_FQDN)/mapi" -ExternalURL https://$($HTTPS_FQDN)/mapi


$Server = "manco-ex02"
$HTTPS_FQDN = "owa.mungenast.com"

# Logs the settings from the old server
Get-OWAVirtualDirectory -Server $Server | select Server, ExternalURL | Export-Csv "OWAVirtualDirectory-$Server.csv" -NoTypeInformation
Get-ECPVirtualDirectory -Server $Server | select Server, ExternalURL | Export-Csv "ECPVirtualDirectory-$Server.csv" -NoTypeInformation
Get-OABVirtualDirectory -Server $Server | select Server, ExternalURL | Export-Csv "OABVirtualDirectory-$Server.csv" -NoTypeInformation
Get-ActiveSyncVirtualDirectory -Server $Server | select Server, ExternalURL | Export-Csv "ActiveSyncVirtualDirectory-$Server.csv" -NoTypeInformation
Get-WebServicesVirtualDirectory -Server $Server | select Server, ExternalURL | Export-Csv "WebServicesVirtualDirectory-$Server.csv" -NoTypeInformation
Get-OutlookAnywhere -Server $Server | Select server, ClientAuthenticationMethod, SSLOffloading, ExternalHostName, IISAuthenticationMethods | Out-String >> "OutlookAnywhere-$Server.txt"

# Updates the old server urls to $null
Get-OWAVirtualDirectory -Server $Server | Set-OWAVirtualDirectory -ExternalURL $null
Get-ECPVirtualDirectory -Server $Server | Set-ECPVirtualDirectory -ExternalURL $null
Get-OABVirtualDirectory -Server $Server | Set-OABVirtualDirectory -ExternalURL $null
Get-ActiveSyncVirtualDirectory -Server $Server | Set-ActiveSyncVirtualDirectory  -ExternalURL $null
Get-WebServicesVirtualDirectory -Server $Server | Set-WebServicesVirtualDirectory  -ExternalURL $null
Enable-OutlookAnywhere -Server $Server -ClientAuthenticationMethod Basic -SSLOffloading $False -ExternalHostName $HTTPS_FQDN -IISAuthenticationMethods NTLM, Basic
