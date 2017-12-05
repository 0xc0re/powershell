<#
.SYNOPSIS
Imports Distribution Groups into AD

.DESCRIPTION
Expects a CSV named 'AdDistributionGroups.csv' to be located in the working directory.
Expects a CSV named 'AdDistributionGroupMembers.csv' to be located in the working directory.

.NOTES
Version: 0.1
*** This doesn't work! ***
#>

<#
Param(
    [string]$GroupsCsvPath="AdDistributionGroups.csv",
    [string]$MembersCsvPath="AdDistributionGroupMembers.csv",
    [string]$PathForNewGroups="OU=OU NAME,DC=DOMAIN_NAME,DC=local"
)

Import-Module ActiveDirectory

$Groups = Import-Csv $GroupsCsvPath

$Members = Import-Csv $MembersCsvPath

$Results = @()

foreach ($Group in $Groups) {
    $AdGroup = ""
    $AdGroup = Get-ADGroup -Identity $Group.Name

    if ($AdGroup -eq "") {
        $AdGroup = Get-ADGroup -Filter {mail -like $Group.Email}
    }

    if ($AdGroup -eq "") {
        $Results += new-object psobject -Property @{'group'=$Group.Name;'identity'="";'message'="Creating Distribution Group";'error'=""}
        $AdGroup = New-ADGroup -Name $Group.Name -Description $Group.Description -Path $PathForNewGroups -GroupCategory Distribution -GroupScope Universal
    } else {
        $Results += new-object psobject -Property @{'group'=$Group.Name;'identity'="";'message'="Found Group";'error'=""}

        if ($AdGroup.GroupCategory -ne "Distribution") {
            $Results += new-object psobject -Property @{'group'=$Group.Name;'identity'="";'message'="GroupCategory is $($AdGroup.GroupCategory)";'error'="Not a distribution Group"}
            continue
        }
    }

    $AdGroup = Get-ADGroup -Identity $Group.Name -Properties name,description,mail

    if ($AdGroup.mail -ne $Group.Email) {
        $Results += new-object psobject -Property @{'group'=$Group.Name;'identity'="";'message'="Updating Group attribute mail from $($AdGroup.mail) to $($Group.Email)";'error'=""}
        $AdGroup | Set-ADGroup -Replace @{mail=$Group.Email}
    }

    $GroupMembers = $Members | where {$_.GroupName -eq $Group.Name}

    $AdGroupMembers = $AdGroup | Get-ADGroupMember | Where-Object { $_.objectClass -eq 'user' } | Get-ADUser -Properties Name,distinguishedname,SamAccountName,ObjectClass,mail

    foreach ($GroupMember in $GroupMembers) {
        $AdGroupMember = $AdGroupMembers | where {$_.mail -like $GroupMember.UserEmail}
        
        if ($AdGroupMember -eq $null) {
            $AdUser = Get-ADUser -Filter {mail -like "$($GroupMember.UserEmail)"}

            if ($AdUser -eq $null) {
                $Results += new-object psobject -Property @{'group'=$Group.Name;'identity'=$GroupMember.UserEmail;'message'="";'error'="Couldn't find user in AD"}
            } else {
                $Results += new-object psobject -Property @{'group'=$Group.Name;'identity'=$GroupMember.UserEmail;'message'="Adding user to group";'error'=""}
                #Add-ADGroupMember -Identity $AdGroup.name -Member $AdUser.distinguishedname
            }
        }
    }
}

$Results | ft -AutoSize
#$Results | Export-Csv Import-AdDistributionGroups-Results.csv -NoTypeInformation
#>