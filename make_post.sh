#!/bin/sh

desc='
---
layout: posts
title:  "brew 시작하기"
date:   2021-04-24 18:46:09 +0900
categories: summary
tag:
- brew
blog: true
author: ysh
description: brew 설치과정 및 패키지 설치 정리
sidebar:
  nav: "posts_navi"
---'

name=$1
datefmt=$(date "+%Y-%m-%d %H:%M:%S")
titlefmt=$(date "+%Y-%m-%d")

echo $name
echo $date

echo "---
layout: posts
title: 
date: $datefmt +0900
categories: 
tag:
- brew
blog: true
author: ysh
description: 
sidebar:
  nav: \"posts_navi\"
---" > "${titlefmt}-${name}.md"