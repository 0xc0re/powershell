Param(
    [string]$CsvPath="DistributionGroupMembers.csv"
)

Import-Module ActiveDirectory

$Members = Import-Csv $CsvPath

foreach ($Member in $Members) {
    $Group = Get-ADGroup -Filter "mail -eq '$($Member.group)'"
    $User = Get-ADUser -Properties mail -Filter "mail -eq '$($Member.Member)'"
    
    if ($Group -and $User) {
        $Group | Add-ADGroupMember -Members $User
    } else {
        Write-Host "$($Member.Member) - $($Member.Group)" -ForegroundColor Red
    }
}