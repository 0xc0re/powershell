$MissingMembers = Import-Csv MissingMembers.csv

$Groups = import-csv GroupCounts.csv

$GroupsMissingMembers = @()

foreach ($Group in $Groups) {
    [int]$difference = [convert]::ToInt32($Group.difference)

    if ($difference -lt 0) {
        $GroupsMissingMembers += [PSCustomObject]@{
            email = $group.email
            difference = $difference
        }
    }
}

$MissingMembersGrouped = $MissingMembers | group-object -property Group

foreach ($group in $GroupsMissingMembers) {
    $MissingMembersGroup = $MissingMembersGrouped | where {$_.Name -eq $group.email}

    if (($MissingMembersGroup.Count * -1) -ne $group.difference) {
        Write-Host "$($group.email): $($MissingMembersGroup.Count * -1) / $($group.difference)" -ForegroundColor Red
    }
}