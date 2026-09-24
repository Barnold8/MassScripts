$Manifest = Invoke-RestMethod -Uri "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"

$LatestReleaseVersion = $Manifest.latest.release

$VersionInfo = $Manifest.versions | Where-Object { $_.id -eq $LatestReleaseVersion }
$VersionData = Invoke-RestMethod -Uri $VersionInfo.url


$ServerUrl = $VersionData.downloads.server.url

Invoke-WebRequest $ServerUrl -OutFile server.jar

start-process server.jar

while([System.IO.File]::Exists("eula.txt") -ne $true){
    Write-Output "Waiting on eula.txt..."
    
}

Start-Sleep -Seconds 1

$file = 'eula.txt'
$find = 'eula=false'
$replace = 'eula=true'

(Get-Content $file).replace($find, $replace) | Set-Content $file

start-process server.jar

$ipconfig = [string](ipconfig.exe)

$regex = [regex] "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"

$ips = $regex.Matches($ipconfig) | %{ $_.value }
$default_gateway = $ips[$ips.Count-1]

Start-Process "http://$($default_gateway)"
Start-Process "https://www.whatismyip.com/" 

Write-Output $default_gateway