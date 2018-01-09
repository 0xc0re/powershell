Param(
    [string]$GroupsCsvPath="DistributionGroups.csv"
)

Import-Module ActiveDirectory

$Groups = Import-Csv $GroupsCsvPath

foreach ($Group in $Groups) {
    $AdGroup = Get-ADGroup -Filter "mail -eq '$($Group.mail)'"

    if ($AdGroup) {

    } else {
        write-host "$($Group.mail) Doesn't exist." -ForegroundColor Red
    }
}