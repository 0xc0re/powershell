$adConnector  = Read-Host "Please enter the AD Connect Active Directory Domain Services connector name from the sync service. Example: fabrikam.com"
$aadConnector = Read-Host "Please enter the AD Connect Windows Azure Active Directory (Microsoft) connector name from the sync service. Example: aaddocteam.onmicrosoft.com - AAD"

Import-Module adsync

$c = Get-ADSyncConnector -Name $adConnector
$p = New-Object Microsoft.IdentityManagement.PowerShell.ObjectModel.ConfigurationParameter "Microsoft.Synchronize.ForceFullPasswordSync", String, ConnectorGlobal, $null, $null, $null
$p.Value = 1
$c.GlobalParameters.Remove($p.Name)
$c.GlobalParameters.Add($p)
$c = Add-ADSyncConnector -Connector $c

Set-ADSyncAADPasswordSyncConfiguration -SourceConnector $adConnector -TargetConnector $aadConnector -Enable $false
Set-ADSyncAADPasswordSyncConfiguration -SourceConnector $adConnector -TargetConnector $aadConnector -Enable $true
