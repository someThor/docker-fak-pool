FROM mono:latest

ENV INSTALL_PATH=/usr/src/app/
WORKDIR $INSTALL_PATH

RUN apt update && apt install -y mysql-client wget

ADD start.sh $INSTALL_PATH
ADD https://github.com/bonesoul/CoiniumServ/archive/master.tar.gz $INSTALL_PATH

RUN tar zxvf master.tar.gz
RUN rm master.tar.gz

ADD ./img/FAK.png $INSTALL_PATH/CoiniumServ-master/src/web/default/Content/img/coins/icon/

RUN nuget restore -DisableParallelProcessing $INSTALL_PATH/CoiniumServ-master/CoiniumServ.sln
RUN xbuild $INSTALL_PATH/CoiniumServ-master/CoiniumServ.sln /p:Configuration="Release"

ADD config.json $INSTALL_PATH/CoiniumServ-master/build/bin/Release/config/config.json
ADD coin.fakecoin.json $INSTALL_PATH/CoiniumServ-master/build/bin/Release/config/coins/fakecoin.json
ADD pools.fakecoin.json $INSTALL_PATH/CoiniumServ-master/build/bin/Release/config/pools/fakecoin.json
RUN mv $INSTALL_PATH/CoiniumServ-master/build/bin/Release/config $INSTALL_PATH/CoiniumServ-master/build/bin/Release/config-back

ENTRYPOINT ["bash", "./start.sh"]
