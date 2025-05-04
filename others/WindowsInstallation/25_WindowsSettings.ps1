. (Join-Path $PSScriptRoot '00_Common.ps1')

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
