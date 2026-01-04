function Test-ItemProperty {
    <#
    .DESCRIPTION
    No description yet.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [Alias('Type')]
        [ValidateSet('String', 'ExpandString', 'MultiString', 'DWord', 'QWord', 'Binary', 'Unknown')]
        [string]
        $PropertyType,

        [Parameter()]
        [object]
        $Value
    )

    $isContainer = Test-Path -Path $Path -PathType "Container"
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

    $objectMember = $itemProperties | Get-Member -Name $Name | Select-Object -First 1
    if (-not $objectMember) {
        return $false
    }

    if ([string]::IsNullOrEmpty($PropertyType) -and [string]::IsNullOrEmpty($Value)) {
        return $true
    }

    $itemObject = Get-Item -Path $Path
    if (-not [string]::IsNullOrEmpty($PropertyType) -and $itemObject.GetValueKind($Name).ToString() -ne $PropertyType) {
        return $false
    }

    if (-not [string]::IsNullOrEmpty($Value) -and -not $itemObject.GetValue($Name).Equals($Value)) {
        return $false
    }

    return $true
}
