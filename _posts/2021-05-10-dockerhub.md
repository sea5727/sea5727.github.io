---
layout: archive
title: "dockerhub 에 도커 이미지 올리기"
date: 2021-05-10 05:32:12 +0900
categories: janus docker
tag:
- janus docker dockerhub
blog: true
author: ysh
description: 
sidebar:
  nav: "posts_navi"
---

`dockerhub`는 `docker` 컨테이너 이미지를 공유하는 플랫폼입니다. 언제 어디서든 도커이미지를 등록하거나 내려받을 수 있습니다.
`dockerhub`를 사용하기 위해서는 `dockerhub`에 회원가입이 되어 있어야 합니다.

# 1. 도커 이미지 만들기
저장소에 등록하기 위한 이미지가 로컬에 존재해야합니다.
저는 `sea5727/janus-base:dev` 이라는 이미지를 사용하겠습니다.

# 2. repository 만들기
[dockerhub](https://hub.docker.com/)에서 로그인을 하고 `Create Repository`를 클릭합니다.
<img src="/assets/images/janus/2021-05-10_dockerhub_main_.jpg" alt=""/>

Repository 이름과 설명을 작성하고 Create를 누릅니다.
<img src="/assets/images/janus/2021-05-10_dockerhub_repo.png" alt=""/>

# 3. image 등록하기
`docker` 이미지를 등록하기 위해선 docker login 을 해주고, tag를 등록하고, 업로드를 하는 순서대로 진행이 됩니다.

```
docker login
docker tag <local-image>:<tagname> <new-repo>:<tagname>
docker push <new-repo>:<tagname>
```

아래 커맨드를 실제로 입력하였습니다. 
이미지 `sea5727/janus-gateway:dev` 를 `sea5727/janus-gateway:latest` 로  dockerhub에 등록하는 커맨드입니다.
이미지 이름은 `<user-id>/<image>:<tag>` 규칙을 사용하는것이 좋습니다. 

``` 
$ docker login
$ docker tag sea5727/janus-gateway:dev sea5727/janus-base:latest
$ docker push sea5727/janus-base:latest
The push refers to repository [docker.io/sea5727/janus-base]
3bb11667cabd: Pushed 
8a89bc3d26e8: Pushed 
f8f5a2b49411: Pushed 
18dc636c1fbc: Pushed 
ab950460195b: Pushed 
607d71c12b77: Mounted from library/buildpack-deps 
052174538f53: Mounted from library/buildpack-deps 
8abfe7e7c816: Mounted from library/buildpack-deps 
c8b886062a47: Mounted from library/buildpack-deps 
16fc2e3ca032: Mounted from library/buildpack-deps 
dev: digest: sha256:66a737f8440a1f3c7749a7bcd3ac5f0283a2128da7ce6abaecb9deff550c4b6a size: 2431
```

# 4. image 내려받기
```
docker pull sea5727/janus-gateway
```


# 5. docker hub tag 삭제
dockerhub 웹페이지에서 repositry를 선택 > Tags > 태그들을 선택후 `Action`에서 `Delete`를 선택해줍니다.

