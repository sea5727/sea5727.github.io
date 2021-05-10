---
layout: archive
title: "janus 시작하기 #6"
date: 2021-05-02 02:32:12 +0900
categories: janus docker
tag:
- janus docker
blog: true
author: ysh
description: 
sidebar:
  nav: "posts_navi"
---

janus를 docker 환경에서 실행 해 보겠습니다.

[Docker 설치]()

``` Dockerfile
FROM buildpack-deps:stretch

RUN sed -i 's/archive.ubuntu.com/mirror.aarnet.edu.au\/pub\/ubuntu\/archive/g' /etc/apt/sources.list

RUN rm -rf /var/lib/apt/lists/*
RUN apt-get -y update && apt-get install -y \
    libjansson-dev  libnice-dev         libssl-dev \
    gstreamer1.0-tools libsofia-sip-ua-dev libglib2.0-dev \
    libopus-dev     libogg-dev          libini-config-dev \
    libcollection-dev libconfig-dev     pkg-config \
    gengetopt       libtool             autopoint \
    automake        build-essential     subversion \
    git             cmake               unzip \
    zip             texinfo             lsof \ 
    wget            vim                 sudo \ 
    rsync           cron                mysql-client \ 
    openssh-server  supervisor          locate \ 
    mplayer         valgrind            certbot \ 
    python-certbot-apache dnsutils      tcpdump \
    net-tools

RUN cd /tmp && \
    git clone https://github.com/Karlson2k/libmicrohttpd.git && \
    cd /tmp/libmicrohttpd && \
	 ./bootstrap && \
	 ./configure && \
	make && make install

RUN cd /tmp && \
    wget https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz -O libsrtp-v2.2.0.tar.gz && \
    tar xfv libsrtp-v2.2.0.tar.gz && \
    cd libsrtp-2.2.0 && \   
    ./configure --prefix=/usr --enable-openssl && \
	make shared_library && sudo make install 

RUN cd /tmp && \
    git clone https://github.com/sctplab/usrsctp.git && \
    cd usrsctp && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && make install 

# with custom http config from my janus-gateway git repository
RUN cd /tmp && \
    git clone https://github.com/sea5727/janus-gateway.git && \
    # git clone https://github.com/meetecho/janus-gateway.git && \ 
    cd /tmp/janus-gateway && \
    git checkout refs/tags/v0.10.9 && \
    sh autogen.sh &&  \
    # PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
    ./configure \
    --prefix=/opt/janus \ 
    # --enable-post-processing \
    # --enable-boringssl \
    --enable-data-channels \
    --disable-rabbitmq \
    --disable-mqtt \
    --disable-unix-sockets \
#     --enable-dtls-settimeout \
    --enable-plugin-echotest \
    --enable-plugin-recordplay \
    --enable-plugin-sip \
    --enable-plugin-videocall \
    --enable-plugin-voicemail \
    --enable-plugin-textroom \
    --enable-rest \
    --enable-turn-rest-api \
    --enable-plugin-audiobridge \
    --enable-plugin-nosip \
    --enable-all-handlers && \
    make && \ 
    make install && \ 
    make configs && \ 
    ldconfig

RUN mkdir -p /opt/cert && \
    cd /opt/cert && \
    openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem 

CMD [ "/bin/bash"]

```

``` sh
mkdir janus-gateway-docker
vim Dockerfile
...
cd anus-gateway-docker
docker build -t <user-id>/janus-gateway:dev .
docker run --name janus-gateway -d <user-id>/janus-gateway:dev /bin/bash ## port?


```



