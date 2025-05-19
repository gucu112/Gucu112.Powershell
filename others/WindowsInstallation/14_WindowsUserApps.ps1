Import-Module -Name 'Microsoft.WinGet.Client'

# Uninstall Xbox related apps
Get-WinGetPackage -Query 'Xbox' -Source winget | Uninstall-WinGetPackage

# Install Adobe Acrobat Reader DC
Find-WinGetPackage -Id 'Adobe.Acrobat.Reader.64-bit' -MatchOption Equals -Source winget | Install-WinGetPackage -Mode Silent

# Install Outlook & OneNote
Find-WinGetPackage -Name 'Outlook for Windows' -MatchOption Equals -Source msstore | Install-WinGetPackage -Mode Silent
Find-WinGetPackage -Name 'OneNote' -MatchOption Equals -Source msstore | Install-WinGetPackage -Mode Silent

# Install Google Chrome
Find-WinGetPackage -Id 'Google.Chrome' -MatchOption Equals -Source winget | Install-WinGetPackage -Mode Silent

# Install Spotify & VLC
Find-WinGetPackage -Name 'Spotify' -MatchOption Equals -Source winget | Install-WinGetPackage -Mode Silent
Find-WinGetPackage -Id 'VideoLAN.VLC' -MatchOption Equals -Source winget | Install-WinGetPackage -Mode Silent

# Install utility apps
Find-WinGetPackage -Id 'TreeSize.Free' -Source winget | Install-WinGetPackage -Mode Silent
Find-WinGetPackage -Name 'WinMerge' -MatchOption Equals -Source winget | Install-WinGetPackage -Mode Silent

# Update WinGet packages
Get-WinGetPackage | Where-Object IsUpdateAvailable | Update-WinGetPackage -Mode Silent
