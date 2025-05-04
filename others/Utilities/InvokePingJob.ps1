$ping = {
    param($address)
    Test-Connection -ComputerName $address -Count 1
}

$dataTable = @()
$destination = "google.com"
$intervalInSec = 1
$endDate = [DateTime]'2025-05-04 22:20'
$startDate = Get-Date
Write-Host "Ping $destination every $intervalInSec second(s) until $($endDate.ToString('yyyy-MM-dd HH:mm'))"
do
{
    $currentDate = Get-Date
    $request = Start-Job -ScriptBlock $ping -ArgumentList $destination
    Wait-Job -Job $request -Timeout $intervalInSec | Out-Null
    $response = Receive-Job -Job $request
    Remove-Job -Job $request
    $waitTimeInMs = ($intervalInSec * 1000) - $((Get-Date) - $currentDate).TotalMilliseconds
    $response = $response | Add-Member -MemberType NoteProperty -Name WaitTime -Value ([math]::Round($waitTimeInMs)) -PassThru
    $response = $response | Select-Object -Property Address, IPV4Address, ResponseTime, WaitTime
    Write-Host "Ping $($response.Address) ($($response.IPV4Address)) in $($response.ResponseTime) ms (wait $($response.WaitTime) ms)"
    Start-Sleep -Milliseconds $waitTimeInMs
    $dataTable += $response
}
while ((Get-Date) -lt $endDate)
Write-Host "Ping google.com $($data.Count) times in $((Get-Date) - $startDate)"
$dataTable | Format-Table
