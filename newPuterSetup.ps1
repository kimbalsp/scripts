$junctions = @(
	"Documents",
	"Desktop",
	"Downloads",
	"Music",
	"Pictures",
	"Videos"
	)

$apps = @( 
	"cmder",
	"firefox",
	"notepadplusplus",
	"googlechrome",
	"vscode",
	"battle.net",
	"steam",
	"1password",
	"twitch",
	"leagueoflegends",
	"origin",
	"uplay",
	"7zip",
	"discord",
	"git",
	"itunes",
	"rainmeter",
	"rufus",
	"teamspeak",
	"winscp",
	"sysinternals",
	"slack",
	"icloud",
	"nvm"
	)
$manualApps = @( 
	"blitz",
	"TeamSpeak 5",
	"GoXLR",
	"Gyazo"
	)

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

foreach( $app in $apps){
	choco install $app -y
}
write-host "The following apps were installed:" + $apps
write-host "Install the remaining manually:" + $manualApps

foreach( $j in $junctions){
	junction C:\Users\spencer\$j\$j U:\Users\spencer\$j
}

write-host "Junction Points Created for: " + $junctions

## Git Config
git config --global user.name "Spencer Kimball"
write-host "git config --global user.name `"Spencer Kimball`""
git config --global user.email skimball07@gmail.com
write-host "git config --global user.email skimball07@gmail.com"
git config --global core.editor code
write-host "git config --global core.editor code"

## Powershell Config
[string]$powershellConfig = "Import-Module E:\code\ps\League\New-ARAM.ps1
cd E:\code
clear-host"
Add-Content $PROFILE -Value $powershellConfig
write-host "Powershell Profile Cofigured"
