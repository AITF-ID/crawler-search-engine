Write-Host "[INFO] Windows installer untuk Chrome dan ChromeDriver"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Host "[ERROR] winget tidak tersedia. Install App Installer dari Microsoft Store."
  exit 1
}

Write-Host "[INFO] Install Google Chrome"
winget install -e --id Google.Chrome --accept-source-agreements --accept-package-agreements | Out-Null

Write-Host "[INFO] Install ChromeDriver"
winget install -e --id Google.ChromeDriver --accept-source-agreements --accept-package-agreements | Out-Null

Write-Host "[INFO] Cek versi Chrome dan ChromeDriver"
try {
  & "$Env:ProgramFiles\Google\Chrome\Application\chrome.exe" --version
} catch {
  Write-Host "Chrome tidak ditemukan di Program Files."
}

try {
  chromedriver --version
} catch {
  Write-Host "ChromeDriver tidak ditemukan di PATH."
}

Write-Host "[INFO] Set alias permanen (PowerShell)"
$profilePath = $PROFILE
if (-not (Test-Path $profilePath)) {
  New-Item -ItemType File -Path $profilePath -Force | Out-Null
}
$aliasLine = 'Set-Alias aitf-engine (Resolve-Path ".\aitf-engine.exe")'
if (-not (Select-String -Path $profilePath -Pattern "aitf-engine" -Quiet)) {
  Add-Content -Path $profilePath -Value $aliasLine
}
Write-Host "[INFO] Jalankan: . $PROFILE untuk aktifkan alias di shell baru."
