# TODO: Check if working and if requires elevated privileges
$firstLocalUser = Get-LocalUser | Where-Object Enabled | Select-Object -First 1
$firstLocalUser | Rename-LocalUser -NewName 'PC'

# Restart-Computer
