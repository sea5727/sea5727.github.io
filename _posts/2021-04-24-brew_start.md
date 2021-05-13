---
layout: archive
title:  "brew 시작하기"
date:   2021-04-24 18:46:09 +0900
categories: summary
tag:
- brew
blog: true
author: ysh
description: brew 설치과정 및 패키지 설치 정리
comments: true
---
macOS 및 linux 패키지 관리 프로그램입니다.   

centos의 yum과 ubuntu의 apt과 다른점은 root계정으로 설치하지 않아도 된다는점.  패키지의 버전별/계정별로 설치가 가능하다는 점이 있습니다.



[Homepage](https://brew.sh/index_ko)



## install

설치법은 Homepage에 자세하게 나와있습니다.

설치시 입력한 커맨드만 정리해보았습니다. 



```
먼저 curl, git 등이 설치되어 있어야 합니다. 
$ sudo apt install curl git
... 설치 완료
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
... 설치 중
... 설치 완료
... 설치를 완료하고 안내 문구를 잘 읽어보면 아래 경로를 설정라하고 안내해줍니다. 복사하여 입력합니다
$ echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/ysh8361/.bash_profile
$ eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

... 설치 완료후 안내 문구에서 brew install gcc 를 추천하고 있습니다.
$ brew install hello
$ hello
Hello, world!

$ echo $HOMEBREW_PREFIX
/home/linuxbrew/.linuxbrew
$ echo $HOMEBREW_CELLAR
/home/linuxbrew/.linuxbrew/Cellar
$ echo $HOMEBREW_REPOSITORY
/home/linuxbrew/.linuxbrew/Homebrew
```

### GCC 설치

brew로 gcc 설치

```
brew install gcc
... 설치 완료
ls /home/linuxbrew/.linuxbrew/bin
gcc-10 ... 기타등등 설치 내용 확인

.profile 에 아래 내용 추가
alias gcc='gcc-10'
alias cc='gcc-10'
alias g++='g++-10'
alias c++='c++-10'
alias cpp='cpp-10'
```



### 



```

```



