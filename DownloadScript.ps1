Import-Module ConfigurationManager

Set-Location :

$HTML = Invoke-RestMethod "https://www.dell.com/support/kbdoc/en-us/000180534/dell-family-driver-packs"

$CellPattern = '<td colspan="1" rowspan="1">(?<CellData>.*)</td>'

$AllMatches = $HTML | 
    Select-String $CellPattern -AllMatches | 
        Select-Object -ExpandProperty Matches

$Table = @()

$Row = [PSCustomObject]@{
    'Family' = $null
    'Models' = $null
    'Win11_22H2' = $null
    'Win11_21H2' = $null
    'Win10_22H2' = $null
    'Win10_21H1' = $null
    'Win10_20H2' = $null
}

$i = 1

foreach ($Cell in $AllMatches)
{
    $i++
    Switch ($i % 8) {
        1 {
            $Row.'Family' = $Cell.Groups.Where{$_.Name -like 'CellData'}.Value
        }
        2 {
            $Row.'Models' = $Cell.Groups.Where{$_.Name -like 'CellData'}.Value
        }
        3 {
            $Row.'Win11_22H2' = $Cell.Groups.Where{$_.Name -like 'CellData'}.Value        
            $Row.'Win11_22H2' = $Row.'Win11_22H2' -replace '.+a href="(.+?)".+', '$1'
        }
        4 {
            $Row.'Win11_21H2' = $Cell.Groups.Where{$_.Name -like 'CellData'}.Value        
            $Row.'Win11_21H2' = $Row.'Win11_21H2' -replace '.+a href="(.+?)".+', '$1'
        }
        5 {
            $Row.'Win10_22H2' = $Cell.Groups.Where{$_.Name -like 'CellData'}.Value        
            $Row.'Win10_22H2' = $Row.'Win10_22H2' -replace '.+a href="(.+?)".+', '$1'
        }
        6 {
            $Row.'Win10_21H2' = $Cell.Groups.Where{$_.Name -like 'CellData'}.Value
            $Row.'Win10_21H2' = $Row.'Win10_21H2' -replace '.+a href="(.+?)".+', '$1'
        }
        7 {
            $Row.'Win10_21H1' = $Cell.Groups.Where{$_.Name -like 'CellData'}.Value        
            $Row.'Win10_21H1' = $Row.'Win10_21H1' -replace '.+a href="(.+?)".+', '$1'
        }
        0 {
            $Row.'Win10_20H2' = $Cell.Groups.Where{$_.Name -like 'CellData'}.Value
            $Row.'Win10_20H2' = $Row.'Win10_20H2' -replace '.+a href="(.+?)".+', '$1'

            $Table += $Row

            $Row = [PSCustomObject]@{
                'Family' = $null
                'Models' = $null
                'Win11_22H2' = $null
                'Win11_21H2' = $null
                'Win10_22H2' = $null
                'Win10_21H2' = $null
                'Win10_21H1' = $null
                'Win10_20H2' = $null
            }

            $i = 0
        }
    }
}

# function Get-HrefFromAnchorString {
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory, ValueFromPipeline)]
#         [string]$Anchor -replace '.+a href="(.+?)".+', '$1'
#     )

#     PROCESS {

#         Write-Output ($Anchor -replace '.+a href="(.+?)".+', '$1')

#     }

# }

$Src = $Table | 
    Where-Object {$_.Models -like "*7230*"} | 
        Select-Object Win10_21H2 

$Dest = ""
$Dest = $Dest + $Src | Split-Path -Leaf

Invoke-WebRequest -Uri $Src -OutFile $Dest -UseBasicParsing

