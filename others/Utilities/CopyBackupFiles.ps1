function Get-FileGroup
{
    param (
        [string] $Ext
    )

    $result = switch ($Ext)
    {
        '.pdf'  { 'Dokumenty' }
        '.doc'  { 'Dokumenty' }
        '.docx' { 'Dokumenty' }
        '.odt'  { 'Dokumenty' }
        '.rtf'  { 'Dokumenty' }
        '.txt'  { 'Dokumenty' }

        '.xls'  { 'Arkusze' }
        '.xlsx' { 'Arkusze' }
        '.ods'  { 'Arkusze' }

        '.ppt'  { 'Prezentacje' }
        '.pptx' { 'Prezentacje' }
        '.pps'  { 'Prezentacje' }
        '.odp'  { 'Prezentacje' }

        '.mp4' { 'Wideo' }
        '.mkv' { 'Wideo' }
        '.3gp' { 'Wideo' }

        '.jpg'  { 'Obrazy' }
        '.jpeg' { 'Obrazy' }
        '.gif'  { 'Obrazy' }
        '.png'  { 'Obrazy' }
        '.bmp'  { 'Obrazy' }

        '.svg'  { 'Obrazy\Wektorowe' }
        '.ai'   { 'Obrazy\Illustrator' }
        '.psd'  { 'Obrazy\Photoshop' }
        '.xcf'  { 'Obrazy\Gimp' }

        '.mp3' { 'Muzyka' }
        '.aac' { 'Muzyka' }

        '.zip' { 'Skompresowane' }
        '.rar' { 'Skompresowane' }
        '.7z'  { 'Skompresowane' }

        default { 'Inne' }
    }

    return $result
}

function Copy-FileGroup
{
    param (
        [string] $SourcePath,
        [string] $DestinationPath
    )

    $sourceFiles = Get-ChildItem -Recurse $SourcePath `
        | Where-Object { -not $_.PSIsContainer } `
        | ForEach-Object {
            Add-Member -InputObject $_ `
                -MemberType NoteProperty `
                -Name 'Group' `
                -Value (Get-FileGroup -Ext $_.Extension) `
                -PassThru
            $_
        }

    # $sourceFiles | Format-Table -Property Extension, Group

    # $sourceFiles | Where { $_.Group -eq 'Inne' } | Format-Table -Property Extension, Group

    $SourcePath = $SourcePath.TrimEnd('') +  ''

    $sourceFiles | ForEach-Object {

        $groupDestinationPath = (Join-Path $DestinationPath -ChildPath $_.Group)
        if (-not (Test-Path $groupDestinationPath -PathType Container)) {
            New-Item $groupDestinationPath -ItemType Directory -Verbose  Out-Null
        }

        $folderDestinationName = (Split-Path $SourcePath -Qualifier)[0] + '_' + (Split-Path $SourcePath -Leaf)
        $folderDestinationPath = (Join-Path $groupDestinationPath -ChildPath $folderDestinationName)
        if (-not (Test-Path $folderDestinationPath -PathType Container)) {
            New-Item $folderDestinationPath -ItemType Directory -Verbose  Out-Null
        }

        $currentSourcePath = $_.FullName
        $currentDestinationPath = (Join-Path -Path $folderDestinationPath `
            -ChildPath $_.FullName.Replace($SourcePath, '').Replace('', '__'))
        if (-not (Test-Path $currentDestinationPath -PathType Leaf)) {
            Copy-Item -Path $currentSourcePath -Destination $currentDestinationPath -Verbose
        }
    }
}

$sourcePaths = 'G:\_Pobrane', 'G:\_Pulpit', 'G:\Users\Kanapka\Documents', 'G:\Users\Kanapka\Pictures', `
    'H:\Pulpit', 'H:\Dokumenty', 'H:\Obrazy', 'H:\Pobrane'

$destinationPath = 'E:\Others\Beata'

foreach ($path in $sourcePaths)
{
    Copy-FileGroup -SourcePath $path -DestinationPath $destinationPath
}
