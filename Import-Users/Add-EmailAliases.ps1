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

$InputPath = "mbxs.csv"
$ErrorPath = "Add-EmailAliases-Errors.txt"

Import-Csv -Path $InputPath | foreach {
    $UserUPN = $_.EmailAddress
    $EmailAddresses = $_.EmailAddresses

    $Mbx = Get-Mailbox $UserUPN

    if ($Mbx) {
        forEach ($Email in $EmailAddresses.split(" ")) {
            if ($UserUPN -ne $Email -and $Email.EndsWith("serverdata.net") -eq $false) {
                $Mbx | Set-Mailbox -EmailAddresses @{add=$Email}
            }
        }
    } else {
        $Error = "Couldn't find mailbox: $($UserUPN)"
        Write-Host $Error -ForegroundColor Red
        $Error | Out-File -FilePath $ErrorPath -Append
    }
}