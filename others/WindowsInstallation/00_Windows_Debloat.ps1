$Config = @{
    Version  = "1.0"
    Settings = @(
        @{ Name = "CreateRestorePoint";        Value = $true }
        @{ Name = "RemoveApps";                Value = $true }
        @{ Name = "Apps";                      Value = "Default" }
        @{ Name = "RemoveCommApps";            Value = $true }
        @{ Name = "RemoveW11Outlook";          Value = $true }
        @{ Name = "RemoveGamingApps";          Value = $true }
        @{ Name = "DisableDVR";                Value = $true }
        @{ Name = "DisableGameBarIntegration"; Value = $true }
        @{ Name = "DisableTelemetry";          Value = $true }
        @{ Name = "DisableSuggestions";        Value = $true }
        @{ Name = "DisableEdgeAds";            Value = $true }
        @{ Name = "DisableSettings365Ads";     Value = $true }
        @{ Name = "DisableLockscreenTips";     Value = $true }
        @{ Name = "DisableBing";               Value = $true }
        @{ Name = "DisableCopilot";            Value = $true }
        @{ Name = "DisableRecall";             Value = $true }
        @{ Name = "DisableClickToDo";          Value = $true }
        @{ Name = "DisableEdgeAI";             Value = $true }
        @{ Name = "DisablePaintAI";            Value = $true }
        @{ Name = "DisableNotepadAI";          Value = $true }
        @{ Name = "DisableDesktopSpotlight";   Value = $true }
        @{ Name = "EnableDarkMode";            Value = $true }
        @{ Name = "DisableStickyKeys";         Value = $true }
        @{ Name = "ClearStartAllUsers";        Value = $true }
        @{ Name = "DisableStartPhoneLink";     Value = $true }
        @{ Name = "TaskbarAlignLeft";          Value = $true }
        @{ Name = "HideSearchTb";              Value = $true }
        @{ Name = "HideTaskview";              Value = $true }
        @{ Name = "DisableWidgets";            Value = $true }
        @{ Name = "CombineTaskbarWhenFull";    Value = $true }
        @{ Name = "CombineMMTaskbarWhenFull";  Value = $true }
        @{ Name = "MMTaskbarModeActive";       Value = $true }
        @{ Name = "ExplorerToThisPC";          Value = $true }
        @{ Name = "ShowKnownFileExt";          Value = $true }
        @{ Name = "AddFoldersToThisPC";        Value = $true }
        @{ Name = "HideDupliDrive";            Value = $true }
    )
}

$ConfigDir = Join-Path -Path $env:TEMP -ChildPath "Win11Debloat"
New-Item -Path $ConfigDir -ItemType Directory -Force | Out-Null
$ConfigPath = Join-Path -Path $ConfigDir -ChildPath "LastUsedSettings.json"
$Config | ConvertTo-Json -Depth 5 | Out-File -FilePath $ConfigPath -Encoding UTF8

& ([scriptblock]::Create((Invoke-RestMethod "https://debloat.raphi.re/"))) `
    -Silent -Sysprep -RunSavedSettings
