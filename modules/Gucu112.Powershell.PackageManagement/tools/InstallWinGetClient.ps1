param(
    [string]$Scope = 'CurrentUser',
    [bool]$Force = $false
)

##
# Init
###

Write-Verbose "Installing 'Gucu112.Powershell.PackageManagement' required modules."
Install-Module Microsoft.WinGet.Client -RequiredVersion 1.11.460 -Scope:$Scope -Force:$Force

###
# WinGet
###

# Remove-WinGetSource 'winget'
if ($Force -and (Get-WinGetSource | Where-Object { $_.Name -eq 'winget' })) {
    Remove-WinGetSource -Name 'winget' -ErrorAction Stop
}

# Add-WinGetSource 'winget'
if (-not (Get-WinGetSource | Where-Object { $_.Name -eq 'winget' })) {
    Add-WinGetSource -Name 'winget' -Type 'Microsoft.PreIndexed.Package' `
        -Argument 'https://cdn.winget.microsoft.com/cache' -ErrorAction Stop
}

# Remove-WinGetSource 'msstore'
if ($Force -and (Get-WinGetSource | Where-Object { $_.Name -eq 'msstore' })) {
    Remove-WinGetSource -Name 'msstore' -ErrorAction Stop
}

# Add-WinGetSource 'msstore'
if (-not (Get-WinGetSource | Where-Object { $_.Name -eq 'msstore' })) {
    Add-WinGetSource -Name 'msstore' -Type 'Microsoft.Rest' `
        -Argument 'https://storeedgefd.dsx.mp.microsoft.com/v9.0' -ErrorAction Stop
}

###
# Test
###

$sources = @(Get-WinGetSource | Where-Object { $PSItem.Name -in @('winget', 'msstore') })
$sources | Should -HaveCount 2 -Because "all package sources should be installed"
foreach ($source in $sources) {
    $source | Where-Object { $_.TrustLevel -eq 'Trusted' } | Should -Not -BeNullOrEmpty `
        -Because "package source '$($source.Name)' should be trusted"
}
