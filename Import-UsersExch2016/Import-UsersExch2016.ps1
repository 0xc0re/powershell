
$UserListPath = "mailboxes.csv"
$DbName = "db01"

Import-Csv -Path $UserListPath | foreach {
    $password = ConvertTo-SecureString -AsPlainText -Force -String $_.password
    write-host $_.alias -ForegroundColor Green
    $mailbox = New-Mailbox -UserPrincipalName $_.EmailAddress -DisplayName $_.DisplayName -FirstName $_.FirstName -LastName $_.LastName -database $DbName -alias $_.alias -ResetPasswordOnNextLogon $true -name $_.alias -password $password
    if ($mailbox) {
        Set-User -Identity $_.alias -Title $_.Title -Department $_.Department
    }
}
