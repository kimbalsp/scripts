#!/bin/bash

## Install Homebrew
which -s brew
if [[ $? != 0 ]]; then
  # Install Homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "brew is installed"
else
  brew update
  echo "brew is updated"
fi

## Install Apps
function install_apps() {
  local apps=("$@")
  local to_install=()

  for app in "${apps[@]}"; do
    if ! brew list "$app" &>/dev/null; then
      to_install+=("$app")
    else
      echo "$app is already installed"
    fi
  done

  if [ ${#to_install[@]} -ne 0 ]; then
    echo "All apps are already installed."
    brew install "${to_install[@]}"
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
  if [ ! -d ~/code ]; then
    mkdir ~/code
  fi

  cd ~/code || exit

  gh repo list | while read -r repo _; do
    git clone --bare git@github.com:"$repo".git "$repo"
    cd $repo
    git worktree add main
    cd ../../
  done
}

source macapps.conf

# ## Install Apps by Catagory
# echo "Installing Apps..."
# install_apps "${APPS[@]}"
#
# echo "Installing Games..."
# install_apps "${GAMES[@]}"
#
# echo "Installing development tools..."
# install_apps "${DEV_TOOLS[@]}"
#
# echo "Installing Terminal Tools..."
# install_apps "${TERMINAL_TOOLS[@]}"
#
# echo "Installing Fonts..."
# install_apps "${FONTS[@]}"
#
# config_git
# clone_repos
