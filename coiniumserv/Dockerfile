FROM mono:latest

ARG BRANCH=master

ENV INSTALL_PATH=/usr/src/app/
WORKDIR $INSTALL_PATH

ENV TZ=Europe/Oslo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install -y mysql-client wget && rm -rf /var/lib/apt/lists/*

ADD start.sh $INSTALL_PATH
ADD https://github.com/bonesoul/CoiniumServ/archive/${BRANCH}.tar.gz $INSTALL_PATH

RUN tar zxvf ${BRANCH}.tar.gz
RUN rm ${BRANCH}.tar.gz

ADD ./img/FAK.png $INSTALL_PATH/CoiniumServ-${BRANCH}/src/web/default/Content/img/coins/icon/

RUN nuget restore -DisableParallelProcessing $INSTALL_PATH/CoiniumServ-${BRANCH}/CoiniumServ.sln
RUN xbuild $INSTALL_PATH/CoiniumServ-${BRANCH}/CoiniumServ.sln /p:Configuration="Release"

ADD config.json $INSTALL_PATH/CoiniumServ-${BRANCH}/build/bin/Release/config/config.json
ADD coin.fakecoin.json $INSTALL_PATH/CoiniumServ-${BRANCH}/build/bin/Release/config/coins/fakecoin.json
ADD pools.fakecoin.json $INSTALL_PATH/CoiniumServ-${BRANCH}/build/bin/Release/config/pools/fakecoin.json

RUN export CUSTOM_SCRIPT="<script src=\"https\:\/\/code.jquery.com\/jquery-2.2.4.min.js\"><\/script>" \
    && cat $INSTALL_PATH/CoiniumServ-${BRANCH}/build/bin/Release/web/default/views/layout/main.cshtml | \
    sed -e "s/<script src=\"http\:\/\/ajax.googleapis.com\/ajax\/libs\/jquery\/2.0.2\/jquery.min.js\"><\/script>//" | \
    sed -e "s/<\!-- additional js libraries-->/<\!-- additional js libraries-->\n    $CUSTOM_SCRIPT/" > /tmp/tmp.cshtml \
    && mv /tmp/tmp.cshtml $INSTALL_PATH/CoiniumServ-${BRANCH}/build/bin/Release/web/default/views/layout/main.cshtml

RUN mv $INSTALL_PATH/CoiniumServ-${BRANCH}/build/bin/Release/config $INSTALL_PATH/CoiniumServ-${BRANCH}/build/bin/Release/config-back

ENTRYPOINT ["bash", "./start.sh"]
