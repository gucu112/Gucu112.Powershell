Import-Module (Join-Path $PSScriptRoot '..\..\modules\Gucu112.Powershell.Utility\Gucu112.Powershell.Utility.psd1')

# System -> Display -> Ease cursor movement between displays
# TODO

# System -> Display -> Scale
# TODO

# Task bar search settings
$HKCU_Search = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search'

# Show (2) or Hide (0) task bar search
Add-ItemProperty -Path $HKCU_Search -Name 'SearchboxTaskbarMode' -PropertyType DWord -Value 0

# Task bar explorer settings
$HKCU_Explorer_Advanced = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'

# Left (0) or Center (1) task bar alignment
Add-ItemProperty -Path $HKCU_Explorer_Advanced -Name 'TaskbarAl' -PropertyType DWord -Value 0

# Hide (0) or Show (1) task view button
Add-ItemProperty -Path $HKCU_Explorer_Advanced -Name 'ShowTaskViewButton' -PropertyType DWord -Value 0

# Explorer enable libraries
# TODO: Show libraries in the navigation pane

# Clipboard history settings
# TODO: Turn on clipboard history (Win+V)

# Policy explorer settings
$HKLM_Policies_Explorer = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'

# Disable all apps in start menu
Add-ItemProperty -Path $HKLM_Policies_Explorer -Name 'NoStartMenuMorePrograms' -PropertyType DWord -Value 1

# Phone link sidebar settings
$HKCU_YourPhone = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Start\Companions\Microsoft.YourPhone_8wekyb3d8bbwe'

# Disable phone link sidebar
Add-ItemProperty -Path $HKCU_YourPhone -Name 'IsEnabled' -PropertyType DWord -Value 0
