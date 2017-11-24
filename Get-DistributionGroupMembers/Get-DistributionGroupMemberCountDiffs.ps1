$Members = import-csv GroupMembersFromCutover.csv
$Groups = $Members | group-object -property listEmail

$MissingGroups = @()
$GroupCounts = @()

foreach ($Group in $Groups) {
    $O365Group = Get-DistributionGroup $Group.Name

    if ($O365Group) {
        $O365GroupMembers = Get-DistributionGroupMember -Identity $Group.Name -ResultSize unlimited
        $diff = $O365GroupMembers.length - $Group.count

        $GroupCounts += [PSCustomObject]@{
            email = $Group.Name
            CountDuringCutover = $Group.count
            CurrentCount = $O365GroupMembers.length
            difference = $diff
        }

        if ($diff -lt 0) {
            Write-Host "$($Group.Name) missing $($diff) members" -ForegroundColor Yellow
        }
    } else {
        $MissingGroups += [PSCustomObject]@{ 
            email = $Group.Name
            MemberCount = $Group.count
        }
    }
}

$MissingGroups | Export-Csv MissingGroups.csv -NoTypeInformation
$GroupCounts | Export-Csv GroupCounts.csv -NoTypeInformation