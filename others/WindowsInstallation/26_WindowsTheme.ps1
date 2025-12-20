. (Join-Path $PSScriptRoot '00_Common.ps1')

#Start-Process -FilePath 'C:\Windows\Resources\Themes\dark.theme'

$HKCU_Policy_CloudContent = 'HKCU:\Software\Policies\Microsoft\Windows\CloudContent'

Add-ItemProperty -Path $HKCU_Policy_CloudContent `
    -Name 'DisableWindowsSpotlightFeatures' `
    -PropertyType DWord -Value 1

# https://github.com/dlwyatt/PolicyFileEditor
