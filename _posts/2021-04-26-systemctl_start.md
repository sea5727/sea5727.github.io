---
layout: archive
title: "systemctl 시작하기"
date: 2021-04-26 17:30:19 +0900
categories: summary systemctl
tag:
- systemctl
blog: true
author: ysh
description: 
sidebar:
  nav: "posts_navi"
---

`systemctl` 은 `systemd(시스템 데몬)` 및 `Service Manager`를 관리하는 커맨드라인 툴입니다. 과거 리눅스버전에서 사용되던 `service` 툴을 대체하고 새로운 버전에서 사용되고 있습니다. 

`service` 란 `systemd` 에서 사용되는 하나의 `unit(단위)`개념입니다. `service`를 `unit(단위)` 파일로 구성하여 관리하고 있습니다.


### Service Status
서비스의 상태는 아래커맨드로 확인 할 수 있습니다. 
```
systemctl status <servicename.service>
...
root@DEV0:~# systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
     Loaded: loaded (/lib/systemd/system/firewalld.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-04-26 17:44:39 KST; 9s ago
       Docs: man:firewalld(1)
   Main PID: 70072 (firewalld)
      Tasks: 2 (limit: 2314)
     Memory: 28.8M
     CGroup: /system.slice/firewalld.service
             └─70072 /usr/bin/python3 /usr/sbin/firewalld --nofork --nopid

```



### Service Start
서비스를 실행합니다
```
systemctl start <servicename.service>
```

### Service Stop
서비스를 중지합니다
```
systemctl stop <servicename.service>
```

### Service Restart
서비스를 재시작 합니다.
```
systemctl restart <servicename.service>
```

### Service Reload
서비스의 변경된 설정을 재 적용하여 재시작 합니다.
```
systemctl reload <servicename.service>
```

### Service Reload-or-Restart
reload를 할지 restart를 할지 확신이 없다면 이 커맨드를 입력하면 자동적으로 결정해줍니다
```
systemctl reload-or-restart <servicename.service>
```


### Service Enable
시스템을 reboot시 자동으로 기동하게 해줍니다.
```
systemctl enable <servicename.service>
```

### Service Disable
시스템을 reboot시 자동으로 기동하지 않습니다.
```
systemctl disable <servicename.service>
```

### Show List Units 
유닛 리스트를 확인할 수 있습니다. 유닛은 서비스의 단위입니다.
```
systemctl list-units
systemctl list-units --all
systemctl list-units --all --state=failed
```

### Show List Unit Files
`systemctl list-units` 으로 확인할 수 있는 유닛은 시스템의 메모리에 등록하였거나, 등록을 시도였으나 실패한 유닛만 보여줍니다. 시스템에 적재되지 않은 상태의 리스트는 아래 커맨드로 확인 할 수 있습니다.
```
systemctl list-unit-files
```

### Create Unit File
서비스를 만들어 등록해보겠습니다. unit 파일들은 `/etc/systemd/system/` 폴더에 생성되어야 합니다.   
테스트용 서비스 작업은 /root/myjob.sh 이고,    
테스트용 서비스 이름은 mytestsvc.service 입니다.

#### 1. 먼저 service에서 실행할 작업 스크립트를 생성
```
touch /root/myjob.sh
chmod 755 /root/myjob.sh
```

``` sh
vim /root/myjob.sh
...
#!/bin/bash

echo -e " Start Systemd Test " | logger -t Testsystemd

while :
do
	echo -e "Runniog systemd"
	sleep 30
done
```
#### 2. system 폴더에 unit file을 생성
```
touch /etc/systemd/system/mytestsvc.service
chmod 644 /etc/systemd/system/mytestsvc.service
```
#### 3. unit file에 내용을 작성
```
vim /etc/systemd/system/mytestsvc.service
...
[Unit]
Description=This is the manually created service
After=network.target

[Service]
ExecStart=/root/myjob.sh

[Install]
WantedBy=multi-user.target
```
#### 4. 유닛 파일을 작성후 systemctl을 reload 후 서비스를 실행
```
systemctl daemon-reload
systemctl start mytestsvc.service
```

#### 5. 서비스가 정상적으로 실행중인지 확인
```
systemctl status mytestsvc.service
...
● mytestsvc.service - This is the manually created service
     Loaded: loaded (/etc/systemd/system/mytestsvc.service; disabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-04-26 18:09:18 KST; 2s ago
   Main PID: 71526 (myjob.sh)
      Tasks: 2 (limit: 2314)
     Memory: 752.0K
     CGroup: /system.slice/mytestsvc.service
             ├─71526 /bin/bash /root/myjob.sh
             └─71529 sleep 30

```


### Viewing Unit File 
유닛파일의 내용을 확인할 수 있습니다.
```
systemctl cat <servicename.service>
```


### show dependencies
서비스의 의존성을 확인할수 있습니다.
```
systemctl list-dependencies <servicename.service>
```

### View Properties
서비스의 속성정보를 확인할 수 있습니다.
```
systemctl show <servicename.service>
```

### Rerference
더 자세한 내용을 확인할 수 있습니다.
[참고#1](https://www.liquidweb.com/kb/what-is-systemctl-an-in-depth-overview/)