#Write-Host 'Get registry hive'
#Get-ChildItem $HKCU_Search

#Write-Host 'Get registry key'
#Get-ItemProperty $HKCU_Search -Name 'SearchboxTaskbarMode'

#Write-Host 'New registry key'
#New-ItemProperty $HKCU_Search -Name 'SearchboxTaskbarMode' -PropertyType DWord -Value 0

#Write-Host 'Set registry key'
#Set-ItemProperty $HKCU_Search -Name 'SearchboxTaskbarMode' -Value 2

#Write-Host 'Add registry key'
#Add-ItemProperty $HKCU_Search -Name 'SearchboxTaskbarMode' -Value 2
