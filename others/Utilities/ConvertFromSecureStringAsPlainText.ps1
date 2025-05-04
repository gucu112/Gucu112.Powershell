$plainPassword = 'Very$trongPa55'

$toSecureString = ConvertTo-SecureString -String $plainPassword -AsPlainText -Force
$encryptedPassword = ConvertFrom-SecureString -SecureString $toSecureString

Write-Host "Encrypted password:"
Write-Host $encryptedPassword

function ConvertFrom-SecureStringAsPlainText {
    param (
        [Parameter(Mandatory = $true)]
        [System.Security.SecureString]$SecureString
    )
    [System.Net.NetworkCredential]::new("any", $SecureString).Password
}

$fromSecureString = ConvertTo-SecureString -String $encryptedPassword
$decryptedPassword = ConvertFrom-SecureStringAsPlainText -SecureString $fromSecureString

Write-Host "Decrypted password:"
Write-Host $decryptedPassword
