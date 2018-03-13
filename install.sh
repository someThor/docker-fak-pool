#!/bin/sh

if [[ ! -f  ./install-config ]]; then
  cp ./install-config.dist ./install-config
fi

source ./install-config

make_env_file () {
  echo "$(cat <<EOF
DOCKER_USER=$DOCKER_USER
GIT_FAKECOIND_VERSION=$GIT_FAKECOIND_VERSION
GIT_FAKECOIND_BRANCH=$GIT_FAKECOIND_BRANCH
MYSQL_VERSION=$MYSQL_VERSION
MYSQL_DATABASE=$MYSQL_DATABASE
MYSQL_PASSWORD=$MYSQL_PASSWORD
EOF
)" > .env
}

fakecoind_bugfix () {
  docker-compose rm -f fakecoind
  docker-compose -f docker-compose.yml -f override.fakecoind.0.10.4.yml build fakecoind
  docker-compose up -d fakecoind
  sleep 30
  docker-compose stop fakecoind
  docker-compose rm -f fakecoind
}

fakecoind_build () {
  docker-compose -f docker-compose.yml build fakecoind
}

fakecoind_start () {
  docker-compose up -d fakecoind
}

fakecoind_get_wallet_address () {
  if [[ "${#WALLET_ADDRESS}" != 34 ]]; then
    while [[ "${#WALLET_ADDRESS}" != 34 ]]; do
      sleep 2s
      RESPONSE=`docker-compose exec fakecoind sh -c 'fakecoin-cli -rpcuser=username -rpcpassword=password getaccountaddress ""'`
      RESPONSE="$(echo "${RESPONSE}" | tr -d '[:space:]')"
      if [[ "${#RESPONSE}" == 34 ]]; then
        WALLET_ADDRESS=$RESPONSE
      fi
    done
    echo "$(cat install-config \
    | sed -e s/WALLET_ADDRESS=.*/WALLET_ADDRESS=\"${WALLET_ADDRESS}\"/g)" > install-config
  fi
  echo "WALLET_ADDRESS=$WALLET_ADDRESS"
}

write_server_config () {
  if [[ $SERVER_NAME ]]; then
    echo "server_name: $SERVER_NAME"
    SERVER_CONF="$(cat coiniumserv/config.json.dist \
    | sed s~"PLACEHOLDER-SERVER-NAME"~"${SERVER_NAME}"~g \
    | sed s~"PLACEHOLDER-LOCATION"~"${POOL_LOCATION}"~g \
    | sed s~"PLACEHOLDER-POOL-ADDRESS"~"${POOL_URL}"~g)"

    echo "${SERVER_CONF}" > coiniumserv/config.json
  fi
}

write_pool_config () {
  POOL_CONF="$(cat coiniumserv/pools.fakecoin.json.dist \
  | sed s~"PLACEHOLDER-POOL-MOTD"~"${POOL_MOTD}"~g \
  | sed s~"PLACEHOLDER-POOL-URL"~"http://${POOL_URL}"~g \
  | sed s~"PLACEHOLDER-FAKECOIND-WALLET"~"${WALLET_ADDRESS}"~g \
  | sed s~"PLACEHOLDER-MYSQL-PASSWORD"~"${MYSQL_PASSWORD}"~g \
  | sed s~"PLACEHOLDER-MYSQL-DATABASE"~"${MYSQL_DATABASE}"~g)"
  if [[ $ADMIN_TAX_WALLET ]]; then
    POOL_CONF="$(echo "${POOL_CONF}" \
    | sed s/PLACEHOLDER-ADMIN-TAX-WALLET/"${ADMIN_TAX_WALLET}"/g)"
    echo "YUP"
  else
    POOL_CONF="$(echo "${POOL_CONF}" \
    | sed /.*PLACEHOLDER-ADMIN-TAX-WALLET.*/d)"
    echo "NUP"
  fi
  echo "${POOL_CONF}" > coiniumserv/pools.fakecoin.json
}

coiniumserv_build () {
  docker-compose build coiniumserv
}

start_service () {
  docker-compose up -d mysql
  docker-compose up -d redis
  sleep 10s
  docker-compose up -d coiniumserv
}

print_logo () {
  echo "$(cat <<EOF

                               .
                       .o@8    88bu.
                   .o@8888%    %*8888eu.
               .o@8888%"          ^%*8888eu
              8888R"                  "%8888
              "*8888bu.             .o8888R%
                 ^"*8888bu.     .o8888R%"
                     ^%*888    8888%"
                         ^%    %"

EOF
)"
}

print_info () {
  echo "\n"
  docker-compose ps
  print_logo
  echo "$(cat <<EOF

STOP ALL SERVICES:
docker-compose stop

START ALL SERVICES:
docker-compose up -d

VIEW LOGS FOR ALL SERVICES:
docker-compose up -d && docker-compose logs -f --tail=10

UPDATE SERVICE (after git pull/manual edit):
docker-compose build fakecoind
docker-compose stop fakecoind
docker-compose rm fakecoind
docker-compose up -d fakecoind

EOF
)"
}

print_logo
sleep 2
make_env_file
# fakecoind_bugfix
fakecoind_build
fakecoind_start
fakecoind_get_wallet_address
write_server_config
write_pool_config
coiniumserv_build
start_service
sleep 2
print_info
