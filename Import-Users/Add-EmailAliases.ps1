<#
.SYNOPSIS
Add email aliases to Office 365 mailboxes

.DESCRIPTION
Import users to Office 365
Connect to Office 365
cd to working directory (import csv should be in working location and it will create the output file in this location.)
Run (Get-MsolAccountSku) to get the license sku
map input csv to fields
#>

$InputPath = "mailboxes.csv"

Import-Csv -Path $InputPath | foreach {
    Write-Host $_.EmailAddress -ForegroundColor Green
    $UserUPN = $_.EmailAddress
    $EmailAddresses = $_.EmailAddresses

    $Mbx = Get-Mailbox $UserUPN

    if ($Mbx) {
        forEach ($Email in $EmailAddresses.split(",")) {
            if ($UserUPN -ne $Email -and $Email.EndsWith("redlion.com") -eq $false) {
                $Mbx | Set-Mailbox -EmailAddresses @{add=$Email}
            }
        }
    } else {
        $Error = "Couldn't find mailbox: $($UserUPN)"
        Write-Host $Error -ForegroundColor Red
    }
}