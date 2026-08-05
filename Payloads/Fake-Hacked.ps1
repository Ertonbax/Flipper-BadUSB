# Vollbild-Effekt vorbereiten und Konsole auf Hacker-Grün setzen
Clear-Host
$Host.UI.RawUI.ForegroundColor = "Green"
$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host

# Funktion zum Zeichnen der Box und des Balkens
function Show-ProgressBox {
    param (
        [int]$Percent
    )
    
    # Bildschirm leeren, damit der Balken flüssig wächst
    [Console]::SetCursorPosition(0, 0)

    # Hintergrund-Matrix-Rauschen erzeugen
    for ($r = 1; $r -le 6; $r++) {
        $randRow = -join ((33..126) | Get-Random -Count 60 | ForEach-Object {[char]$_})
        Write-Host "$randRow" -ForegroundColor DarkGreen
    }

    Write-Host ""
    # Die ASCII-Box
    Write-Host "+--------------------------------------------------------+" -ForegroundColor Green
    Write-Host "|                  BREACHING SYSTEM...                   |" -ForegroundColor Green
    Write-Host "|                                                        |" -ForegroundColor Green

    # Ladebalken berechnen (Gesamtlänge = 50 Zeichen)
    $totalBars = 50
    $filledBars = [math]::Floor(($Percent / 100) * $totalBars)
    $emptyBars = $totalBars - $filledBars
    
    $barString = "[" + ("#" * $filledBars) + ("-" * $emptyBars) + "]"
    
    Write-Host "|   $barString   |" -ForegroundColor Green
    Write-Host "|                                                        |" -ForegroundColor Green
    
    # Zentrierte Prozentanzeige
    $percentText = "$Percent%"
    $padding = " " * ([math]::Max(0, [math]::Floor((56 - $percentText.Length) / 2)))
    Write-Host "|$padding$percentText$padding|" -ForegroundColor Green
    
    Write-Host "+--------------------------------------------------------+" -ForegroundColor Green
}

# Schleife für den Fortschritt von 0% bis 100%
for ($i = 0; $i -le 100; $i += 2) {
    Show-ProgressBox -Percent $i
    # Variable Geschwindigkeit für den echten "Lade-Effekt"
    Start-Sleep -Milliseconds (Get-Random -Minimum 30 -Inf 90)
}

# Abschluss-Screen nach erfolgreichem Laden
Start-Sleep -Milliseconds 500
Clear-Host
Write-Host ""
Write-Host "========================================================" -ForegroundColor Red
Write-Host "               >>> SYSTEM HACKED <<<                " -ForegroundColor Red
Write-Host "========================================================" -ForegroundColor Red
Write-Host ""
Write-Host " The System has been Breached, Enjoy ! <3" -ForegroundColor Gray
Write-Host ""

# Das Fenster offen halten
Start-Sleep -Seconds 5
