S1PowershellAPI
=============

This is a rudimentary PowerShell module for querying the [SentinelOne API](https://<tenant>.sentinelone.net/apidocs). 

This is not fully featured or tested, but pull requests would be welcome!

#Instructions

```powershell
# One time setup
    # Download the repository
    # Unzip/unblock the zip
    # Extract the S1PowershellAPI folder to a module path (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\
    # Edit 'Config.xml' with your API key and Tenant name. The tenant will be the first part in your url <tenant>.sentinelone.net

# Import the module.
    Import-Module S1PowershellAPI    #Alternatively, Import-Module \\Path\To\S1PowershellAPI

# Get commands in the module
    Get-Command -Module S1PowershellAPI

# Get help
    Get-Help -Name S1PowershellAPI

#Set API Key and Tenant (if you didnt edit the Config.xml manually)
    Set-S1APIKey -APIKey 0000000000000000000000
    Set-S1Tenant -Tenant <tenant>
```

#Examples

### Find Applications Installed

```PowerShell

Get-S1Apps -AppName teamviewer

```

### Search for Users and their Machines

```PowerShell

Get-S1Agent -Query <username>

```
