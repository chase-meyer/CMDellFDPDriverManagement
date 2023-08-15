Import-Module ConfigurationManager


$FDPPath = ""

$driverFolders = Get-ChildItem -Directory -Path "Microsoft.PowerShell.Core\FileSystem::$drivePath"

$FDPToAdd = $driverFolders.Name | 
    ForEach-Object { 
        Get-CMDriverPackage -Name $_ -Fast | Where-Object {$_.PackageSize -eq 0}
    } 

$FDPToAdd | ForEach-Object {
    $drivers = Import-CMDriver -Path "$($drivePath)\$($_.Name)" -ImportFolder -AdministrativeCategoryName $_.name -ImportDuplicateDriverOption AppendCategory -EnableAndAllowInstall $True |
        Select-Object *
    Add-CMDriverToDriverPackage -DriverId $drivers.CI_ID -DriverPackageName $_.Name
} 

