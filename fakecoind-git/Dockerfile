FROM ubuntu:artful

ARG BRANCH=master

ENV INSTALL_PATH=/app/
WORKDIR $INSTALL_PATH

RUN apt-get update && apt-get install -y git software-properties-common \
    build-essential libtool autotools-dev autoconf pkg-config libevent-dev \
    openssl libssl-dev libboost-all-dev libprotobuf-dev protobuf-compiler \
    libminiupnpc-dev && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -y ppa:bitcoin/bitcoin && apt-get update && \
    apt-get install -y libdb4.8-dev libdb4.8++-dev && \
    rm -rf /var/lib/apt/lists/*

RUN git clone -b $BRANCH https://github.com/Fake-Coin/FakeCoin-qt.git $INSTALL_PATH/FakeCoin-qt

RUN cd $INSTALL_PATH/FakeCoin-qt/ && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local/ --without-gui --enable-upnp-default --enable-shared=no --disable-tests --disable-gui-tests && \
    make && make install && cd $INSTALL_PATH && rm -rf FakeCoin-qt

ADD fakecoin.conf $INSTALL_PATH
ADD start.sh $INSTALL_PATH

ENTRYPOINT ["bash", "./start.sh"]
#ENTRYPOINT ["bash"]
