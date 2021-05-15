---
layout: archive
title: "nginx streaming server #1 build"
date: 2021-05-13 01:32:12 +0900
categories: nginx streaming
tag:
- nginx streaming
blog: true
author: ysh
description: 
comments: true
---


오픈소스 `nginx` 와 `nginx-rtmp-module` 을 사용한 스트리밍 서버를 구축해보겠습니다.
먼저 `nginx`를 소스코드형태로 다운받고, 스트리밍 모듈인 `nginx-rtmp-module`의 소스코드도 내려받습니다.
`ubuntu`를 사용하신다면 `apt 저장소`로도 내려받을수 있다고 알고있습니다. 여기서는 소스코드를 빌드하는 방법으로 설치하겠습니다.

## Download nginx-rtmp-module
```
git clone https://github.com/arut/nginx-rtmp-module.git
cd nginx-rtmp-module
git checkout tags/v1.2.1
```

## Download nginx source code
[link](https://nginx.org/en/download.html)
```
wget https://nginx.org/download/nginx-1.20.0.tar.gz
tar -zxvf nginx-1.20.0.tar.gz
cd ngnix-1.20.tar.gz
```

## build nginx with nginx-rtmp-module
`--add-module` option에는 압축을 푼 `nginx-rtmp-module` 의 `path` 경로를 입력해야합니다.
```
./configure --with-http_ssl_module --add-module=/home/ysh8361/pkg/nginx-rtmp-module --prefix=/opt/nginx-1.20.0
make -j 4
sudo make install
sudo ln -s /opt/nginx-1.20.0 /opt/nginx
```

## download video/audio container file
스트리밍을 할 영상을 내려받습니다. `youtube-dl`을 사용해서 영상을 내려받았습니다. `format`은 `mp4`컨테이너와 비디오코덱은 `h264` 이며 오디오 코덱은`aac` 입니다.
```
youtube-dl -o test2 -f 136+140 https://www.youtube.com/watch?v=YE7VzlLtp-4
```

## download vlc ( client )
vlc 프로그램을 다운받으셔야합니다. vlc는 오픈소스 미디어 플레이어입니다.


## reference
https://github.com/arut/nginx-rtmp-module.git
https://docs.peer5.com/guides/setting-up-hls-live-streaming-server-using-nginx/