# TODO: Try to elevate administration rights

$firstLocalUser = Get-LocalUser | Where-Object Enabled | Select-Object -First 1
$firstLocalUser | Rename-LocalUser -NewName 'PC'

# TODO: Try to rename user folder as well

# Restart-Computer
