#!/bin/bash


CONF_FOLDER="/root/.fakecoin/"

if [ ! -f ${CONF_FOLDER}fakecoin.conf ]; then
  cp /app/fakecoin.conf $CONF_FOLDER
fi

touch /root/.fakecoin/debug.log
tail -f -n 10 /root/.fakecoin/debug.log &

start_daemon () {
  fakecoind -blockmaxsize=50000 -daemon
}
stop_daemon () {
  fakecoin-cli -rpcuser=username -rpcpassword=password stop
  sleep 5s
  killall5 -9 fakecoind
}

start_daemon_loop () {
  while true; do
    start_daemon
    sleep 59m
    stop_daemon
    sleep 5s
  done
}

# start_daemon
start_daemon_loop
