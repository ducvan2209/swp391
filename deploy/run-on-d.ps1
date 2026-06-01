# Chay Tomcat voi CATALINA_BASE tren o D (tranh day o C)
# Chay PowerShell:  .\deploy\run-on-d.ps1

$ErrorActionPreference = "Stop"
$ProjectRoot = "D:\SWP391_G1_Summer26\swp391"
$TomcatHome  = "C:\Program Files\Apache Software Foundation\Tomcat 10.1"
$RuntimeBase = "D:\SWP391_G1_Summer26\tomcat-runtime"
$Maven       = "C:\Program Files\NetBeans-17\netbeans\java\maven\bin\mvn.cmd"
$JavaHome    = "C:\Program Files\Eclipse Adoptium\jdk-11.0.31.11-hotspot"

$env:JAVA_HOME = $JavaHome
$env:CATALINA_HOME = $TomcatHome
$env:CATALINA_BASE = $RuntimeBase
$env:CATALINA_TMPDIR = "$RuntimeBase\temp"

# Thu muc runtime
@("temp","work","logs","webapps","conf\Catalina\localhost") | ForEach-Object {
    New-Item -ItemType Directory -Force -Path "$RuntimeBase\$_" | Out-Null
}

# Copy conf lan dau (neu chua co server.xml)
if (-not (Test-Path "$RuntimeBase\conf\server.xml")) {
    Write-Host "Copy Tomcat conf -> D:\...\tomcat-runtime\conf (lan dau)" -ForegroundColor Yellow
    Copy-Item -Recurse -Force "$TomcatHome\conf\*" "$RuntimeBase\conf\"
}

# Context swp391
Copy-Item -Force "$ProjectRoot\deploy\tomcat-swp391-context.xml" "$RuntimeBase\conf\Catalina\localhost\swp391.xml"

# Build
Write-Host "==> Build project..." -ForegroundColor Cyan
& $Maven -f "$ProjectRoot\pom.xml" clean package -DskipTests
if ($LASTEXITCODE -ne 0) { throw "Maven build failed" }

# Stop process on port 8080
Write-Host "==> Stop Tomcat cu (port 8080)..." -ForegroundColor Cyan
$pids = (Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue).OwningProcess | Sort-Object -Unique
foreach ($pid in $pids) {
    if ($pid -gt 0) {
        Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
        Write-Host "  Stopped PID $pid"
    }
}
Start-Sleep -Seconds 3

# Start Tomcat (logs/work/temp tren o D)
Write-Host "==> Start Tomcat (CATALINA_BASE = $RuntimeBase)..." -ForegroundColor Cyan
Start-Process -FilePath "$TomcatHome\bin\startup.bat" -WorkingDirectory "$TomcatHome\bin"
Start-Sleep -Seconds 12

# Verify
try {
    $r = Invoke-WebRequest -Uri "http://localhost:8080/swp391/login" -UseBasicParsing -TimeoutSec 15
    Write-Host "HTTP $($r.StatusCode) - http://localhost:8080/swp391/login" -ForegroundColor Green
} catch {
    Write-Host "Trang chua san sang hoac loi: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Xem log: $RuntimeBase\logs\catalina.*.log"
}

Write-Host ""
Write-Host "Dang nhap: admin@hrm.local / Admin123!" -ForegroundColor Cyan
