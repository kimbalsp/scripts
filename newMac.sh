#!/bin/bash

## Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "brew is installed"

## Install Apps
install_apps("$@") {
  local apps=("$@")
  local to_install=()

  for app in "${apps[@]}"; do
    if ! brew list --cask "$app" &>/dev/null; then
      to_install+=("$app")
    else
      echo "$app is already installed"
    fi
  done

  if [ ${#to_install[@]} -ne 0 ]; then
    echo "All apps are already installed."
    brew install --cask "${to_install[@]}"
  fi
}

## Git Config
config_git() {
  git config --global user.name "kimbalsp"
  echo "git config --global user.name kimbalsp"
  git config --global user.email skimball07@gmail.com
  echo "git config --global user.email skimball07@gmail.com"
  git config --global core.editor code
  echo "git config --global core.editor code"
}

## Clone Repos from Github
clone_repos() {
  mkdir ~/code
  cd code || exit
  for repoName in $(gh repo list)
  do
    if [[ $repoName = "kimbalsp/"* ]]; then
      git clone --bare https://github.com/"$repoName"
    fi
  done
}

source macapps.conf

## Install Apps by Catagory
echo "Installing Apps..."
install_apps "${APPS[@]}"

echo "Installing development tools..."
install_apps "${DEV_TOOLS[@]}"

echo "Installing Terminal Tools..."
install_apps "${TERMINAL_TOOLS[@]}"

echo "Installing Fonts..."
install_apps "${FONTS[@]}"
