# Deploy swp391 to Tomcat 10.1 (run PowerShell as Administrator if copying to Program Files)
$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$TomcatHome  = "D:\apache-tomcat-10.1.55-windows-x64\apache-tomcat-10.1.55"
$Maven       = "mvn"
$JavaHome    = "C:\Program Files\Java\jdk-26.0.1"

$env:JAVA_HOME = $JavaHome
Write-Host "==> 1. Build WAR..." -ForegroundColor Cyan
& $Maven -f "$ProjectRoot\pom.xml" clean package -DskipTests
if ($LASTEXITCODE -ne 0) { throw "Maven build failed" }

$WarFile = "$ProjectRoot\target\swp391.war"
$Exploded = "$ProjectRoot\target\swp391"
if (-not (Test-Path $WarFile)) { throw "WAR not found: $WarFile" }

Write-Host "==> 2. Deploy (method: context on D: drive)..." -ForegroundColor Cyan
$ContextSrc = "$ProjectRoot\deploy\tomcat-swp391-context.xml"
$ContextDst = "$TomcatHome\conf\Catalina\localhost\swp391.xml"

# Remove old WAR deployment on C: if present (free space)
$OldWar = "$TomcatHome\webapps\swp391.war"
$OldDir = "$TomcatHome\webapps\swp391"
if (Test-Path $OldDir) { Remove-Item -Recurse -Force $OldDir; Write-Host "Removed old $OldDir" }
if (Test-Path $OldWar) { Remove-Item -Force $OldWar; Write-Host "Removed old $OldWar" }

# Install context pointing to exploded app on D:
New-Item -ItemType Directory -Force -Path "$TomcatHome\conf\Catalina\localhost" | Out-Null
Copy-Item -Force $ContextSrc $ContextDst
Write-Host "Context installed: $ContextDst"
Write-Host "  docBase -> $Exploded"

Write-Host "==> 3. Restart Tomcat..." -ForegroundColor Cyan
$env:CATALINA_HOME = $TomcatHome
& "$TomcatHome\bin\shutdown.bat" 2>$null
Start-Sleep -Seconds 4
Start-Process -FilePath "$TomcatHome\bin\startup.bat" -WindowStyle Hidden
Start-Sleep -Seconds 8

Write-Host ""
Write-Host "Deploy done. Open: http://localhost:8080/swp391/login" -ForegroundColor Green
Write-Host "Login: admin@hrm.local / Admin123!" -ForegroundColor Green
