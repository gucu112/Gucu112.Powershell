#Requires -RunAsAdministrator

Get-WindowsOptionalFeature -Online | Format-Table

Disable-WindowsOptionalFeature -FeatureName 'WindowsMediaPlayer' -Online

$hypervisorFeatures = @(
    'HypervisorPlatform'
    'VirtualMachinePlatform'
    'Microsoft-Windows-Subsystem-Linux'
)
Enable-WindowsOptionalFeature -FeatureName $hypervisorFeatures -Online -NoRestart
