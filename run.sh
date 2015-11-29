#!/bin/bash
cd "$(dirname "$0")"
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
  cd - > /dev/null
  echo "Coping /Library/Preferences/ folder... "
  sudo rsync -av --progress  /Library/Preferences/* config/sys_pref --exclude OpenDirectory > /dev/null 2>&1
  echo "Creating archive..."
  cd config/sys_pref
  tar -pczf preferences.tar.gz . > /dev/null 2>&1
  mkdir tmp
  cp preferences.tar.gz tmp
  echo "Done"
fi

if [ "$CHOICE" -eq 2 ]; then
  read -p "Are you sure you want to continue? <y/n> " prompt
  if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]; then
    echo "Unpacking archive..."
    cd config/sys_pref/tmp
    sudo tar -pxzf preferences.tar.gz > /dev/null 2>&1
    rm -f preferences.tar.gz
    #! DEBUG
    #exit 0
    #!DEBUG
    echo "Installing config..."
    sudo rsync -av -I --progress * /Library/Preferences/ > /dev/null 2>&1
    echo "Installed"
    echo "Erease config folder? (y/n)"
    #Нужно сделать, а пока пойду в R6S играть.
    read -p "Reboot system now? (y/n)" REBOOTNOW
    if [[ $REBOOTNOW == "y" || $REBOOTNOW == "Y" || $REBOOTNOW == "yes" || $REBOOTNOW == "Yes" ]]; then
      echo "Rebooting..."
      sudo reboot
    fi
  else
    exit 0
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
