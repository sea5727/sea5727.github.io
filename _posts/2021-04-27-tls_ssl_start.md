---
layout: archive
title: "tls/ssl 시작하기"
date: 2021-04-27 03:24:59 +0900
categories: summary
tag:
- tls ssl
blog: true
author: ysh
description: 
comments: true
---

tls 또는 ssl 는 안전한 통신을 하기 위해 사용되는 프로토콜 스택(?) 입니다. 안전한 통신은
1. 통신 내용이 노출되서는 안된다.
2. 접속하는 대상이 접속 하려는 서버가 맞는지 신뢰할수 있어야 합니다.
3. 통신 내용이 변경되서는 안됩니다.

암호화 통신을 하기위해서 알아야 하는 내용은 

## Plaintext (평문)
암호화가 진행되기 전 해독 가능한 형태의 메시지입니다.

## Ciphertext 암호문)
암호화가 진행된 후 해독 불가능한 형태의 메시지입니다.

## Encryption (암호화)
`Plaintext`를 `Ciphertext` 로 변환하는 과정입니다.

## Decryption (복호화)
`Encryption`의 반대개념으로 `Ciphertext`를 `Plaintext` 로 변환하는 과정입니다. 

## Symmetric-Key Encryption (대칭키 암호화 방식)
`암호화(encrypt)`에 사용한 키로 `복호화(decrpyt)`에서도 사용하는 1개의 키를 사용하여 암/복호화를 하는 암호화 방식입니다. `AES`, `DES`, `ARIA` 등의 암호화방식이 대칭키 암호화 방식입니다.

## Asymmetric-Key Encryption (비대칭키/공개키 암호화 방식)
`encrypt`와 `decrpyt`를 다른 키로 사용하는 방식입니다. 
`public key(공개키)`와 `private key(개인키)` 라 불리는 2개의 키가 존재합니다. 암호화된 메시지를 통신할때는 `public key`로 `encrypt`를 `private key`로 `decrypt`를 하여 사용하고, `electronic signature(전자 서명)`에 사용할때는 `encrypt` 를 `public key`로 `decrypt`를 `private key`로 진행합니다. 

## Private-Key (개인키)
개인키는 외부로 유출되서는 안되는 키입니다. 

## Public-Key (공개키)
공개키는 외부로 유출될 수 있는 키이며, CA에게 전달하거나, 직접 클라언트에게 전달하여 사용할 수 있습니다.

## Certificate Authority (CA)
암호화 통신과정에서 제 3자로 역할로, 인증서를 보관하는 역할을 합니다. 공인기관 CA와 사설기관 CA가 존재합니다.

## Certicate (인증서)
개인키의 소유자의 공개키에 인증기관의 개인키로 서명한 전자문서 입니다. 간단히 제3자가 인증(보증)해주는 전자문서입니다. 인증서는 _1. 서비스의 정보(인증서를 발급한 CA, 서비스 도메인 등)_ 과 _2. 서버측 공개키(공개키의 내용, 암호화방법)_ 정보를 가지고 있습니다. 클라이언트가 접속 하려던 서버에 접속하는것이 맞는지 확인할 때 사용합니다.

## Self Signed Certificate 
공인기관 CA의 서명을 받지 않은, 사설기관에서 서명 혹은 직접 서명을 한 인증서입니다. 웹 브라우저에서는 공인 CA에게 서명을 받은 인증서를 사용하면 주소창에 경고 표시를 출력합니다.



## Mechanism (인증서 사용 방법)
1. 클라이언트가 서버에 접속 시도를 합니다.
2. 서버는 클라이언트에게 `인증서`를 전달합니다.  
3. 클라이언트는 이 인증서를 CA가 내장된 CA(공인기관CA리스트는 웹브라우저에 내장됨) 인지 확인합니다.
 - 내장된 CA라면 `CA의 공개키` 로 `복호화`를 합니다. ( 인증서는 인증기관의 개인키로 서명된 문서입니다. )
 - TODO : 내장된 CA가 아니라면 추가 과정을 통해 CA의 공개키를 획득하여 복호화 하거나, self-signed-certificate 처리되어 경고를 표시하는것 같습니다.

## ssl 동작 방법
`ssl`은 암호화 데이터를 전송하기 위해 `대칭키` 와 `비대칭키/공개키` 방식을 혼합해서 사용합니다. 암호화된 실제 데이터를 복호화 할때는 `대칭키`를, 이 `대칭키`를 전달할때는 `공개키` 방식을 사용합니다. 
### 1. handshake
- client hello
클라이언트는 `생성한 랜덤 데이터`와 `지원하는 암호화 방식`, `세션 아이디`를 서버에게 전송합니다.
`세션 아이디`는 기존에 이미 ssl 연결이 되어있는지 확인하여 비용을 줄이기 위해 사용됩니다.
- server hello, Certificate
서버는 `서버측에서 생성한 랜덤 데이터`와 `서버가 선택한 암호화 방식` , 그리고 `인증서` 응답합니다.
- key exchange
클라이언트는 처음에 `스스로 생성한 랜덤데이터`와 `서버로부터 받은 랜덤데이터`를 사용하여 대칭키를 생성합니다. 대칭키를 서버의 공유키를 사용하여 암호화하여 서버에게 전달합니다. 서버는 개인키로 복호화 후 대칭키를 얻을 수 있습니다.

### 2. Session

### 3. Session Close



## tls/ssl 사용하기
`ssl` 을 사용하기 위해서는 일반적으로 `certificate (.pem)` 과 `privatekey(.key)` 파일이 필요합니다. 확장는 `.pem`, `.crt`, `.key` 일수도 있습니다. 

## 인증서 생성하기

### Certificate Format
https나 다른 tls/ssl 프로토콜을 사용하려하면 라이브러리들이 지원하는 인증서 포맷이 다른경우가 많습니다.

#### pem
.pem 은 Privacy Enhanced Mail를 나타냅니다. base64 로 인코딩된 파일 포맷이라는 의미입니다.

#### key
.key 파일은 private.key, public.key 처럼 key라는 의미를 나타내는 포맷입니다. .key파일은 pem포맷으로 되어있습니다.

#### csr (Certificate Signing Request)
csr은 서버(개인키의 소유자)가 인증기관에게 서비스 및 공개키 정보를 담아 인증서 발급을 요청하는 __인증서 서명 요청__ 문서 입니다. 간단히 CA에게 인증서 발급 요청을 하는 문서입니다. 문서는 `BEGIN CERTIFICATE REQUEST`로 시작해서 `END CERTIFICATE REQUEST` 로 끝이 납니다.
```
-----BEGIN CERTIFICATE REQUEST-----
...
-----END CERTIFICATE REQUEST-----
```

#### crt (Certificate)
전자 인증서입니다. 서버로부터 받은 csr로부터 인증기관은 crt를 생성합니다. 사설인증서나 self-signed-ceritficate 처럼 스스로 생성할 수 도 있습니다. `pem` 포맷으로 `.crt` 라는 확장자로 사용됩니다. 문서는 `BEGIN CERTIFICATE` 로 시작해서 `END CERTIFICATE` 로 끝이 납니다.
```
-----BEGIN CERTIFICATE-----
...
-----END CERTIFICATE-----.
```



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


### 확인하기
https://www.sslshopper.com/certificate-key-matcher.html

## Hash

[참고#1](https://www.suse.com/support/kb/doc/?id=000018152)
[참고#2](https://opentutorials.org/course/2z28/4894)

https://www.cloudflare.com/ko-kr/learning/ssl/how-does-ssl-work/