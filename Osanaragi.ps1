function Invoke-Crypto {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Text,
        
        [Parameter(Mandatory=$true)]
        [string]$Key,
        
        [switch]$Decrypt
    )
    
    $keyBytes = [System.Text.Encoding]::UTF8.GetBytes($Key)
    
    if ($Decrypt) {
        # Decode Base64
        $data = [Convert]::FromBase64String($Text)
        
        # XOR Decryption
        for ($i = 0; $i -lt $data.Length; $i++) {
            $data[$i] = $data[$i] -bxor $keyBytes[$i % $keyBytes.Length]
        }
        
        return [System.Text.Encoding]::UTF8.GetString($data)
    }
    else {
        # Convert to bytes
        $data = [System.Text.Encoding]::UTF8.GetBytes($Text)
        
        # XOR Encryption
        for ($i = 0; $i -lt $data.Length; $i++) {
            $data[$i] = $data[$i] -bxor $keyBytes[$i % $keyBytes.Length]
        }
        
        # Convert to Base64
        return [Convert]::ToBase64String($data)
    }
}
