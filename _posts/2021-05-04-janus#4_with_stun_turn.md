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

일반적으로 WebRTC가 잘 작동하려면 peer간에 트래픽을 중계하는 서버가 필요합니다. 동일한 네트워크에 속해있지 않는다면 NAT나 firewall 등으로 인해 직접 통신할 수 없는경우가 많기 때문입니다. 이를 해결하기 위해서는 `STUN` 또는 `TURN` 서버가 필요합니다.

`janus`에 `STUN/TURN Server`와 연동을 해보겠습니다. 

일반적으로 `TURN` 서버는 `STUN` 기능까지 가지고 있는경우가 많습니다.   설치할 오픈소스 프로젝트인 `coturn` 경우도 `STUN`의 기능을 내장하고 있습니다.    
오픈소스 뿐 아니라 클라우드 제공 서비스를 사용할 수도 있습니다.


tcp, udp 모두 가능
### Requirements
1. 공인IP와 연결된 서버
2. Domain
3. 

### install turn server
```
apt install coturn
```

### configuration turn server


https://ourcodeworld.com/articles/read/1175/how-to-create-and-configure-your-own-stun-turn-server-with-coturn-in-ubuntu-18-04

https://docs.bigbluebutton.org/2.2/setup-turn-server.html

https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/