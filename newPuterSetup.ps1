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
# Install Applications
function Install-Apps {
  param ($apps)
    foreach( $app in $apps){
      if( !(winget list | Select-String -Pattern $app -SimpleMatch)){
        winget install $app --accept-package-agreements
      }
      write-host "Installed: $app"
    }
}

# Set User Shell Folder Locations
function Set-FolderLocations {
  param ($registrys,$junctions,$DHome,$CHome)
    foreach( $registry in $registrys.GetEnumerator()){
      Set-ItemProperty -Path $regPath -Name $($registry.Name) -Value ${DHome}\$($registry.Value)
        write-host "Registry edited for: " $($registry.Value)
    }
  foreach( $junction in $junctions){
    if ((Get-Item -Path ${CHome}\${junction} -Force).LinkType -ne "Junction"){
      Remove-Item -Path ${CHome}\${registry} -Recurse -Force
        New-Item -ItemType Junction -Target ${DHome}\${junction} -Path ${CHome}\ -Name $junction
        write-host "Folder Remapped for: ${junction}"
    } else {
      write-host "Folder already mapped: ${junction}"
    }
  }
}

# Git Config
function Set-GitConfig {
  param ($repoList)
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
  Set-Location c:\code
    $repoList = gh repo list
    foreach($repo in $repoList){ gh repo clone $repo.split('')[0] }
}

# Powershell Config
function Set-PowershellUser {
  $powershellConfig = Get-Content C:\code\github\config\powershell_profile.ps1
    Add-Content $PROFILE -Value $powershellConfig
    write-host "Powershell Profile Cofigured"

    if ( !(Test-Path -Path ${CHome}\.zshrc)){
      New-Item -Path ${CHome} -Name .zshrc
        Add-Content -Path ${CHome}\.zshrc -Value (Get-Content -Path C:\code\github\config\.zshrc)
    }

  if ( !(Test-Path -Path ${CHome}\.bashrc)){
    New-Item -Path ${CHome} -Name .bashrc
      Add-Content -Path ${CHome}\.zshrc -Value (Get-Content -Path C:\code\github\config\.zshrc)
  }
}

function Install-WSL {
  wsl --install -d Ubuntu-22.04
}
