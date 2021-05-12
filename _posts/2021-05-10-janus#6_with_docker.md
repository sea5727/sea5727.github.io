---
layout: archive
title: "janus 시작하기 #6 with Docker"
date: 2021-05-10 05:32:12 +0900
categories: janus docker
tag:
- janus docker
blog: true
author: ysh
description: 
sidebar:
  nav: "posts_navi"
comments: true
---

janus, nginx, coturn을 docker 환경에서 실행 해 보겠습니다.

원본 소스는 [링크](https://github.com/sea5727/janus-gateway-docker)에서 확인할 수 있습니다.

## 1. Coturn Docker

### Docker image 생성
coturn의 경우 도커 이미지를 내려받아 사용할수 있습니다. 
```
docker pull instrumentisto/coturn
```

### Container 실행
turn서버는 많은 수의 미디어 포트연동해야하는데 도커의 포트포워딩을 사용하여 대량의 포트를 할당한다면 성능이슈가 있다고 합니다. 도커 네트웍을 host네트웍으로 잡아줍니다.   
`-n` 옵션은 default conf를 읽지 않는 옵션인것 같습니다(?) 
`container` 이름은 `coturn`으로 하였습니다. 
```
$ docker run \
-d \
--name=coturn \
--network=host \
instrumentisto/coturn \
-n \
--log-file=stdout \
--external-ip=106.243.158.190/192.168.0.1 \
--relay-ip=106.243.158.190 \
--listening-port=3478 \
--fingerprint \
--lt-cred-mech \
--realm=sanghotest.iptime.org \
--server-name=sanghotest.iptime.org \
--user=sanghotest:sanghopwd
```
### docker ps 확인
```
$ docker ps
CONTAINER ID   IMAGE                   COMMAND                  CREATED       STATUS          PORTS     NAMES
9cfc88a05b49   instrumentisto/coturn   "docker-entrypoint.s…"   3 hours ago   Up 14 seconds             coturn
```

### 기능 확인 (ICE Trickle)
[링크](https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/) 에서 기능을 확인합니다.
공인아이피를 수집한다면 성공입니다.


## Reference
https://hub.docker.com/r/instrumentisto/coturn
https://github.com/instrumentisto/coturn-docker-image

----------------------------------------------------



## 2. janus docker 실행
janus docker를 실행하겠습니다. nginx보다 janus를 먼저 생성해주는 이유는 janus의 html파일들을 nginx가 root path로 가지고 있어야 하는데, path가 없는경우 오류가 발생할수 있습니다.   
janus 컨테이너를 먼저 생성하여 html 파일들을 volume에 저장하고, nginx docker와 volume을 공유하는 방식으로 진행하였습니다.

janus 는 janus를 빌드할 환경을 가지고 있는 base image를 먼저 생성후, janus 소스를 github로부터 내려받아 빌드하는 방법으로 진행하였기 때문에 image파일이 `janus-base` 와 `janus-gateway`2개가 생성됩니다.


janus 코드를 빌드할 환경 base image 입니다.   

아래 base image는 dockerhub에서 내려받을 수 있게 해놓았습니다.
pull을 사용하거나 또는 dockerfile을 사용하세요.
#### dockerhub
```
docker pull sea5727/janus-gateway-base
```


#### janus-gateway
base file을 기반으로 janus를 빌드하고 이미지를 생성합니다.
생성될 컨테이너의 이름은 `janus-gateway` 이고, 이미지 이름은 `sea5727/janus-gateway-docker:latest` 입니다.
```
docker run -it -d \
	--name janus-gateway \
	--network WebRTC \
	--volume janus-volume:/opt/janus \
	--volume cert.crt:/opt/janus/certs/cert.crt:ro \
	--volume cert.key:/opt/janus/certs/cert.key:ro \
	sea5727/janus-gateway-docker:latest
```

#### Dockerfile
``` Dockerfile
FROM sea5727/janus-gateway-base:latest

RUN cd /tmp && \
    git clone https://github.com/sea5727/janus-gateway.git

RUN cd /tmp/janus-gateway && \
    sh autogen.sh &&  \
    rm -rf /opt/janus && \
    ./configure \
    --prefix=/opt/janus \ 
    --enable-data-channels \
    --disable-rabbitmq \
    --disable-mqtt \
    --disable-unix-sockets \
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
    ldconfig && \

CMD ["/opt/janus/bin/janus"]
```

-------------------------------------------

## 3. Nginx proxy Docker
nginx proxy 서버를 docker로 실행하겠습니다.

### nginx image download
```
docker pull nginx
```

### nginx run
```
docker run -d -it --name nginx \
	--network WebRTC \
	--volume janus-volume:/opt/janus \
	--volume ./cert.crt:/etc/nginx/certs/cert.crt:ro \
	--volume ./cert.key:/etc/nginx/certs/cert.key:ro \
	--volume ./nginx.conf:/etc/nginx/nginx.conf \
	-p 8083:80 \
	-p 8084:443 \
	nginx

```
