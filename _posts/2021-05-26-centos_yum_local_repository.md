---
layout: archive
title: "d"
date: 2021-05-13 01:32:12 +0900
categories: system 
tag:
- system CentOS yum
blog: true
author: ysh
description: 
comments: true
---

외부망과 연동되지 않은 환경에서 `yum package manager`를 사용하거나, 별도의 rpm 을 버전별로 모아 관리하는경우 `yum repository`를 구축하여 사용할 수 있습니다.

## make .repo file
저장소 파일인 `.repo` 을 생성합니다. __must be `.repo` ext format__
```
[local-repo]
name=My Custom Yum Repository
baseurl=file:///root/local-repo/
enabled=1
gpgcheck=0
```

## run createrepo <file-path>
`baseurl`에 명시한 경로를 `createrepo` 커맨드를 입력해주면 `repodata` 폴더가 생성되는것을 확인할 수 있습니다.
```
createrepo /root/local-repo
```

## move your repofile to /etc/yum.repo.d/
`/etc/yum.repo.d` 경로로 이동시킵니다.
아래 커맨드를 통해 yum 저장소를 읽어옵니다. repo가 enabled:0 인것을 확인할 수 있습니다.
```
yum clean all
yum repolist all
...
local-repo                       My Custom Yum Repository                                              enabled:     0
```

## download your rpm file
`rpm파일`을 <file-path> 에 저장후 `yum clean all`, `yum repolist all`을 입력하여 `enabled` 가 증가되는것을 확인할 수 있습니다.
구글링을 통해서 `rpm`을 다운받거나, `yum` 을 통해서도 받을 수 있습니다. `yum`에서는 설치가 되지 않은 패키지만 받을 수 있습니다.

```
yum install <package-name> --downloadonly --downloaddir=<file-path>
```