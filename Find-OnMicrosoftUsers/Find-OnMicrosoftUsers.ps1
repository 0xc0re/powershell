<#
.SYNOPSIS
Find any users that have a UPN or primary email address of onmicrosoft.com

#>

$Users = Get-MsolUser -All

$BadUpn = $Users | where {$_.UserPrincipalName -like "*onmicrosoft.com"}
$BadSMTP = @()

foreach ($User in $Users) {
    $Addresses = $User.ProxyAddresses

    foreach ($Address in $Addresses) {
        if ($Address -like "*onmicrosoft.com" -and $Address -clike "SMTP:*") {
            $BadSMTP += $User
            break
        }
    }
}

Write-Host 'BAD UPN' -ForegroundColor Red
$BadUpn | ft
Write-Host ""

Write-Host 'Bad SMTP' -ForegroundColor Red
$BadSMTP | ft
Write-Host ""

$BadUpn | Export-Csv BadUpn.csv -NoTypeInformation
$BadSMTP | Export-Csv BadSmtp.csv -NoTypeInformation