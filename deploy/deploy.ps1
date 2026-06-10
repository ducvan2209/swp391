# Deploy swp391 to Tomcat 10.1 (run PowerShell as Administrator if copying to Program Files)
$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$TomcatHome  = "C:\Program Files\Apache Software Foundation\Tomcat 10.1"
$Maven       = "C:\Program Files\NetBeans-17\netbeans\java\maven\bin\mvn.cmd"
$JavaHome    = "C:\Program Files\Java\jdk-17"

$env:JAVA_HOME = $JavaHome
$env:JRE_HOME = $JavaHome
Write-Host "==> 1. Build WAR..." -ForegroundColor Cyan
& $Maven -f "$ProjectRoot\pom.xml" clean package -DskipTests
if ($LASTEXITCODE -ne 0) { throw "Maven build failed" }

$WarFile = "$ProjectRoot\target\swp391.war"
$Exploded = "$ProjectRoot\target\swp391"
if (-not (Test-Path $WarFile)) { throw "WAR not found: $WarFile" }

Write-Host "==> 2. Deploy (method: context to current workspace target)..." -ForegroundColor Cyan
$ContextSrc = "$ProjectRoot\deploy\tomcat-swp391-context.xml"
$ContextDst = "$TomcatHome\conf\Catalina\localhost\swp391.xml"

# Remove old WAR deployment on C: if present (free space)
$OldWar = "$TomcatHome\webapps\swp391.war"
$OldDir = "$TomcatHome\webapps\swp391"
if (Test-Path $OldDir) { Remove-Item -Recurse -Force $OldDir; Write-Host "Removed old $OldDir" }
if (Test-Path $OldWar) { Remove-Item -Force $OldWar; Write-Host "Removed old $OldWar" }

# Install context pointing to exploded app:
New-Item -ItemType Directory -Force -Path "$TomcatHome\conf\Catalina\localhost" | Out-Null
Copy-Item -Force $ContextSrc $ContextDst
Write-Host "Context installed: $ContextDst"
Write-Host "  docBase -> $Exploded"

Write-Host "==> 3. Restart Tomcat..." -ForegroundColor Cyan
$env:CATALINA_HOME = $TomcatHome
$env:CATALINA_BASE = $TomcatHome
$processIds = (Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue).OwningProcess | Sort-Object -Unique
foreach ($processId in $processIds) {
    if ($processId -gt 0) {
        Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
        Write-Host "Stopped Tomcat/Java process on port 8080: PID $processId"
    }
}
Start-Sleep -Seconds 3
Write-Host ""
Write-Host "Starting Tomcat in this Cursor terminal..." -ForegroundColor Green
Write-Host "Keep this terminal running. Stop server with Ctrl+C." -ForegroundColor Yellow
Write-Host "Open: http://localhost:8080/swp391/department-manager/dashboard.html" -ForegroundColor Green
Write-Host "API:  http://localhost:8080/swp391/api/department-manager/dashboard" -ForegroundColor Green
Write-Host ""

& "$TomcatHome\bin\catalina.bat" run
