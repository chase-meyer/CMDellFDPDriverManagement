function Download-DellFDPDriver {
    <#
    .SYNOPSIS
        Download Dell FDP Drivers from Dell's website
    .EXAMPLE
        Download-DellFDPDriver -Model "Latitude 7280"
    .EXAMPLE
        Get-DellFDPDriver -Model "Latitude 7280" | Download-DellFDPDriver
    #>
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
Where-Object { $_.Models -like "*7230*" } | 
Select-Object Win10_21H2 

$Dest = ""
$Dest = $Dest + $Src | Split-Path -Leaf

Invoke-WebRequest -Uri $Src -OutFile $Dest -UseBasicParsing

