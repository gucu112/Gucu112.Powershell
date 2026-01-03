function Add-ItemProperty {
    <#
    .DESCRIPTION
    No description yet.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter()]
        [ValidateSet('String', 'ExpandString', 'MultiString', 'DWord', 'QWord', 'Binary', 'Unknown')]
        [string]
        $PropertyType,

        [Parameter(Mandatory)]
        [object]
        $Value
    )

    if (-not (Test-ItemProperty -Path $Path)) {
        throw [System.InvalidOperationException]::new("Path '$Path' does not exist.")
    }

    if (Test-ItemProperty -Path $Path -Name $Name) {
        Set-ItemProperty -Path $Path -Name $Name -Value $Value
    } else {
        if ([string]::IsNullOrEmpty($PropertyType)) {
            $PropertyType = switch ($Value.GetType().Name) {
                'Int32' { 'DWord' }
                'Int64' { 'QWord' }
                'Byte[]' { 'Binary' }
                'Object[]' { 'MultiString' }
                default { 'String' }
            }
        }

        New-ItemProperty -Path $Path -Name $Name -Value $Value `
            -PropertyType $PropertyType | Out-Null
    }
}

Export-ModuleMember -Function Add-ItemProperty
