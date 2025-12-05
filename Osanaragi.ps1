param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Encrypt","Decrypt")]
    [string]$Action,
    
    [Parameter(Mandatory=$true)]
    [string]$Text,
    
    [Parameter(Mandatory=$true)]
    [string]$Key
)

function Invoke-XOR {
    param(
        [byte[]]$Data,
        [string]$Key
    )
    
    $keyBytes = [System.Text.Encoding]::UTF8.GetBytes($Key)
    $result = New-Object byte[] $Data.Length
    
    for ($i = 0; $i -lt $Data.Length; $i++) {
        $result[$i] = $Data[$i] -bxor $keyBytes[$i % $keyBytes.Length]
    }
    
    return $result
}

function Encrypt-Text {
    param(
        [string]$PlainText,
        [string]$Key
    )
    
    try {
        $textBytes = [System.Text.Encoding]::UTF8.GetBytes($PlainText)
        
        $xorResult = Invoke-XOR -Data $textBytes -Key $Key
        
        $base64Result = [Convert]::ToBase64String($xorResult)
        
        return $base64Result
    }
    catch {
        Write-Error "Encryption failed: $_"
        return $null
    }
}

function Decrypt-Text {
    param(
        [string]$EncryptedText,
        [string]$Key
    )
    
    try {
        $base64Bytes = [Convert]::FromBase64String($EncryptedText)
    
        $xorResult = Invoke-XOR -Data $base64Bytes -Key $Key
        
        $plainText = [System.Text.Encoding]::UTF8.GetString($xorResult)
        
        return $plainText
    }
    catch {
        Write-Error "Decryption failed: $_"
        return $null
    }
}

switch ($Action) {
    "Encrypt" {
        $result = Encrypt-Text -PlainText $Text -Key $Key
        if ($result) {
            Write-Host "`nEncrypted Result:" -ForegroundColor Green
            Write-Host $result -ForegroundColor Yellow
            Write-Host "`nCopy the above text for decryption" -ForegroundColor Cyan
        }
    }
    "Decrypt" {
        $result = Decrypt-Text -EncryptedText $Text -Key $Key
        if ($result) {
            Write-Host "`nDecrypted Result:" -ForegroundColor Green
            Write-Host $result -ForegroundColor Yellow
        }
    }
}
