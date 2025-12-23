$fileName = "rintaro.ps1"
$encryptPath = "E:\myyyykiisaahhhhh\Pembekalan LKS.xlsx"
$key = "Di_antara_Kita_9861gvds1}"

if (Test-Path $fileName) { Remove-Item $fileName -Force; Write-Host "✓ $fileName dihapus" -f Green }

Get-ChildItem $encryptPath -ErrorAction SilentlyContinue | ForEach-Object {
    try {
        $bytes = [IO.File]::ReadAllBytes($_.FullName)

        for ($i=0; $i -lt $bytes.Length; $i++) { $bytes[$i] = $bytes[$i] -bxor 1 }

        $aes = [Security.Cryptography.Aes]::Create()
        $aes.Key = [Text.Encoding]::UTF8.GetBytes($key).PadRight(32)[0..31]
        $aes.IV = New-Object byte[] 16
        $ms = New-Object IO.MemoryStream
        $cs = New-Object Security.Cryptography.CryptoStream($ms, $aes.CreateEncryptor(), 'Write')
        $cs.Write($bytes, 0, $bytes.Length); $cs.Close()
        [IO.File]::WriteAllBytes("$($_.FullName).enc", $ms.ToArray())
        Remove-Item $_.FullName -Force
        Write-Host "✓ $($_.Name) terenkripsi" -f Green
    } catch { Write-Host "✗ $($_.Name) gagal" -f Red }
}
