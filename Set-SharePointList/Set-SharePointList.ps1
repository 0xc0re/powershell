<#
.SYNOPSIS
Update a list in SharePoint

.DESCRIPTION
Prerequisite: http://www.microsoft.com/en-us/download/details.aspx?id=42038

.LINK
https://social.technet.microsoft.com/wiki/contents/articles/29518.csom-sharepoint-powershell-reference-and-example-codes.aspx
http://jeffreypaarhuis.com/2012/06/07/scripting-sharepoint-online-with-powershell-using-client-object-model/
#>

Import-Module 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll'

#Mysite URL
$site = 'https://gitbit.sharepoint.com/sites/office365'

#Admin User Principal Name
$admin = 'John.Doe@gitbit.org'

#Get Password as secure String
$password = ConvertTo-SecureString -AsPlainText -Force -String 'Pass@word1'

#Get the Client Context and Bind the Site Collection
$context = New-Object Microsoft.SharePoint.Client.ClientContext($site)

#Authenticate
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($admin , $password)
$context.Credentials = $credentials

#Get List
$list = $context.Web.Lists.GetByTitle('test')
$context.Load($list)

<# update list description
$list.Description = "I Updated a list!"
$list.Update()
$context.ExecuteQuery()
#>

$ListItemCreationInformation = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
$NewListItem = $list.AddItem($ListItemCreationInformation)
$NewListItem["Title"] = 'Russ will love that I can send monitoring alerts directly to SharePoint!'
$NewListItem.Update()
$context.ExecuteQuery()