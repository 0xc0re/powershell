Param(
    [string]$GroupsCsvPath="DistributionGroups.csv"
)

Import-Module ActiveDirectory

$Groups = Import-Csv $GroupsCsvPath

foreach ($Group in $Groups) {
    Write-Host $Group.mail -ForegroundColor Green
    $AdGroup = Get-ADGroup -Filter "mail -eq '$($Group.mail)'"

    forEach ($ProxyAddress in $Group.proxyAddresses) {
        $AdGroup | Set-AdGroup -Clear proxyAddresses
        $AdGroup | Set-AdGroup -Add @{proxyAddresses=$ProxyAddress}
    }
}