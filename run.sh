#!/bin/bash
#v0.05
cd "$(dirname "$0")"
#echo "Hey"
echo "1 - Create config"
echo "2 - Install config"
echo "3 - Recover default preferences"
echo "4 - Clean config folder"
if [ ! -d config ]; then
  mkdir config
fi
read -p ": " CHOICE

if [ "$CHOICE" -eq 1 ]; then
  #Checking for sys_pref folder
  cd config
  if [ ! -d sys_pref ]; then
    mkdir sys_pref
  fi
  if [ ! -d apps_pref ]; then
    mkdir apps_pref
  fi
  cd - > /dev/null 2>&1
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
fi

if [ "$CHOICE" -eq 2 ]; then
  read -p "Are you sure you want to continue? <y/n> " prompt
  if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]; then
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
    read -p "Erase config folder? (y/n)" PROMTERASE
    if [[ $PROMTERASE == "y" || $PROMTERASE == "Y" || $PROMTERASE == "yes" || $PROMTERASE == "Yes" ]]; then
      cd - > /dev/null 2>&1
      sudo rm -rf config
      echo "Erased"
      read -p "Reboot system now? (y/n)" REBOOTNOW
      if [[ $REBOOTNOW == "y" || $REBOOTNOW == "Y" || $REBOOTNOW == "yes" || $REBOOTNOW == "Yes" ]]; then
        echo "Rebooting..."
        sudo reboot
      fi
    else

    read -p "Reboot system now? (y/n)" REBOOTNOW
    if [[ $REBOOTNOW == "y" || $REBOOTNOW == "Y" || $REBOOTNOW == "yes" || $REBOOTNOW == "Yes" ]]; then
      echo "Rebooting..."
      sudo reboot
    fi
fi
fi
fi




if [ "$CHOICE" -eq 3 ]; then
  read -p "Are you sure you want to recover default preferences? <y/n> " prompt
  if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
  then
  #rsync (hidden folder with .)
  echo "Done"
  exit 0
else
  exit 0
fi
fi

if [ "$CHOICE" -eq 4 ]; then
  read -p "Are you sure you want to clean config folder? <y/n> " prompt
  if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
  then
  sudo rm -rf config
  echo "Done"
  exit 0
else
  exit 0
fi

fi
#Config file, (or setup par -help for exmple). (What to config). Keychain backup, all settings.
#
