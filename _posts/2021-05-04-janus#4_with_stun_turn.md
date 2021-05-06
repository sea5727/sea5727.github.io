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

WebRTC 테스트를 하는 도중 스마트폰으로 wifi를 사용한경우는 잘 되던 기능들이 데이터를 사용하면 연결이 되지 않는 문제가 발생하였습니다. 또한 데이터를 사용한 장소와 통신사에 따라서 통신이 되는경우와 안되는 경우가 있습니다. 자세한건 NAT 장비에 대한 설명을 확인해야할것 같습니다. peer간 직접 통신이 되지 않는 경우를 위한 내용을 정리해보았습니다. 


## NAT (Network Addreses Translation) 
네트워크 주소를 변경시켜주는 라우터 장비입니다. 일반적으로 Wifi 공유기와 통신사의 라우트장비, 회사 사내망 라우팅장비가 이에 해당됩니다. 여러개의 내부 호스트가 하나의 공인 IP를 사용하는 기능으로 방화벽처럼 외부로부터 통신을 차단하거나, 외부 인터넷망과 내부 망을 구분해주는 역할을 합니다. 다만 내부 호스트의 IP가 외부로 통신될때 공인 IP로 변경되는 방식으로 동작하기때문에 외부에서 먼저 통신을 시도하는경우 특별한 설정이 없으면 차단되어 실패가 발생합니다. 이를 극복하기위해 STUN, TURN, ICE 등과 같은 기술이 있습니다. 


## ICE (Interactive Connectivity Establishment )
Offer/answer 프로토콜 모델의 peer-to-peer의 NAT 경유를 위한 가장 적합한 경로를 찾아주는 프로토콜입니다. STUN과 TURN 을 활용하여 적합한 인터페이스 경로를 찾아줍니다.

## STUN (Session Traversal Utilities For NAT)
NAT 환경의 호스트는 스스로 공인IP를 확인할 수 없으므로 제 3자에게 도움을 요청해야합니다. `STUN`은 호스트가 어떤 네트워크 환경인지 확인하는 프로토콜입니다. `STUN` 서버는 인터넷망에 연결되어 있습니다. 호스트 `IP 확인 요청(Binding Request)` 를 `STUN`서버로 전송하면 `STUN`서버는 호스트의 

## TURN 
`TURN` 은 peer와 peer간의 통신과정 중 중간에서 relay를 하는 프로토콜입니다. WebRTC에서는 직접통신이 불가능한 NAT 환경 또는 방화벽이 있는경우 `TURN` 을 활용한 경유서버가 존재해야합니다.

이제 `janus`에 `STUN/TURN Server`와 연동을 해보겠습니다. 

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

## port forwarding
`STUN/TURN server` 는 인터넷망에 직접 연결이 되어있어야 합니다. 공유기를 사용한다면 포트포워딩이나 bridge모드로의 변경이 필수적입니다.    
포트포워딩의 경우은 하나의 포트(tls도 사용한다면 2개의 포트)만 설정해주어도 되므로 포트포워딩으로 진행하였습니다.
STUN의 default 포트인 3478을 제 vm 장비의 3478포트로 포트포워딩 설정을 하였습니다.


## 직접 통신이 가능한 경우
TURN 서버는 rtp relay 비용이 추가적으로 발생하기 때문에 NAT환경에서도 단말간 직접 통신이 가능하다면 TURN서버를 경유할 필요가 없습니다. 
이때는 `ICE`에서 `STUN`만 사용하게 될것입니다.

## configuration turn server
STUN을 위한 포트를 열어주는 설정입니다.
``` ini
vim /etc/turnserver.conf
listening-port=3478
#tls-listening-port=5349
##
```

## restart coturn
```
systemctl restart coturn
```

## plugin에 STUN 서버 설정
peer에서 동작할 echotest.js 에 stun 서버 ip와 port를 입력해줍니다. janus.js 파일에는 모두 기본값으로 `stun:stun.l.google.com:19302` 로 설정이 되어있습니다. 테스트를 위해
직접 설치한 coturn 서버로 변경하겠습니다.
Janus 객체 파라미터로 iceServers를 추가해줍니다.
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



### configuration turn server


https://ourcodeworld.com/articles/read/1175/how-to-create-and-configure-your-own-stun-turn-server-with-coturn-in-ubuntu-18-04

https://docs.bigbluebutton.org/2.2/setup-turn-server.html

https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/