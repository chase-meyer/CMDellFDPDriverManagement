
function Get-DellFDPDrivers {
    <#
    .SYNOPSIS
        This function will scrape the Dell Family Driver Pack page and return a table of the data.
        The table can then be used to download the drivers for the models you need.
    .EXAMPLE
        Get-DellFDPDrivers | 
        Where-Object { $_.Family -like '*TGL 5420*' } | 
        Select-Object -ExpandProperty WindowsOSBuildVersion |
        Select-Object -ExpandProperty Win11_22H2 | 
        Select-Object -ExpandProperty URL |
        ForEach-Object { Invoke-WebRequest $_ -OutFile (Split-Path $_ -Leaf) -UseBasicParsing}
    
    #>

    # param (
    #     [string]
    # )

    $ErrorActionPreference = 'SilentlyContinue'

    $HTML = Invoke-RestMethod "https://www.dell.com/support/kbdoc/en-us/000180534/dell-family-driver-packs"

    $CellPattern = '(<td colspan="1" rowspan="1">(?<CellData>.*)</td>|<th colspan="1" rowspan="1">(?<CellDataFamilyGroup>.*)</th>|<td colspan="1" rowspan="1" style="text-align: center;"><strong>(?<CellDataFamilyGroup>.*)</strong></td>)'

    $AllMatches = $HTML | 
    Select-String $CellPattern -AllMatches | 
    Select-Object -ExpandProperty Matches

    $Table = @()

    $Row = [PSCustomObject]@{
        'FamilyGroup'           = $null
        'Family'                = $null
        'Models'                = $null
        'WindowsOSBuildVersion' = @{
            'Win11_22H2' = @{
                'Version' = $null
                'URL'     = $null
            }
            'Win11_21H2' = @{
                'Version' = $null
                'URL'     = $null
            }
            'Win10_22H2' = @{
                'Version' = $null
                'URL'     = $null
            }
            'Win10_21H1' = @{
                'Version' = $null
                'URL'     = $null
            }
            'Win10_20H2' = @{
                'Version' = $null
                'URL'     = $null
            }
        }
    }

    $i = 1
    $FamilyGroup = $null

    foreach ($Cell in $AllMatches) {

        if ($Cell.Groups.Where{ $_.Name -like 'CellDataFamilyGroup' }.Success) {
            if ($i -eq 1) {
                $FamilyGroup = $Cell.Groups.Where{ $_.Name -like 'CellDataFamilyGroup' }.Value
            }
            elseif ($i -eq 8) {
                $i = 1
                continue
            }
            $i++
        }
        else {
            Switch ($i++ % 8) {
                1 {
                    $Row.'Family' = $Cell.Groups.Where{ $_.Name -like 'CellData' }.Value
                }
                2 {
                    $Row.'Models' = $Cell.Groups.Where{ $_.Name -like 'CellData' }.Value
                }
                3 {
                    $Row.WindowsOSBuildVersion.Win11_22H2.URL = 
                    $Cell.Groups.Where{ $_.Name -like 'CellData' }.Value -replace '.+a href="(.+?)".+', '$1'
                    $Row.WindowsOSBuildVersion.Win11_22H2.Version = 
                    $Cell.Groups.Where{ $_.Name -like 'CellData' }.Value -replace '.+>(.+?)</a>', '$1'
                }
                4 {
                    $Row.WindowsOSBuildVersion.Win11_21H2.URL = 
                    $Cell.Groups.Where{ $_.Name -like 'CellData' }.Value -replace '.+a href="(.+?)".+', '$1'
                    $Row.WindowsOSBuildVersion.Win11_21H2.Version =
                    $Cell.Groups.Where{ $_.Name -like 'CellData' }.Value -replace '.+>(.+?)</a>', '$1'
                }
                5 {
                    $Row.WindowsOSBuildVersion.Win10_22H2.URL = 
                    $Cell.Groups.Where{ $_.Name -like 'CellData' }.Value -replace '.+a href="(.+?)".+', '$1'
                    $Row.WindowsOSBuildVersion.Win10_22H2.Version =
                    $Cell.Groups.Where{ $_.Name -like 'CellData' }.Value -replace '.+>(.+?)</a>', '$1'
                }
                6 {
                    $Row.WindowsOSBuildVersion.Win10_21H2.URL = 
                    $Cell.Groups.Where{ $_.Name -like 'CellData' }.Value -replace '.+a href="(.+?)".+', '$1'
                    $Row.WindowsOSBuildVersion.Win10_21H2.Version =
                    $Cell.Groups.Where{ $_.Name -like 'CellData' }.Value -replace '.+>(.+?)</a>', '$1'
                }
                7 {
                    $Row.WindowsOSBuildVersion.Win10_21H1.URL = 
                    $Cell.Groups.Where{ $_.Name -like 'CellData' }.Value -replace '.+a href="(.+?)".+', '$1'
                    $Row.WindowsOSBuildVersion.Win10_21H1.Version =
                    $Cell.Groups.Where{ $_.Name -like 'CellData' }.Value -replace '.+>(.+?)</a>', '$1'
                }
                0 {
                    $Row.WindowsOSBuildVersion.Win10_20H2.URL = 
                    $Cell.Groups.Where{ $_.Name -like 'CellData' }.Value -replace '.+a href="(.+?)".+', '$1'
                    $Row.WindowsOSBuildVersion.Win10_20H2.Version =
                    $Cell.Groups.Where{ $_.Name -like 'CellData' }.Value -replace '.+>(.+?)</a>', '$1'

                    $Table += $Row

                    $Row = [PSCustomObject]@{
                        'FamilyGroup'           = $FamilyGroup
                        'Family'                = $null
                        'Models'                = $null
                        'WindowsOSBuildVersion' = @{
                            'Win11_22H2' = @{
                                'Version' = $null
                                'URL'     = $null
                            }
                            'Win11_21H2' = @{
                                'Version' = $null
                                'URL'     = $null
                            }
                            'Win10_22H2' = @{
                                'Version' = $null
                                'URL'     = $null
                            }
                            'Win10_21H1' = @{
                                'Version' = $null
                                'URL'     = $null
                            }
                            'Win10_20H2' = @{
                                'Version' = $null
                                'URL'     = $null
                            }
                        }
                    }

                    $i = 1
                }
            }
        }

    }

    Return $Table
}
