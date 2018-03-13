#!/bin/bash

INSTALL_PATH="/usr/src/app/"

cd $INSTALL_PATH/CoiniumServ-master/build/bin/Release
if [ -d config ]; then
  if [ -d config/originals ]; then
    rm -rf config/originals
  fi
  cp -rf config-back ./config/originals
  cp -nr config/originals/* ./config/
fi

sleep 5
cd $INSTALL_PATH
mono ./CoiniumServ-master/build/bin/Release/CoiniumServ.exe
