#!/bin/bash

apps=(
    "visual-studio-code"
    "git"
    "gh"
    "firefox"
    "1password"
    "discord"
    "slack"
    "cyberduck"
    "vlc"
    "steam"
)

## Install Apps
for app in $apps
do
    brew install $app
    echo "$app installed"
done

## Git Config
git config --global user.name "kimbalsp"
echo "git config --global user.name kimbalsp"
git config --global user.email skimball07@gmail.com
echo "git config --global user.email skimball07@gmail.com"
git config --global core.editor code
echo "git config --global core.editor code"

## Clone Repos from Github
mkdir ~/code
mkdir ~/code/github
cd code/github
for repoName in $(gh repo list)
do
    if [[ $repoName = "kimbalsp/"* ]]; then
        gh repo clone $repoName
    fi
done

exit