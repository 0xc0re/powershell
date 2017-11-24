$Groups = import-csv GroupCounts.csv

$GroupsMissingMembers = @()

foreach ($Group in $Groups) {
    [int]$difference = [convert]::ToInt32($Group.difference)

    if ($difference -lt 0) {
        $GroupsMissingMembers += $Group
    }
}

$GroupMembersFromCutover = Import-Csv GroupMembersFromCutover.csv

$MissingMembers = @()

foreach ($group in $GroupsMissingMembers) {
    $O365Group = Get-DistributionGroup $group.email
    $O365GroupMembers = Get-DistributionGroupMember -Identity $O365Group.DistinguishedName

    $CutoverMembers = $GroupMembersFromCutover | where {$_.listEmail -like $group.email}
    
    foreach ($CutoverMember in $CutoverMembers) {
        $Found = $O365GroupMembers | where {$_.PrimarySmtpAddress -like $CutoverMember.EmailAddress}

        if ($Found) {
            Write-Host "$($group.email) contains $($CutoverMember.EmailAddress)" -ForegroundColor Green
        } else {
            $MissingMembers += [PSCustomObject]@{
                Group = $group.email
                User = $CutoverMember.EmailAddress
            }
        }
    }
}

$MissingMembers | Export-Csv MissingMembers.csv -NoTypeInformation