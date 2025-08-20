$global:JUNCTIONS = @(
		"Desktop",
		"Documents",
		"Downloads",
		"Music",
		"Pictures",
		"Videos"
		)

$global:CHOME = "C:\Users\${Username}"
$global:DHOME = "D:\Users\${Username}"

$global:REGPATH = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"

$global:REGISTRYS = @{
	"Personal"= "Documents"
	"Documents"= "Documents"
	"{F42EE2D3-909F-4907-8871-4C22FC0BF756}"= "Documents"
	"Desktop"= "Desktop"
	"Downloads"= "Downloads"
	"{374DE290-123F-4565-9164-39C4925E467B}"= "Downloads"
	"{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}"= "Downloads"
	"Music"= "Music"
	"My Music"= "Music"
	"{A0C69A99-21C8-4671-8703-7934162FCF1D}"= "Music"
	"Pictures"= "Pictures"
	"My Pictures"= "Pictures"
	"{0DDD015D-B06C-45D5-8C4C-F59713854639}"= "Pictures"
	"Videos"= "Videos"
	"My Videos"= "Videos"
	"{35286A68-3C57-41A1-BBB1-0EAE73D76C95}"= "Videos"
}

