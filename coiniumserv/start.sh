#!/bin/bash

BRANCH=master
if [ -d "$INSTALL_PATH/CoiniumServ-develop/build/bin/Release" ]; then
  BRANCH=develop
fi

INSTALL_PATH="/usr/src/app/"

cd $INSTALL_PATH/CoiniumServ-${BRANCH}/build/bin/Release

mkdir -p config
if [ -d config ]; then
  if [ -d config/originals ]; then
    rm -rf config/originals
  fi
  cp -rf config-back ./config/originals
  cp -nr config/originals/* ./config/
fi

sleep 5
cd $INSTALL_PATH
export MONO_THREADS_PER_CPU=100
mono ./CoiniumServ-${BRANCH}/build/bin/Release/CoiniumServ.exe
