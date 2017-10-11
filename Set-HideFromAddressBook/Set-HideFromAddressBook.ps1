[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=1,ValueFromPipeline=$true)]
    [string]$User,

    [switch]$Hide=$True
)

$Value = 'TRUE'
if ($Hide -eq $false) {
    $Value = 'FALSE'
}
    

set-ADUser -Identity $User -Replace @{"msDS-cloudExtensionAttribute1"='TRUE'}