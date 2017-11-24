$Groups = Get-DistributionGroup -ResultSize unlimited

$Counts = @()

foreach ($Group in $Groups) {
    $GroupMembers = Get-DistributionGroupMember -Identity $Group.DistinguishedName -ResultSize unlimited
    $Counts += [PSCustomObject]@{ 
        name = $Group.Name
        email = $Group.WindowsEmailAddress
        MemberCount = $GroupMembers.length
    }

    Write-Host "$($Group.Name) ($($Group.WindowsEmailAddress)): $($GroupMembers.length)"
}

$Counts | Export-Csv CurrentGroupMemberCounts.csv -NoTypeInformation