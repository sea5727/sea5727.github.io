---
layout: archive
title: "pyenv 시작하기"
date: 2021-05-25 00:46:09 +0900
categories: summary
tag:
- pyenv
blog: true
author: ysh
description: pyenv 설치과정 정리
sidebar:
  nav: "posts_navi"
---

## pyenv
pyenv는 python 버전을 분리 관리하는 프로그램입니다. 예를들어 `python2.7`, `3.6`, `3.7` 버전에서 코드를 실행해야한다면 pyenv로 개별 버전들을 설치후 사용할 수 있습니다. python3버전에 내장되어있는 `venv` 는 python2를 사용하지 못하는점이 있지만 `pyenv`는 모든버전을 관리할 수 있다는 장점이 있습니다.

## virtualenv
virtualenv 는 pyenv와 함께 사용되는 플러그인으로 여러 버전을 pyenv로 설치된 python 버전들을 파이썬 가상환경으로 실행시켜줍니다.


## install
root가 아닌 각 계정별로 설치되어야 합니다. $HOME 경로에 .pyenv 폴더에 설치됩니다. 

```
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
```

## usage

사용방법 아래입니다. 
### 0. version check
```
pyenv --version
```

### 1. pyenv update latest version
```
pyenv update
```

### 2. install python version
```
pyenv install <version>
```

### 3. check installed python version
```
pyenv versions
```

### 4. make virtual environment
```
pyenv virtualenv <version> <name>
```

### 5. run activate
```
pyenv activate <name>
```

### 6. example
```
$ pyenv update
$ pyenv install 3.7.5
$ pyenv virtualenv 3.7.5 project1
$ pyenv activate project1
...
$ pyenv deactivate 
```