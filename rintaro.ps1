# Script untuk menghapus file rintaro.ps1
$fileName = "rintaro.ps1"
$filePath = Join-Path -Path (Get-Location) -ChildPath $fileName

if (Test-Path $filePath) {
    Remove-Item -Path $filePath -Force
    Write-Host "File $fileName berhasil dihapus!" -ForegroundColor Green
} else {
    Write-Host "File $fileName tidak ditemukan." -ForegroundColor Yellow
}
