---
layout: archive
title: "nginx streaming server #1 hls"
date: 2021-05-13 01:32:12 +0900
categories: nginx streaming
tag:
- nginx streaming
blog: true
author: ysh
description: 
comments: true
---

## Overview
HLS 란 HTTP LIVE STREAMING으로 HTTP를 사용하는 스트리밍 프로토콜입니다. 일반적으로 RTSP, RTP, RTMP 등의 미디어 전송 관련 프로토콜들은 추가적인 장비가 필요하거나, 방화벽이 문제가 되거나, NAT가 문제가 되거나, 서버구축비용이 많이 들거나 하는 문제가 발생합니다.   
하지만 HLS는 이미 구축된 HTTP 프록시 장비들을 그대로 사용할 수 있는 장점이 있으며, 방화벽과 NAT에 영향을 덜 받는 장점이 있습니다. 다만 HTTP특성상 `Request`와 `Response` 구조로 다른 실시간 프로토콜보다 `latency`가 높을 수 있습니다.

## Prepare
HTTP Live Streaming 서버를 구축하기 위해서는 아래 3가지 모듈들이 요구됩니다.
1. receiver로써 동작할 HTML page나 단말 앱
2. Web Server 또는 CDN
3. 스트림 또는 미디어 파일을 잘게 분할해줄 모듈

단말은 http 로 파일 리스트와 영상 파일을 주기적으로 웹서버로 요청할것입니다. 
웹서버는 단말의 요청에 잘게 분할된 영상 파일의 리스트를 응답해주거나, 잘게 분할된 영상 파일을 응답해줍니다.
스트림 또는 영상파일로부터 잘게 분할된 파일을 생성해주는 모듈이 있어야 웹서버는 단말에 요청에 응답할 수 있을것입니다.

HTTP Live Streaming의 장점은 일반 웹서버로도 스트리밍 서버를 구축할수 있다는 점입니다. 웹서버는 파일 확장자별로 MIME Type을 아래와 같이 매핑하여 응답해주면 됩니다.

|File Extension| MIME TYPE|
|---|---|
|.m3u8|vnd.apple.mpegURL|
|.ts|video/MP2T|
|.mp4|video/mp4|

`.m3u`와 `.m3u8` 파일은 `manifest` 파일로 사용되며 파일의 리스트 및 환경설정값들을 포함하고 있습니다.두포멧이 차이점은 `.m3u`파일은 `Windows-1252`또는 `cp932` 포멧을 사용하고있다고 하며, `.m3u8`이 `utf-8`인코딩 되었음을 명시합니다.   
`.ts` 파일은 잘게 분할된 미디어 전송용 파일입니다.   
`.mp4` 파일은 잘 알고있는 미디어 컨테이너 파일입니다.   

### m3u/m3u8
파일의 리스트 및 환경값을 포함하고 있으며 Text형태로 이루어져있어, 압축을 하여 전송하고, 단말에서 압축해재하는 방법을 사용하는경우도 있다고 합니다. 스트리밍의 경우 빈번하게 재 다운로드가 이루어 집니다.항상 최신 인덱스를 내려받아야 하기 때문에 TTL 값이 적절히 적어게하여 cache동작을 조절해야합니다. VOD의 경우는 단 한번만 다운받아도 되므로 재요청이나 캐싱에 대해 신경쓰지 않아도 됩니다.


## nginx streaming server 
`nginx-rtmp-module`은 스트리밍 `rtmp`를 수신하면 작게 분할된 미디어 파일을 생성해주는 모듈입니다.   
`nginx`는 `nginx-rtmp-module`이 생성해준 파일들을 요청에 따라서 응답을 해줍니다.   

### nginx config
아래 설정된 내용을 간략하게 설명하면 포트 1935로 수신된 rtmp 패킷들을 /mnt/streaming 에 작게 분할된 미디어 파일인 `.ts` 과 이 미디어 파일들의 인덱스파일인 `.m3u8`파일을 생성합니다. 포트 8085로 수신된 단말의 http 요청에 대해 파일로 응답을 하며 root 경로는 `/mnt` 입니다.   
rtmp 설정의 상세값들은 [link](https://github.com/arut/nginx-rtmp-module/wiki/Directives#rtmp) 에서 확인할 수 있습니다.

``` conf
worker_processes  auto;
events {
    worker_connections  1024;
}

# RTMP configuration
rtmp {
    server {
        listen 1935; # Listen on standard RTMP port
        chunk_size 4000; # default RTMP chuck size

        application streaming {
            live on;
            hls on;
            hls_path /mnt/streaming/; # file save path
            hls_fragment 3; # file count
            hls_playlist_length 60; 
            # disable consuming the stream from nginx as rtmp
            deny play all;
        }
    }
}

http {
    sendfile on;
    tcp_nopush on;
    aio on;
    directio 512;
    default_type application/octet-stream;

    server {
        listen 8085;

        location / {
            # Disable cache
            add_header 'Cache-Control' 'no-cache';

            # CORS setup
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Expose-Headers' 'Content-Length';

            # allow CORS preflight requests
            if ($request_method = 'OPTIONS') {
                add_header 'Access-Control-Allow-Origin' '*';
                add_header 'Access-Control-Max-Age' 1728000;
                add_header 'Content-Type' 'text/plain charset=UTF-8';
                add_header 'Content-Length' 0;
                return 204;
            }
            # MIME Type
            types { 
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
            # root path
            root /mnt/;
        }
    }
}


```
## input live stream (rtmp)
nginx의 포트 1935에 스트리밍영상을 전송합니다. 

### ffmpeg -> rtmp -> nginx
```
ffmpeg -re -i /home/ysh8361/test2.mp4 -vcodec libx264 -vprofile baseline -g 30 -acodec aac -strict -2 -f flv rtmp://localhost/streaming/buny
```
### gstreamer -> rtmp -> nginx
```
gst-launch-1.0 filesrc location=/home/ysh8361/test2.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! flvmux name=mux ! rtmpsink location=rtmp://localhost/streaming/buny  demux.audio_0 ! queue ! aacparse ! mux.
```

## play
### 1. play streaming with vlc 
스트리밍을 확인하기 위해 vlc 를 실행합니다. `미디어 > 네트워크 스트림 열기 > 네트워크` 에서 `http://sanghotest.iptime.org:8085/streaming/bunny.m3u8` 주소를 입력 후 재생을 합니다.

todo 사진

### 2. play streaming with HTML5 (hls.js)
``` html
<!DOCTYPE html>
<html>
<head>
<script src="http://cdn.jsdelivr.net/hls.js/latest/hls.min.js"></script>
</head>
<body>
TEST
   <video id="video" controls></video>
  <script type="text/javascript">
    var video = document.getElementById("video");
    var videoSrcHls = "http://sanghotest.iptime.org:8085/streaming/bunny.m3u8";

    if(Hls.isSupported()) {
      var hls = new Hls();
      hls.loadSource(videoSrcHls);
      hls.attachMedia(video);
      hls.on(Hls.Events.MANIFEST_PARSED,function() {
        video.play();
      });
    }
  </script>
</body>
</html>
```



### 1. request manifest(index) file
먼저 스트리밍 단말은 http 요청으로 `/hls/bunny.m3u8` 파일을 요청합니다. nginx의 설정은 root 위치가 `/mnt` 이므로 실제 파일은 `/mnt/hls/bunny.m3u8` 파일이 해당됩니다.

cat /mnt/hls/bunny.m3u8
```
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-MEDIA-SEQUENCE:0
#EXT-X-TARGETDURATION:4
#EXT-X-DISCONTINUITY
#EXTINF:3.000,
bunny_1-0.ts
#EXTINF:3.750,
bunny_1-1.ts
#EXTINF:3.750,
bunny_1-2.ts
#EXTINF:3.875,
bunny_1-3.ts
```


## Reference
https://developer.apple.com/documentation/http_live_streaming/deploying_a_basic_http_live_stream
https://docs.peer5.com/guides/setting-up-hls-live-streaming-server-using-nginx/

https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/Using_HTML5_Audio_Video/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009523
https://developer.apple.com/streaming/fps/