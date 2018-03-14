Get-OWAVirtualDirectory | ft Server, InternalUrl, ExternalUrl -AutoSize
Get-ECPVirtualDirectory | ft Server, InternalUrl, ExternalUrl -AutoSize
Get-OABVirtualDirectory | ft Server, InternalUrl, ExternalUrl -AutoSize
Get-ActiveSyncVirtualDirectory | ft Server, InternalUrl, ExternalUrl -AutoSize
Get-WebServicesVirtualDirectory | ft Server, InternalUrl, ExternalUrl -AutoSize
Get-MapiVirtualDirectory | ft Server, InternalUrl, ExternalUrl -AutoSize
get-clientaccessservice | ft server, AutoDiscoverServiceInternalUri -AutoSize
get-OutlookAnywhere | ft identity, ExternalHostname, InternalHostname, ExternalClientsRequireSsl, InternalClientsRequireSsl, DefaultAuthenticationMethod -AutoSize

get-clientaccessserver | ft server, AutoDiscoverServiceInternalUri -AutoSize