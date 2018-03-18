Param(
    [string]$CsvPath="SendOnBehalfOf.csv"
)

$Mbxs = Get-Mailbox -ResultSize unlimited
$Permissions = Import-Csv $CsvPath

foreach ($Permission in $Permissions) {
    if ($Permission.Trustee -like "*;*") {
        $Trustees = $Permission.Trustee.Split(";")
        foreach ($Trustee in $Trustees) {
            write-host "Granting $($Trustee) the ability to send on behalf of $($Permission.Identity)" -ForegroundColor Green
            Set-Mailbox $Permission.Identity -GrantSendOnBehalfTo @{Add=$Trustee} -Confirm:$false
        }
    } else {
        write-host "Granting $($Permission.Trustee) the ability to send on behalf of $($Permission.Identity)" -ForegroundColor Green
        Set-Mailbox $Permission.Identity -GrantSendOnBehalfTo @{Add=$Permission.Trustee} -Confirm:$false
    }
}
