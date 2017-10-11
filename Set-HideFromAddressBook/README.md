# Set-HideFromAddressBook

Grants a organization the ability to hide a user from the Office 365 address book. This script and configuration is only needed on sync-only configurations that have not had Exchange AD updates ran on their local AD.

## Setup

1. Configure AD Connect Sync rules to include a rule `IIF([msDS-cloudExtensionAttribute1] = "TRUE", True, False)` to set the `Set-msExchHideFrommAddressLists` property. See image AD-Connect-Rule-To-Set-msExchHideFrommAddressLists.jpg
2. Update the AD Connect connector to include the `msDS-cloudExtensionAttribute1` attribute. See image AD-Connect-Connector-Update.jpg
3. Update any user's `msDS-cloudExtensionAttribute1` attribute to `TRUE` to hide the user from the address book.
