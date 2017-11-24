$MissingMembers = Import-Csv MissingMembers.csv

#$MissingMembers = $MissingMembers | Group-Object -Property User

$MissingUsers = @()

foreach ($Member in $MissingMembers) {
    $Mbx = Get-Mailbox $Member.User

    if ($Mbx) {
        Write-Host "$($Member.User) exists" -ForegroundColor Green
        $MissingUsers += [PSCustomObject]@{
            User = $Member.User
            Group = $Member.Group
            HasMailbox = $true
        }
    } else {
        Write-Host "$($Member.User) doesn't exists" -ForegroundColor Red
        $MissingUsers += [PSCustomObject]@{
            User = $Member.User
            Group = $Member.Group
            HasMailbox = $false
        }
    }
}

$MissingUsers | Export-Csv MissingUsers.csv -NoTypeInformation