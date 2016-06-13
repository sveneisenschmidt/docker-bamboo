FROM ubuntu:16.04

MAINTAINER sven.eisenschmidt@gmail.com

RUN PACKAGES="\
        default-jdk \
        wget \
    " && \
    apt-get update && \
    apt-get install -y $PACKAGES && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


COPY build /tmp/build
ENV VERSION 5.12.2
EXPOSE 8085
EXPOSE 54663

RUN DOWNLOAD_URL=https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-$VERSION.tar.gz && \
    SOURCE_FILE=/tmp/bamboo.tar.gz && \
    TARGET_DIR=/opt/bamboo/$VERSION && \
    wget -q -O $SOURCE_FILE $DOWNLOAD_URL && \
    mkdir -p $TARGET_DIR && \
    tar -C $TARGET_DIR -xvzf $SOURCE_FILE --strip=1 && \
    rm $SOURCE_FILE && \
    cp /tmp/build/bamboo-init.properties $TARGET_DIR/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties

RUN PACKAGES="\
        wget \
    " && \
    apt-get remove --purge -y $PACKAGES && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/bamboo/$VERSION

CMD ["bin/start-bamboo.sh", "-fg"]
