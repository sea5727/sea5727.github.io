---
layout: archive
title: "janus 시작하기 #4"
date: 2021-05-04 04:00:00 +0900
categories: janus stun turn
tag:
- janus stun turn
blog: true
author: ysh
description: 
sidebar:
  nav: "posts_navi"
---

WebRTC 나 VoIP와 같이 P2P 통신을 하는경우 직접 연결이 불가능한 경우가 발생할 수 있습니다. 이유는 여러가지가 될 수 있으나 `NAT`환경과 방화벽문제입니다. 이를 해결하기 위해서 `ICE`, `STUN`, `TURN` 과 같은 프로토콜이 생겨났습니다.

## NAT (Network Addreses Translation) 
네트워크 주소를 변경시켜주는 라우터 장비입니다. 일반적으로 Wifi 공유기와 통신사의 라우트장비, 회사 사내망 라우트장비가 이에 해당됩니다. 내부망의 여러개의 호스트가 하나의 공인 IP를 사용하는 기능으로 방화벽처럼 외부로부터 통신을 차단하거나, 외부 인터넷망과 내부 망을 구분해주는 역할을 합니다. 내부 호스트의 IP가 외부로 통신될때 공인 IP로 변경되는 방식으로 동작하는데 이때 사설IP(내부)와 공인IP(외부)간에 NAT장비가 매핑을 해주고 관리를 하게됩니다. 즉, 내부에서 외부로 통신이 먼저 이루어져 매핑관계를 만들고 외부에서 매핑된 아이피로 통신이 수신된다면 내부로 통과시켜줄 수 있습니다. 하지만 매핑이 되어있지 않은 경우 외부망에서 내부망으로 들어오는 통신은 차단되게 됩니다. 

## ICE (Interactive Connectivity Establishment )
Offer/answer 프로토콜 모델의 peer-to-peer의 NAT 경유를 위한 가장 적합한 경로를 찾아주는 프로토콜입니다. STUN과 TURN 을 활용하여 적합한 인터페이스 경로를 찾아줍니다.

## STUN (Session Traversal Utilities For NAT)
NAT 환경의 호스트는 스스로 공인IP를 확인할 수 없으므로 제 3자에게 도움을 요청해야합니다. `STUN`은 호스트가 어떤 네트워크 환경인지 확인하는 프로토콜입니다. `STUN` 서버는 인터넷망에 연결되어 있습니다. 호스트 `IP 확인 요청(Binding Request)` 를 `STUN`서버로 전송하면 `STUN`서버는 클라이언트의 source IP와 source Port를 응답해줍니다.

## TURN (Traversal Using Relays around NAT)
`TURN` 은 NAT망에 속해있는 peer와 peer간의 통신과정 중간에서 relay를 하는 프로토콜입니다. WebRTC에서는 직접통신이 불가능한 NAT 환경 또는 방화벽이 있는경우 `TURN` 을 활용한 경유서버가 존재해야합니다.


janus는 google의 stun 서버 주소를 기본값으로 가지고 있습니다. stun 설정을 안하여도 내부적으로 `stun:stun.l.google.com:19302` 로 통신합니다. 구글의 서버대신 내부적으로 STUN 서버를 구축해보겠습니다. 그리고 `janus`와 `STUN Server`를 연동 해보겠습니다. 

일반적으로 `TURN` 서버는 `STUN` 기능까지 가지고 있는경우가 많습니다.   
설치할 오픈소스 프로젝트인 [coturn](https://github.com/coturn/coturn) 경우도 `TURN` 서버 이면서 `STUN`의 기능을 내장하고 있습니다.    
오픈소스를 사용하시거나 클라우드 제공 서비스를 사용할 수도 있습니다.

TURN 서버에 대해 조금더 자세한 내용은 [링크](turn..) 에 정리해보았습니다.

## Requirements
1. Public IP와 연결된 서버
2. 1.번 장비의 domain
3. subdomain?

## install turn server
[coturn](https://github.com/coturn/coturn) 에서 소스코드를 빌드하셔도 되며, 패키지 툴에서 다운받으셔도 됩니다.   
```
apt install coturn
```


## 공유기 설정
외부에서 서버에 접속이 가능하도록 STUN 포트를 포트포워딩 설정을 하였습니다. 


## 직접 통신이 가능한 경우
TURN 서버는 rtp relay 비용이 추가적으로 발생하기 때문에 NAT환경에서도 단말간 직접 통신이 가능하다면 굳이 TURN서버를 경유할 필요가 없습니다. 
이때는 `ICE`에서 `STUN`만 사용하게 될것입니다.

## configuration turn server
STUN을 위한 포트를 열어주는 설정입니다.

##### /etc/turnserver.conf
stun 포트를 설정합니다.   
external-ip는 stun/turn 서버가 janus와 같은 NAT 환경에 있다면 설정해주어야 합니다. 
``` ini
listening-port=3478
external-ip=<public-ip>/192.168.0.1
verbose
fingerprint
lt-cred-mech
log-file=/var/log/coturn/turnserver.log
simple-log

```

## restart coturn
```
systemctl restart coturn
```

## coturn test
coturn 서버에 ICE candidate가 정상적으로 수집이 되는지 확인해보겠습니다.

`https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/` 에서 STUN or TURN URI에 도멘인을 입력하고 `Add Server`를 클릭합니다. 기존에 등록되어있는 구글서버는 `Remove Server`를 합니다.  

ICE candidate에 공인IP가 수집되어야 정상입니다.
TODO : 사진



## plugin(echotest.js)에 STUN 서버 변경
`echotest.js` 와 `janus.js` 파일에 stun 서버값을 수정하겠습니다.   
제 도메인은 `sanghotest.iptime.org` 입니다.
echotest.js
``` js
janus = new Janus(
	{
		server: server,
		iceServers: [
			{urls: "stun:sanghotest.iptime.org"},
		],
```
janus.js
``` js
...
//BEFORE
//var iceServers = gatewayCallbacks.iceServers || [{urls: "stun:stun.l.google.com:19302"}];
//AFTER
var iceServers = gatewayCallbacks.iceServers
if(iceServers == null) {
  var iceServers = [{urls: "stun:stun.l.google.com:19302"}];
}
```

## modify janus configuration
janus 서버의 STUN 설정도 수정하겠습니다.
``` ini
nat: {
    stun_server = "sangho.iptime.org"
    stun_port = 3478
    nice_debug = true
}
```



<!-- turnadmin -a -u sanghotest -p sanghopwd -r sanghotest.iptime.org -->


### coturn reference

https://ourcodeworld.com/articles/reead/1175/how-to-create-and-configure-your-own-stun-turn-server-with-coturn-in-ubuntu-18-04

https://docs.bigbluebutton.org/2.2/setup-turn-server.html
https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/