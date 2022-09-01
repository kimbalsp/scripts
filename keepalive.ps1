clear-host
$WShell = new-object -com "WScript.shell"
while ($true)
{
    $WShell.sendkeys("{SCROLLLOCK}")
    start-sleep -milliseconds 100
    $WShell.sendkeys("{SCROLLLOCK}")
    start-sleep -seconds 300
}