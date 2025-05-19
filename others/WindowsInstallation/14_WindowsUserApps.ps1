Import-Module -Name 'Microsoft.WinGet.Client'

# Uninstall Windows related apps
# TODO: Check if these can be removed by debloater
Get-WinGetPackage -Query 'Dev Home' | Uninstall-WinGetPackage
Get-WinGetPackage -Query 'Xbox' | Uninstall-WinGetPackage
Get-WinGetPackage -Query 'OneDrive' | Uninstall-WinGetPackage
# Get-WinGetPackage -Query 'Edge' | Uninstall-WinGetPackage

# Install Adobe Acrobat Reader DC
Install-WinGetPackage -Id 'Adobe.Acrobat.Reader.64-bit' -MatchOption Equals -Source winget -Mode Silent

# Install Microsoft apps
Install-WinGetPackage -Name 'Microsoft OneDrive' -MatchOption Equals -Source winget -Mode Silent
Install-WinGetPackage -Name 'Outlook for Windows' -MatchOption Equals -Source msstore -Mode Silent
Install-WinGetPackage -Name 'OneNote' -MatchOption Equals -Source msstore -Mode Silent

# Install Browser apps
Install-WinGetPackage -Id 'Microsoft.Edge' -MatchOption Equals -Source winget -Mode Silent
Install-WinGetPackage -Id 'Google.Chrome' -MatchOption Equals -Source winget -Mode Silent
# Install-WinGetPackage -Id 'Mozilla.Firefox' -MatchOption Equals -Source winget -Mode Silent
# Install-WinGetPackage -Id 'Opera.OperaGX' -MatchOption Equals -Source winget -Mode Silent

# Install Audio & Video apps
Find-WinGetPackage -Name 'Spotify' -MatchOption Equals -Source winget | Install-WinGetPackage -Mode Silent
Find-WinGetPackage -Id 'VideoLAN.VLC' -MatchOption Equals -Source winget | Install-WinGetPackage -Mode Silent

# Install Utility apps
Find-WinGetPackage -Id 'TreeSize.Free' -Source winget | Install-WinGetPackage -Mode Silent
Find-WinGetPackage -Name 'WinMerge' -MatchOption Equals -Source winget | Install-WinGetPackage -Mode Silent

# Update WinGet packages
Get-WinGetPackage | Where-Object IsUpdateAvailable | Update-WinGetPackage -Mode Silent
