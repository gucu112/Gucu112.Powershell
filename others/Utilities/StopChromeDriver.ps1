[CmdletBinding()]

Param (
    [string]$SeleniumGridUrl
)

If ($SeleniumGridUrl -eq [string]::Empty)
{
    Write-Error 'Hub URL is not set.'
    Exit 1
}

$hubConnect = Invoke-WebRequest `
    -Uri "$($SeleniumGridUrl.TrimEnd('/'))/grid/api/hub" `
    -UseBasicParsing

If ($null -eq $hubConnect)
{
    Write-Error 'Unable to connect to the hub.'
    Exit 1
}

$hubParameters = ConvertFrom-Json `
    -InputObject $hubConnect

If ($hubParameters.slotCounts.free -lt $hubParameters.slotCounts.total)
{
    Write-Error 'Hub is busy. Please try again later.'
    Exit 1
}
Else
{
    Get-Process | Where-Object {$_.ProcessName -eq 'chrome' -or $_.ProcessName -eq 'chromedriver'} | Stop-Process -Force
}
