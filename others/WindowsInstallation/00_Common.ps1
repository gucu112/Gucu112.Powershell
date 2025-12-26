Import-Module (Join-Path $PSScriptRoot '..\..\modules\Gucu112.Powershell.Utility\src\Test-ItemProperty.psm1')

# TODO: Move to Utility module
function Add-ItemProperty {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Path,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $PropertyType,

        [Parameter()]
        [string]
        $Value
    )

    if (Test-ItemProperty -Path $Path -Name $Name) {
        Set-ItemProperty -Path $Path -Name $Name -Value $Value
    } else {
        New-ItemProperty -Path $Path -Name $Name -Value $Value `
            -PropertyType $PropertyType
    }
}

#Write-Host 'Get registry hive'
#Get-ChildItem $HKCU_Search

#Write-Host 'Get registry key'
#Get-ItemProperty $HKCU_Search -Name 'SearchboxTaskbarMode'

#Write-Host 'Add registry key'
#New-ItemProperty $HKCU_Search -Name 'SearchboxTaskbarMode' -PropertyType DWORD -Value 0

#Write-Host 'Set registry key'
#Set-ItemProperty $HKCU_Search -Name 'SearchboxTaskbarMode' -Value 2
