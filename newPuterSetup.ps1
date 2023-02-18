<#
.SYNOPSIS
Configure computer with Applications, Folder locations, Git configuration, and Powershell

.DESCRIPTION
Install applications using winget and install chocolatey
Set User Folders to D:/
Configure Git and download repos for kimbalsp
Configure Powershell profile

.PARAMETER NoInstallApps
Switch to skip Application Installation

.PARAMETER NoSetFolderLocations
Switch to skip User Folder mappings

.PARAMETER NoSetGitConfig
Switch to skip Git configuration and repo downloading

.PARAMETER NoSetPowershellUser
Switch to skip Powershell profile configuration

.EXAMPLE
New-Puter -NoInstallApps -NoSetFolderLocations -NoSetGitConfig -NoSetPowershellUser

.NOTES

#>
function New-Puter {
    param (
        [switch]$NoInstallApps,
        [switch]$NoSetFolderLocations,
        [switch]$NoSetGitConfig,
        [switch]$NoSetPowershellUser
    )

	$regPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
	$junctions = @{
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
		"Mozilla.Firefox",
		"Notepad++.Notepad++",
		"Microsoft.VisualStudioCode",
		"Valve.Steam",
		"RiotGames.LeagueOfLegends.NA",
		"ElectronicArts.EADesktop",
		"Ubisoft.Connect",
		"7zip.7zip",
		"Discord.Discord",
		"Git.Git",
		"Rufus.Rufus",
		"TeamSpeakSystems.TeamSpeakClient",
		"WinSCP.WinSCP",
		"9P7KNL5RWT25",
		"XP89DCGQ3K6VLD",
		"AgileBits.1Password",
		"Nota.Gyazo",
		"VB-Audio.Voicemeeter.Banana",
		"GitHub.cli",
		"hwmonitor",
		"Microsoft.WindowsTerminal",
		"SlackTechnologies.Slack"
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
			winget install $app --accept-package-agreements
		}
		write-host "The following apps were installed:" + $apps
		write-host "Install the remaining manually:" + $manualApps
	}

	# Set User Shell Folder Locations
	function Set-FolderLocations {
		foreach( $junction in $junctions.GetEnumerator()){
			Set-ItemProperty -Path $regPath -Name $($junction.Name) -Value D:\Users\spencer\$($junction.Value)
			write-host "Remapped folder for: " $($junction.Value)
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
		New-Item -ItemType Directory -Path c:\code
		New-Item -ItemType Directory -Path c:\code\github
		Set-Location c:\code\github
		$repoList = gh repo list
		foreach($repo in $repoList){ gh repo clone $repo.split('')[0] }
	}

	# Powershell Config
	function Set-PowershellUser {
		[string]$powershellConfig = "Import-Module C:\code\github\League\New-ARAM.ps1
		Set-Location c:\code
		clear-host"
		Add-Content $PROFILE -Value $powershellConfig
		write-host "Powershell Profile Cofigured"
	}


	if (!$NoInstallApps) {
		Install-Apps
	}

	if (!$NoSetFolderLocations) {
		Set-FolderLocations
	}

	if (!$NoSetGitConfig) {
		Set-GitConfig
	}

	if (!$NoSetPowershellUser) {
		Set-PowershellUser
	}
}