[![Build Status](https://ci.appveyor.com/api/projects/status/3858ojrmi6vlx9t8/branch/master?svg=true)](https://ci.appveyor.com/projects/CMDellFDPDriverManagement/badge/?version=latest)

# CMDellFDPDriverManagement

This is a PowerShell module to that scrapes [Dell Family Driver Packs](https://www.dell.com/support/kbdoc/en-us/000180534/dell-family-driver-packs) and automates download and adding of the FDPs to Microsoft Configuration Manger (SCCM/MECM/MEMCM/MCM). 

**WARNING**:
 * This module is at this moment a Work in Progress. 
 * This module is tightly coupled with [Dell Family Driver Packs](https://www.dell.com/support/kbdoc/en-us/000180534/dell-family-driver-packs) website. Therefore, changes to the site may cause the module to not fuction as intended.

 ## Installation

To intall the module download the repository and copy the CMDellFDPDriverManagement folder to your PSModulePath. For example use the following to add the module to the first PSModulePath listed, this is usally user profile path.

```powershell
git clone https://github.com/chase-meyer/CMDellFDPDriverManagement.git
Set-Location CMDellFDPDriverManagement
Move-Item CMDellFDPDriverManagement $env:PSModulePath.split(';')[0]
Set-Location ..
Remove-Item CMDellFDPDriverManagement -Force
```

This Module is dependent on the PowerShell [ConfigurationManger](https://learn.microsoft.com/en-us/powershell/sccm/overview?view=sccm-ps) module. To verify the Module is installed run the following. 

```powershell
Get-module -ListAvailable | Where-Object {$_.name -eq 'CMDellFDPDriverManagement'}
Import-Module ConfigurationManager, CMDellFDPDriverManagement
```

## Uninstall

To uninstall simply remove the project form the PSModulePath

```powershell
Remove-Item "$($env:PSModulePath.split(';')[0])\CMDellFDPDriverManagement" -Recurse -Force
```