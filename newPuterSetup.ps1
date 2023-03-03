<#
.SYNOPSIS
Configure computer with Applications, Folder locations, Git configuration, and Powershell

.DESCRIPTION
Install applications using winget and install chocolatey
Set User Folders to D:/
Configure Git and download repos for kimbalsp
Configure Powershell profile

.PARAMETER InstallApps
Switch to install apps

.PARAMETER PostInstallApps
Switch to run everythings except Install-Apps. Run this after Install-Apps

.PARAMETER SetFolderLocations
Switch to set folder locations

.PARAMETER SetGitConfig
Switch to set git config

.PARAMETER SetPowershellUser
Switch to Set powershell user

.PARAMETER InstallWSL
Switch to Install WSL

.EXAMPLE
New-Puter -NoInstallApps -NoSetFolderLocations -NoSetGitConfig -NoSetPowershellUser

.NOTES

#>
function New-Puter {
    param (
        [switch]$InstallApps,
		[switch]$PostInstallApps,
        [switch]$SetFolderLocations,
        [switch]$SetGitConfig,
        [switch]$SetPowershellUser,
		[switch]$InstallWSL
    )

	$junctions = @(
		"Desktop",
		"Documents",
		"Downloads",
		"Music",
		"Pictures",
		"Videos"
	)

	$regPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
	$registrys = @{
		"Personal" = "Documents"
		"Documents" = "Documents"
		"{F42EE2D3-909F-4907-8871-4C22FC0BF756}" = "Documents"
		"Desktop" = "Desktop"
		"Downloads" = "Downloads"
		"{374DE290-123F-4565-9164-39C4925E467B}" = "Downloads"
		"{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}" = "Downloads"
		"Music" = "Music"
		"My Music" = "Music"
		"{A0C69A99-21C8-4671-8703-7934162FCF1D}" = "Music"
		"Pictures" = "Pictures"
		"My Pictures" = "Pictures"
		"{0DDD015D-B06C-45D5-8C4C-F59713854639}" = "Pictures"
		"Videos" = "Videos"
		"My Video" = "Videos"
		"{35286A68-3C57-41A1-BBB1-0EAE73D76C95}" = "Videos"
	}

	$apps = @( 
		"7zip.7zip",
		"9P7KNL5RWT25", #SysInternals
		"AgileBits.1Password",
		"ElectronicArts.EADesktop",
		"Discord.Discord",
		"Git.Git",
		"Rufus.Rufus",
		"TeamSpeakSystems.TeamSpeakClient",
		"Giorgiotani.Peazip",
		"GitHub.cli",
		"REALiX.HWiNFO",
		"hwmonitor",
		"JanDeDobbeleer.OhMyPosh",
		"Microsoft.DotNet.DesktopRuntime.7",
		"Microsoft.PowerShell",
		"Microsoft.VisualStudioCode",
		"Microsoft.WindowsTerminal",
		"Mozilla.Firefox",
		"Nota.Gyazo",
		"Notepad++.Notepad++",
		"Oracle.JavaRuntimeEnvironment",
		"RiotGames.LeagueOfLegends.NA",
		"rocksdanister.LivelyWallpaper",
		"SlackTechnologies.Slack",
		"TeamSpeakSystems.TeamSpeakClient",
		"Ubisoft.Connect",
		"Valve.Steam",
		"VB-Audio.Voicemeeter.Banana",
		"WinSCP.WinSCP",
		"XP89DCGQ3K6VLD" #PowerToys
		)

	$manualApps = @( 
		"blitz",
		"GoXLR"
		)

	# Install Applications
	function Install-Apps {
		# Install Chocolatey
		Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
		
		foreach( $app in $apps){
			if( !(winget list | Select-String -Pattern $app -SimpleMatch)){
				winget install $app --accept-package-agreements
			}
		}
		write-host "The following apps were installed:" + $apps
		write-host "Install the remaining manually:" + $manualApps
	}

	# Set User Shell Folder Locations
	function Set-FolderLocations {
		foreach( $registry in $registrys.GetEnumerator()){
			Set-ItemProperty -Path $regPath -Name $($registry.Name) -Value D:\Users\spencer\$($registry.Value)
			write-host "Registry edited for: " $($registry.Value)
		}
		foreach( $junction in $junctions){
			if ((Get-Item -Path C:\Users\spencer\${junction} -Force).LinkType -ne "Junction"){
				Remove-Item -Path C:\Users\spencer\${registry} -Recurse -Force
				New-Item -ItemType Junction -Target D:\Users\spencer\${junction} -Path C:\Users\spencer\ -Name $junction
				write-host "Folder Remapped for: ${junction}"
			} else {
				write-host "Folder already mapped: ${junction}"
			}
		}
	}

	# Git Config
	function Set-GitConfig {
		git config --global user.name "kimbalsp"
		write-host "git config --global user.name kimbalsp"
		git config --global user.email skimball07@gmail.com
		write-host "git config --global user.email skimball07@gmail.com"
		git config --global core.editor code
		write-host "git config --global core.editor code"
		
		# Clone Repos
		if( !(Test-Path -Path C:\code)){
			New-Item -ItemType Directory -Path c:\code
		}
		if( !(Test-Path -Path C:\code\github)){
			New-Item -ItemType Directory -Path c:\code\github
		}
		Set-Location c:\code\github
		$repoList = gh repo list
		foreach($repo in $repoList){ gh repo clone $repo.split('')[0] }
	}

	# Powershell Config
	function Set-PowershellUser {
		$powershellConfig = Get-Content C:\code\github\config\powershell_profile.ps1
		Add-Content $PROFILE -Value $powershellConfig
		write-host "Powershell Profile Cofigured"

		if ( !(Test-Path -Path C:\Users\spencer\.zshrc)){
			New-Item -Path C:\Users\spencer -Name .zshrc
			Add-Content -Path C:\Users\spencer\.zshrc -Value (Get-Content -Path C:\code\github\config\.zshrc)
		}

		if ( !(Test-Path -Path C:\Users\spencer\.bashrc)){
			New-Item -Path C:\Users\spencer -Name .bashrc
			Add-Content -Path C:\Users\spencer\.zshrc -Value (Get-Content -Path C:\code\github\config\.zshrc)
		}
	}

	function Install-WSL {
		wsl --install -d Ubuntu-22.04
	}

	if ($InstallApps) {
		Install-Apps
	}

	if ($PostInstallApps) {
		Set-FolderLocations
		Set-GitConfig
		Set-PowershellUser
		Install-WSL
	}

	if ($SetFolderLocations){
		Set-FolderLocations
	}

	if ($SetGitConfig) {
		Set-GitConfig
	}

	if ($SetPowershellUser) {
		Set-PowershellUser
	}

	if ($InstallWSL) {
		Install-WSL
	}
}