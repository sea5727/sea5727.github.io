---
layout: archive
title: "janus 시작하기 #5 with TURN"
date: 2021-05-10 04:00:00 +0900
categories: janus stun turn
tag:
- janus stun turn
blog: true
author: ysh
description: 
sidebar:
  nav: "posts_navi"
comments: true
---

janus를 TURN 과 연동해보록 하겠습니다.

## turn test
일부 NAT 환경에서는 stun만으로 직접 통신이 되지 않을수 있습니다. 일부 데이터망에서 직접 통신이 되지 않는경우가 있습니다. 이때는 turn 을 사용해서 경우하여 통신해야 합니다.    
저는 TURN을 사용해야하는 환경이 잘 만들어지지않아 강제로 ICE stun으로는 통신이 불가능하도록하여 turn 을 사용하도록 해보겠습니다.

coturn 과 janus가 같은 NAT환경 내부라면 강제로 turn서버를 사용해야하는 환경으로 만들수 있습니다.    

coturn 설정의 external-ip를 주석을 해준후 실행하여야 합니다.

#### /etc/turnserver.conf
``` ini
listening-port=3478
#external-ip=<public-ip>/192.168.0.1 # 이 옵션은 coturn 과 janus가 같은 NAT내부에 있는경우 공인IP를 채워 설정해주어야 합니다. 
verbose 
fingerprint
lt-cred-mech # long term cridential mechanism
realm=sanghotest.iptime.org
server-name=sanghotest.iptime.org 
log-file=/var/log/coturn/turn.log # 로그 경로는 turnserver 계정권한으로 잘 확인하고 설정해야합니다.
user=sanghotest:sanghopwd
simple-log
```

## modify janus configuration
janus 서버의 STUN 설정도 수정하겠습니다.
#### janus.jcfg
``` ini
nat: {
    stun_server = "sanghotest.iptime.org"
    stun_port = 3478
    nice_debug = true
    turn_server = "sanghotest.iptime.org"
    turn_port = 3478
    turn_user = "sanghotest"
    turn_pwd = "sanghopwd"
}
```

## plugin(echotest.js)에 TURN 서버 추가
`echotest.js` 와 `janus.js` 파일에 turn 서버값을 추가하겠습니다.   
제 도메인은 `sanghotest.iptime.org` 입니다.
echotest.js
``` js
janus = new Janus(
	{
		server: server,
		iceServers: [
			{urls: "turn:sanghotest.iptime.org", username: "sanghotest", credential: "sanghopwd"},
      {urls: "stun:sanghotest.iptime.org"},
		],
```

## turn 결과
실제로 turn 서버를 경유하여 통신하는것을 확인할 수 있습니다.

#### 3478 포트로 패킷 캡쳐
<img src="/assets/images/janus/2021-05-10_turn_packet_caputre.png" alt=""/>

#### janus 화면
<img src="/assets/images/janus/2021-05-10_turn_janus_echotest.png" alt=""/>



### coturn reference
https://ourcodeworld.com/articles/read/1175/how-to-create-and-configure-your-own-stun-turn-server-with-coturn-in-ubuntu-18-04   
https://docs.bigbluebutton.org/2.2/setup-turn-server.html   
https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/   
https://meetrix.io/blog/webrtc/coturn/installation.html   
https://nextcloud-talk.readthedocs.io/en/latest/TURN/   
https://docs.bigbluebutton.org/2.2/setup-turn-server.html   
https://gabrieltanner.org/blog/turn-server   