<#
.DESCRIPTION
Set-ExecutionPolicy unrestricted
Copy script to C:\Scripts
Create Task
    Run whether user is logged on or not
    Schedule daily
    Stop task if it runs longer than 1 hour
    Action: Start a program
    Program/script: Powershell.exe
    Arguments: C:\Scripts\Set-CustomFieldToOu.ps1

.VERSION
1.01
#>

$LogFile = 'C:\Scripts\CustomFieldToOu.txt'

$Log = "Starting script $(Get-Date)`r`n"
Import-Module ActiveDirectory
$users = Get-ADUser -Filter * -Properties Name,distinguishedname,cn,extensionAttribute3

foreach ($user in $users) {
    $distName = $user.DistinguishedName.split(',')
    $path = ""

    for($i=1; $i -lt $distName.count - 3; $i++) {
        $path = $distName[$i].split('=')[1] + "/" + $path
    }

    if ($user.extensionAttribute3 -ne $path) {
        $Log = $Log + "     $(Get-Date) $($user.DistinguishedName): $($user.extensionAttribute3) - $path`r`n"
        $user | SET-ADUSER –replace @{extensionAttribute3=$path}
    }
}

$Log > $LogFile
Send-MailMessage -To "john.gruber@tierpoint.com" -From "tierpoint@handyharman.com" -Subject "Set-CustomFieldToOu Log" -Body $Log -SmtpServer localhost