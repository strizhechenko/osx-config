#!/bin/bash

ask() {
  read -p "$1" prompt  
  [ "${prompt:0:1}" = y -o "${prompt:0:1}" = Y ]
}

create_config() {
  echo "Copying /Library/Preferences/ folder... "
  sudo rsync -av --progress  /Library/Preferences/* config/sys_pref --exclude OpenDirectory > /dev/null 2>&1
  echo "Copying ~/Library/Preferences/ folder... "
  sudo rsync -av --progress  ~/Library/Preferences/* config/apps_pref > /dev/null 2>&1
  echo "Creating archives..."
  cd config/sys_pref > /dev/null 2>&1
  tar -pczf preferences.tar.gz . > /dev/null 2>&1
  mkdir tmp > /dev/null 2>&1
  cp preferences.tar.gz tmp
  rm -r preferences.tar.gz
  cd - > /dev/null 2>&1
  cd config/apps_pref > /dev/null 2>&1
  tar -pczf apps_preferences.tar.gz . > /dev/null 2>&1
  mkdir tmp > /dev/null 2>&1
  cp apps_preferences.tar.gz tmp
  rm -r apps_preferences.tar.gz
  cd - > /dev/null 2>&1
  echo "Copying ~/Library/Keychains/login.keychain..."
  rsync -av --progress ~/Library/Keychains/login.keychain config > /dev/null 2>&1
  cd config > /dev/null 2>&1
  tar -pczf config.tar.gz . > /dev/null 2>&1
  mv config.tar.gz .[^.]* .. > /dev/null 2>&1
  cd - > /dev/null 2>&1
  sudo rm -rf config
  echo "Done"
}

install_config() {
  ask "Are you sure you want to continue? <y/n> " || return
  echo "Unpacking..."
  mv config.tar.gz config > /dev/null 2>&1
  cd config > /dev/null 2>&1
  sudo tar -pxzf config.tar.gz > /dev/null 2>&1
  rm -r config.tar.gz > /dev/null 2>&1
  echo "Installing..."
  cd - > /dev/null 2>&1
  cd config/sys_pref/tmp
  sudo tar -pxzf preferences.tar.gz > /dev/null 2>&1
  rm -f preferences.tar.gz
  sudo rsync -av -I --progress * /Library/Preferences/ > /dev/null 2>&1
  cd - > /dev/null 2>&1
  cd config/apps_pref/tmp
  sudo tar -pxzf apps_preferences.tar.gz > /dev/null 2>&1
  rm -f apps_preferences.tar.gz
  sudo rsync -av -I --progress * ~/Library/Preferences/ > /dev/null 2>&1
  cd - > /dev/null 2>&1
  cd config > /dev/null 2>&1
  sudo rsync -av -I --progress login.keychain ~/Library/Keychains/ > /dev/null 2>&1
  echo "Installed"
  cd - > /dev/null 2>&1
  clean_config
  if ask "Reboot system now? (y/n)"; then 
    echo "Rebooting..."
    sudo reboot
  fi
}

recover_default_pref() {  
  ask "Are you sure you want to recover default preferences? <y/n> " || return
  #rsync (hidden folder with .)
  echo "Done"
}

clean_config() {
  ask "Are you sure you want to clean config folder? <y/n> " || return
  sudo rm -rf config
  echo "Done"
}

cd "$(dirname "$0")"
mkdir -p config/{sys,apps}_pref

echo "CTRL+C to quit"
select CHOISE in "create_config" "install_config" "restore_default_config" "clean_config" "exit"; do
  case "$CHOISE" in
    "create_config" | "install_config" | "restore_default_config" | "clean_config" | "exit" )
      $CHOISE
      ;;
    * )
      ask "Exit? <y/n>" && exit 0
      ;;
  esac
done
