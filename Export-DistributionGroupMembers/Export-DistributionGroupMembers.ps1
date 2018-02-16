$Groups = Get-DistributionGroup
$Exports = @()

foreach ($Group in $Groups) {
    $GroupEmail = $Group.PrimarySmtpAddress
    $Members = $Group | Get-DistributionGroupMember

    foreach ($Member in $Members) {
        $MemberEmail = $Member.PrimarySmtpAddress

        if ($MemberEmail) {
            $Exports += new-object psobject -Property @{
                'Group'=$GroupEmail;
                'Member'=$MemberEmail;
            }
        }
    }
}

$Exports | Export-Csv DistributionGroupMembers.csv -NoTypeInformation