# Setup Folders
$junctions = @( "Documents", "Desktop", "Downloads", "Music", "Pictures", "Videos" )

foreach( $j in $junctions){
	junction C:\Users\spencer\$j\$j D:\Users\spencer\$j
}

write-host "Junction Points Created for: " + $junctions

# Install Applications
$apps = @( "cmder", "firefox", "notepadplusplus", "googlechrome", "vscode", "battle.net", "steam", "1password", "twitch", "leagueoflegends", "origin", "uplay", "7zip", "discord", "git", "itunes", "rainmeter", "rufus", "teamspeak", "winscp", "sysinternals" )
$manualApps = @( "voicemeeter", "logitech g hub", "RGB Fusion", "SIV", "blitz", "icue" )

foreach( $app in $apps){
	choco install $app -y
}

write-host "The following apps were installed:" + $apps

write-host "Install the remaining manually:" + $manualApps