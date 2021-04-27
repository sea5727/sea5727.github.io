---
layout: archive
title: "tls/ssl 시작하기"
date: 2021-04-27 03:24:59 +0900
categories: summary tls
tag:
- tls ssl
blog: true
author: ysh
description: 
sidebar:
  nav: "posts_navi"
---

### Certificate Format
https나 다른 tls/ssl 프로토콜을 사용하려하면 라이브러리들이 지원하는 인증서 포맷이 다른경우가 많습니다.

#### pem
.pem 은 Privacy Enhanced Mail를 나타냅니다. base64 로 인코딩된 파일 포맷이라는 의미입니다.

#### key
.key 파일은 private.key, public.key 처럼 key라는 의미를 나타내는 포맷입니다. .key파일은 pem포맷으로 되어있습니다.

#### crt

#### csr


### create openssl certificate
```
openssl genrsa -out private.key 2048
```


### create csr
openssl req -new -key private.key -out csr.csr
openssl req -new -key private.key -out private.csr


### create self-signed PEM file
```
openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem
```

[참고#1](https://www.suse.com/support/kb/doc/?id=000018152)