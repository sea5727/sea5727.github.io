---
layout: archive
title: "janus 시작하기 #3 with Nginx"
date: 2021-05-01 00:00:00 +0900
categories: janus nginx
tag:
- janus nginx
blog: true
author: ysh
description: 
comments: true
---

janus는 내부적으로 HTTP Restful API 만을 제공합니다. 즉 서비스를 진행하기위한 웹서버가 필요합니다.   
`Janus 시작하기 #2` 에서는 웹서버를 간단한 `python`으로 실행하였습니다.
이젠 운영환경에서도 사용할 수 있는 `nginx`와 `janus`를 연동해 보겠습니다.

기본값으로 `janus`는 http는 `8088` https는 `8089`포트로 restapi를 사용하고 있습니다. 이 포트를 http는 `80`, https는 `443` 으로 변경하고 nginx에서 restapi를 janus로 연동하도록 nginx proxy를 구축하겠습니다.

## modify plugin
`echotest.js`를 수정해보겠습니다.   
플러그인에서 접속하는 http(s) 포트 `8088`과 `8089`를 `80`과 `443` 변경합니다.   
또한, http Path를 `janus` 에서 `webrtc`로 변경합니다. 웹서버와 janus 프로세스간 일부 `janus` prefix path가 겹쳐 (janus-image, janus.js 등) 충돌을 피하기 위하여 변경했습니다.(더 좋은 방법이 있으면 알려주세요.ㅠ_ㅠ)   

### before
``` js
var server = null;
if(window.location.protocol === 'http:')
        server = "http://" + window.location.hostname + ":8088/janus";
else
        server = "https://" + window.location.hostname + ":8089/janus";

```
### after
``` js
var server = null;
if(window.location.protocol === 'http:')
        server = "http://" + window.location.hostname + "/webrtc";
else
        server = "https://" + window.location.hostname + "/webrtc";
```

## modify nginx conf
`nginx.conf` 를 수정해보겠습니다.   
`/webrtc` 경로로 수신되는 메시지를 `/janus` 경로로 janus 프로세스에게 전달하도록 설정합니다.

``` conf
...
    ...
    server {
        listen       80;
        server_name  localhost;

        location / {
            root /opt/janus/share/janus/demos/;
        }

        location /webrtc {
             proxy_pass http://127.0.0.1:8088/janus;

            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

    }

    # HTTPS server
    server {
        listen       443 ssl;
        server_name  localhost;

        ssl_certificate      /opt/cert/cert.pem;
        ssl_certificate_key  /opt/cert/key.pem;

        ssl_session_cache    shared:SSL:1m;
        ssl_session_timeout  5m;

        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers  on;

        location / {
            root /opt/janus/share/janus/demos;
        }

        location /webrtc {
            proxy_pass https://127.0.0.1:8089/janus;

            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
        }

    }

...

```
## restart nginx
nginx와 janus를 재기동해줍니다.
```
systemctl restart nginx
```

## start echotest 
`browser`에서 janus로 접속하여 echotest를 실행합니다.

## 마무리
nginx 를 사용하여 janus앞단에 http proxy를 구축해보았습니다.

