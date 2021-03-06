---
layout: archive
title: "Interactive Connectivity Establishment (ICE)"
date: 2021-05-05 02:32:13 +0900
categories: rfc ICE
tag:
- rfc ICE
blog: true
author: ysh
description: 
sidebar:
  nav: "posts_navi"
---


## Introduce
NAT 환경의 호스트가 또 다른 NAT 환경의 호스트와 통신을 하기 위해서는 `hole punching` 이라는 기술로 직접 통신할 경로를 찾아보는 시도를 사용할 수 있습니다.   
[hole punching](REF5128찾아보기)은 어떤한 서버 경유 없이 호스트와 호스트간의 NAT를 가로질러 다른 호스트로 통신을 할 수 있는 기술입니다.

`hole punching`은 다만 두 호스트 모두 NAT 환경에 있고, NAT가  `address-dependent mapping` 또는 `address and port dependent mapping`으로 동작한다면 정상적으로 동작하지못하고 실패가 발생합니다.   

직접 통신 경로를 찾지 못할 때 패킷을 경유시켜 전달할 필요가 있습니다. `TURN`은 `STUN`의 확장 기술로써 공인 인터넷 망에 위치하여 NAT 환경에 속해있는 두 호스트들이 주고받아야하는 패킷을 relay해주는 프로토콜입니다.   

`TURN client`는 `TURN server`에게 릴레이를 할 `IP`, `Port`를 요청합니다. 그리고 `client`는 `TURN Server`로 받은 릴레이용 `IP`, `Port`로 릴레이할 패킷을 전송하면 `TURN server`는 패킷을 적절한 peer에게 릴레이 합니다. 

NAT환경의 두 단말이 TURN 서버를 사용해서 통신을 하는것은 `TURN 서버` 측에서는 상당한 cost가 소요 되기 때문에, 두 단말이 직접 통신이 불가능한 경우에만 TURN 서버 경유를 사용해야 합니다. 따라서 `client`와 `peer`는 `ICE`을 사용해 먼저 `hole punching`으로 직접 통신할수 있는 경로를 찾고, 찾을 수 없는경우 `TURN server`를 사용해야합니다. 또한 `TURN` 은 `ICE` 없이도 사용할 수 있습니다. 

`TURN` 은 `STUN` 프로토콜의 확장이므로 대부분(전부는 아님)의 `TURN message`는 `STUN`의 규격 메시지를 포함하고 있습니다.


## 1 STUN
Client가 `STUN Server` 에게 `Binding Request` 요청을 하면 서버는 `Binding Response`응답을 `XOR-MAPPED-ADDRESS` 값에 Client의 Source IP, Source Port를 담아 회신합니다.



## 2.1 Transports
`TURN`은 `server`와 `peer`간은 항상 `UDP`를 사용합니다. 반대로 `TURN client`와 `TURN server`는 `UDP`, `TCP`, `TLS`가 사용될 수 있습니다.    
즉, `STUN client`와 `STUN Server`간에 `TCP` 또는 `TLS` 로 통신한다면 `STUN server`는 `UDP`로 바꿔 `peer`에게  전달합니다.(최신 TURN은 TCP 등도 지원하는지 확인이 필요함.)

### TCP (TURN client <-> TURN server)
방화벽이 모든 UDP를 막고있다면 TCP를 사용해야 합니다. 또한 TCP는 `three-way handshake` 특징으로 Server에게 더 분명하게 커넥션을 연결하거나, 더 명확하게 커넥션을 종료할수 있습니다. 반면 UDP는 timer를 사용한다거나 추가적으로 추측하는 동작이 필요할것입니다.

### TLS (TURN client <-> TURN server)
`TURN`에 의해 기본 인증은 제공하지 않기 때문에 추가적으로 보안 특성이 필요하다면 TLS를 사용해야합니다. 하지만 relay 특성상 많은 서버 cost필요하며, 추가적으로 암호화 비용이 소모 되고, TLS 메시지를 UDP datagram 및 암호화를 하는 추가적인 과정도 필요하기에 TURN은 기본적으로 TLS를 사용하지 않습니다.

### UDP (TURN cleint <-> TURN server)
방화벽이나 다른 문제가 없다면 UDP를 사용하여 통신할 수 있습니다.



### 2.2 Allocations
기본 동작으로 `client`는 서버로 `Allocate`요청 메시지를 전달하고 서버는 `Allocate` 성공 응답으로  `client와 통신할 릴레이 전송 주소`을  리턴합니다.    
`Allocate` 요청 메시지에는 `allocate lifetime`, `client authenticate`, `long-tem credential mechanism` 등을 포함할수 있습니다. 

릴레이될 전송 주소가 할당이 되었다면, `client`는 주기적(주기:Allocate 요청 메시지의 lifetime, default:10minute)으로 `Refresh` 요청 메시지를 서버에게 전송하여 `keep alive`를 유지해야합니다. 그리고 서버는 할당한 `allocate` 가 해제가 된다면 `client` 에게 알려야 합니다.

### 2.3 Permission
`TURN server` 는 권한을 인증하는 기능을 가지고 있습니다. `client`는 `CreatePermission`또는 `ChannlenBind` 요청메시지로  권한을 추가하거나, 갱신할 수 있습니다. 


### 2.3 Send Mechanism
`TURN` 에서 `client`와 `peer`간 통신을 하는 방법은 2가지가 있습니다.
1. `SEND` 와 `DATA` 메시지
`SEND` 메시지는 `client`에서 -> 서버로 전송할때 사용됩니다.
- `XOR-PEER-ADDRESS` attribute를 사용하여 peer의 전송 주소를 명시할 수 있습니다.   
- `DATA` attribute 에는 application data를 포함합니다. `TURN` 서버는 `DATA` attribute를 `peer`에게 추출하여 전달합니다.
`DATA` 메시지는 `server`에서 -> client로 전송할 때 사용됩니다. `client`와 `server`가 사용한 서버측의 `릴리에될 전송 주소`는 `server`와 `peer`간의 `source 주소`로 사용되게됩니다.

`SEND` 메시지는 인증되어있지 않기 때문에, `SEND`메시지를 활용하여
공격자가 악용(peer에게 메시지를 전달)할 소지가 있습니다. 따라서 `TURN`은 `SEND` 메커니즘 전에 `permission` 등록을 진행해야합니다.


2. `channel`
SEND, DATA 메시지는 36바이트의 오버헤드가 추가로 소모됩니다. 이를 보완하기위해 TURN 은 두번째 방법으로 `ChannelData` 를 제공합니다. `ChannelData`는 Send 메커니즘의 36바이트의 헤더 대신 4바이트의 channel number를 명시하여 사용합니다. 각 channel number는 peer별로 할당되게 됩니다.   
`client`는 `channel`을 할당하기 위해서 `server`로 `ChannelBinding` 요청 메시지에 할당되지않은 `channel number`와 `peer ip address`를 포함시켜 전송합니다.




https://docs.bigbluebutton.org/2.2/setup-turn-server.html

https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/