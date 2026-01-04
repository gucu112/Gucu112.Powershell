Import-Module -Name 'Microsoft.WinGet.Client'

# Update Windows Terminal
Get-WinGetPackage -Id 'Microsoft.WindowsTerminal' -MatchOption Equals -Source winget | Where-Object IsUpdateAvailable | Update-WinGetPackage -Mode Silent

# Install Sysinternals Suite
Install-WinGetPackage -Id 'Microsoft.Sysinternals' -Source winget -Location "C:\Windows\Sysinternals" -Mode Silent
# Update specific version of Autoruns
# Get-WinGetPackage -Id 'Microsoft.Sysinternals.Autoruns' -MatchOption Equals -Source winget | Update-WinGetPackage -Version '14.10' -Mode Silent

# Install Docker & Kubernetes
Install-WinGetPackage -Name 'Docker CLI' -MatchOption Equals -Source winget -Mode Silent
Install-WinGetPackage -Id 'Kubernetes.minikube' -MatchOption Equals -Source winget -Mode Silent

# TODO: Configure docker with minikube
#Requires -RunAsAdministrator
dockerd --register-service
# minikube start --driver=docker

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

# TODO: Remove shortcut from "C:\Users\BasowQA\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Git.lnk"
# TODO: Maybe backup SSH key (or whole .ssh directory) to the cloud or locally
# TODO: Format windows to unix path - as I did in Selenoid local install script
# TODO: Resolve path that does not exist
# https://blog.danskingdom.com/Resolve-PowerShell-paths-that-do-not-exist/

# Install Visual Studio Code
$codeAddTasks = "!runcode,addcontextmenufiles,addcontextmenufolders"
Find-WinGetPackage -Id 'Microsoft.VisualStudioCode' -MatchOption Equals -Source winget `
    | Install-WinGetPackage -Override "/VERYSILENT /NOCANCEL /NORESTART /MERGETASKS=`"$codeAddTasks`""
