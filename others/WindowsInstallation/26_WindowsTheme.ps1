Import-Module (Join-Path $PSScriptRoot '..\..\modules\Gucu112.Powershell.Utility\Gucu112.Powershell.Utility.psd1')

#Start-Process -FilePath 'C:\Windows\Resources\Themes\dark.theme'

$HKCU_Policy_CloudContent = 'HKCU:\Software\Policies\Microsoft\Windows\CloudContent'

Add-ItemProperty -Path $HKCU_Policy_CloudContent `
    -Name 'DisableWindowsSpotlightFeatures' `
    -PropertyType DWord -Value 1

# https://github.com/dlwyatt/PolicyFileEditor
