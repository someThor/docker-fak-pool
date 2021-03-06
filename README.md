# <> All in one docker-compose [FAK](https://fakco.in/) mining pool <>
* [FakeCoin-qt](https://github.com/Fake-Coin/FakeCoin-qt)
* [CoiniumServ](https://github.com/bonesoul/CoiniumServ)
* [MySQL](https://www.mysql.com/)
* [Redis](https://redis.io/)


## Requirements
* [Docker](https://www.docker.com/)

## Install Options
* [FAKing easy](#the-easy-way)
* [FAKing medium](#the-medium-way)
* [FAKing hard](#the-hard-way)

### <a name="easyway"></a>The easy way
```
git clone https://github.com/someThor/docker-fak-pool.git
cd docker-fak-pool
./install.sh
```

### <a name="mediumway"></a>The medium way
#### Optional: copy config file, edit.
```
cp ./install-config.dist ./install-config
vi ./install-config
```

#### Options (everything is optional. Change values but don't delete exports):
* POOL_URL - used in info, and to generate stratum link.
* POOL_LOCATION - us/eu [ISO_3166-1_alpha-2](http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
* DOCKER_USER - build images as DOCKER_USER/IMAGE_NAME
* GIT_FAKECOIND_BRANCH - Git brach to clone and build
* WALLET_ADDRESS - auto-fetched from wallet.dat on ./install.sh run
* ADMIN_TAX_WALLET - server admin wallet, will be added to pool tax block

#### Optional: Use old wallet.dat
```
cp [WALLET_LOCATION] ./conf-fakecoind/
```

#### Then:
```
./install.sh
```

### <a name="hardway"></a>The hard way
#### Create and edit .env file
```
cp .env-dist .env
vi .env
```


#### Start fakecoind service, and get account wallet address:
```
docker-compose build fakecoind
docker-compose up fakecoind -d
docker-compose exec fakecoind sh -c \
'fakecoin-cli -rpcuser=username -rpcpassword=password getaccountaddress ""'
```

#### Edit CoiniumServ pool config
(./coiniumserv/pools.fakecoin.json)

```
    "meta": {
        "motd": "PLACEHOLDER-POOL-MOTD",
        "txMessage": "PLACEHOLDER-POOL-URL"
    },
    "wallet": {
        "address": "PLACEHOLDER-FAKECOIND-WALLET"
    },
    "rewards": [
      {
        "PLACEHOLDER-ADMIN-TAX-WALLET": 0.5,
        "tJuRYmQmHpTbp5G8P2M4tj1Dm4drWeaPEw": 0.05,
        "tNESH7xLgzqEMJhrExKgvZBCJaMMZAuAC3": 0.05,
        "tShwoodssSS3as5F13JXE6JKVjggfpwfSd": 0.05,
        "tFUCKoPG4AC8VEeo3ATPcfREVYnbAuEsaF": 0.05,
        "tBc3x4FXafx2qF7LGFGqbDq9haB1pnd3Vi": 0.05,
        "tVALkEN252wqpLAA54RQdnKZ3HKNe9fRop": 0.05,
        "tSCYNE9TvpeQ4bjDMuvr9VbNGSuE8Gu8rY": 0.15
      }
    ],
```

#### Start everything
```
docker-compose up -d
```

#### View logs
```
docker-compose logs -f --tail=10
```
