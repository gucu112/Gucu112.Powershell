# https://superuser.com/questions/1193985/command-line-code-to-pin-program-to-taskbar-windows-10

# %AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar

function New-ShortcutItem {
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$TargetPath,

        # [Parameter]
        [string]$Arguments = $null,

        # [Parameter]
        [string]$WorkingDirectory = ($TargetPath | Split-Path),

        # [Parameter]
        [string]$IconFilePath = $TargetPath

        # [Parameter]
        # [switch] $Remove
    )

    $wshShell = New-Object -ComObject Wscript.Shell -ErrorAction Stop
    $menuStart = $wshShell.SpecialFolders.Item('Programs')
    $shortcut = $wshShell.CreateShortcut((Join-Path $menuStart "$Name.lnk"))

    # If ($Remove.IsPresent) {
    #     $shortcut.FullName | Remove-Item
    #     Exit
    # }

    $shortcut.TargetPath = $TargetPath
    $shortcut.Arguments = $Arguments
    $shortcut.IconLocation = $IconFilePath
    $shortcut.Description = $null
    $shortcut.WorkingDirectory = $WorkingDirectory
    $shortcut.Save()
}

# New-ShortcutItem -Name 'WinMerge Test' -TargetPath "C:\Users\BasowQA\AppData\Local\Programs\WinMerge\WinMergeU.exe"
