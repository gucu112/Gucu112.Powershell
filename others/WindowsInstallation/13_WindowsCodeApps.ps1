# TODO: Include this module as required in PackageManagement module
# Install-Module -Name 'Microsoft.WinGet.Client'
Import-Module -Name 'Microsoft.WinGet.Client'

# TODO: Move to InstallPackageManagement script
Add-WinGetSource -Name winget -Argument https://cdn.winget.microsoft.com/cache -Type Microsoft.PreIndexed.Package
Add-WinGetSource -Name msstore -Argument https://storeedgefd.dsx.mp.microsoft.com/v9.0 -Type Microsoft.Rest

# TODO: Move to documentation
# Inno Setup Parameters
# https://jrsoftware.org/ishelp/index.php?topic=setupcmdline

# Install Sysinternals Suite
Find-WinGetPackage -Id 'Microsoft.Sysinternals' -Source winget | Install-WinGetPackage -Location "C:\Windows\Sysinternals" -Mode Silent
# Install specific version of Autoruns
# Find-WinGetPackage -Id 'Microsoft.Sysinternals.Autoruns' -Source winget | Update-WinGetPackage -Version '14.10' -Mode Silent

# Install Git for Windows
$gitOptionsPath = (Resolve-Path "~\OneDrive\Settings\Git\git_options.ini").Path
Find-WinGetPackage -Id 'Microsoft.Git' -MatchOption Equals -Source winget `
    | Install-WinGetPackage -Override "/VERYSILENT /NOCANCEL /NORESTART /LOADINF=`"$gitOptionsPath`""
# Copy Git configuration
$gitConfigPath = "~\OneDrive\Settings\Git\.gitconfig"
Copy-Item -Path $gitConfigPath -Destination "~\.gitconfig"
# Create SSH key
$bashPath = "C:\Program Files\Git\bin\bash.exe"
$gitEmail = $(git config user.email)
& $bashPath -c "ssh-keygen -t ed25519 -C '$gitEmail' -f '/c/Users/${env:USERNAME}/.ssh/id_ed25519' -N ''"
# ssh-keygen -t ed25519 -C "$gitEmail" -f "/c/Users/BasowQA/.ssh/id_ed25519" -N '""'

# TODO: Maybe backup SSH key (or whole .ssh directory) to the cloud or locally
# TODO: Format windows to unix path - as I did in Selenoid local install script
# TODO: Resolve path that does not exist
# https://blog.danskingdom.com/Resolve-PowerShell-paths-that-do-not-exist/

# Install Visual Studio Code
$codeAddTasks = "!runcode,addcontextmenufiles,addcontextmenufolders"
Find-WinGetPackage -Id 'Microsoft.VisualStudioCode' -MatchOption Equals -Source winget `
    | Install-WinGetPackage -Override "/VERYSILENT /NOCANCEL /NORESTART /MERGETASKS=`"$codeAddTasks`""
