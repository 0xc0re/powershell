<#

.LINK
https://technet.microsoft.com/en-us/library/dd298062(v=exchg.160).aspx
#>

$Permission = "PublishingEditor"
$GrantToUser = ""
$DestinationMailbox = ""
$Folder = "Calendar"

Add-MailboxFolderPermission -Identity "$($DestinationMailbox):\$($Folder)" -User $GrantToUser -AccessRights $Permission