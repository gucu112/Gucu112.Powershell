function Test-ItemProperty {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter()]
        [string]
        $Name
    )

    $isContainer = Test-Path -Path $Path -PathType Container
    if (-not $isContainer) {
        return $false
    }

    if ([string]::IsNullOrEmpty($Name)) {
        return $true
    }

    $itemProperties = Get-ItemProperty -Path $Path
    if (-not $itemProperties) {
        return $false
    }

    $objectMembers = $itemProperties | Get-Member -Name $Name
    if (-not $objectMembers) {
        return $false
    }

    return $true
}
