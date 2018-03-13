FROM ubuntu:artful

ARG URL=https://download.fakco.in/nightly/fakecoin-qt/0.13.3-preview-e5607f08b/fakecoin-0.13.3-linux.tar.xz

ENV INSTALL_PATH=/app/
WORKDIR $INSTALL_PATH

RUN apt-get update && apt-get install -y software-properties-common libboost-all-dev libminiupnpc10 xz-utils libevent-pthreads-2.1-6 libevent-2.1-6
RUN add-apt-repository -y ppa:bitcoin/bitcoin && apt-get update && apt-get install -y libdb4.8 libdb4.8++

ADD $URL $INSTALL_PATH/
RUN FILE_NAME=$(basename $URL) && FOLDER_NAME=$(echo $FILE_NAME | sed -e s/.tar.xz//g) && \
    tar xJvf $FILE_NAME && \
    mv $FOLDER_NAME/* /usr/local/bin && \
    rm -rf $FOLDER_NAME && rm -rf $FILE_NAME

ADD fakecoin.conf $INSTALL_PATH
ADD start.sh $INSTALL_PATH

ENTRYPOINT ["bash", "./start.sh"]
# ENTRYPOINT ["bash"]
