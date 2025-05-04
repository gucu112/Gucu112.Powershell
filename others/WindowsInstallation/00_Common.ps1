# TODO: Move to Utility module

function Test-ItemProperty {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Path,

        [Parameter()]
        [string]
        $Name

        # [Parameter()]
        # [string]
        # $Value
    )

    if (-not (Test-Path -Path $Path -PathType Container)) {
        return $false
    }

    $props = Get-ItemProperty -Path $Path
    if (-not $props) {
        return $false
    }

    $member = $props | Get-Member -Name $Name
    if (-not $member)
    {
        return $false
    }

    $true
}

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