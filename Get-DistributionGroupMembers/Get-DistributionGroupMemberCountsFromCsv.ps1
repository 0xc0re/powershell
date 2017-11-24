$Members = import-csv GroupMembersFromCutover.csv
$Groups = $Members | group-object -property listEmail

$Counts = @()

foreach ($Group in $Groups) {
    $Counts += [PSCustomObject]@{ 
        email = $Group.Name
        MemberCount = $Group.count
    }

    Write-Host "$($Group.Name): $($Group.count)"
}

$Counts | Export-Csv CutoverGroupMemberCounts.csv -NoTypeInformation