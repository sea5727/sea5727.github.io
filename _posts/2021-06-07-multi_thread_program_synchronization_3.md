---
layout: archive
title: "multi-thread program synchronization #3"
date: 2021-05-13 01:32:12 +0900
categories: cs 
tag:
- computer_science
blog: true
author: ysh
description: 
comments: true
---


## atomic
atomic은 명령어 단위의 원자성을 보장합니다. 

`lock` 은 멀티스레드환경에서 상호배제를 보장하기 위해 코드구역에서 임계영역을 구분해주었습니다. 하지만 `atomic` 은 명령어 처리 단위를 최소단위(원자단위?) 로 하여 스레들간의 메모리 접근을 막을수 있습니다.

일반적으로 메모리에 값을 쓰거나 변경하는 동작은 대부분 `load-modify-store` 의 순서로 이루어지며 이들은 모두 여러 스텝의 명령어 단위의 처리를 거쳐 동작합니다. 즉 스레드에서 `load`를 한 메모리를 `modify-store` 까지 진행하기도 전에 다른스레드에서 `load`하는것을 막을 수 있습니다.

이렇게만보면 `atomic`은 `mutex` 보다도 빠를것같고 좋아보이지만 한계점이 있습니다.
1. cpu가 한번에 처리할수 있는 크기보다 적은 크기의 타입만 `atomic`으로 선언할 수 있습니다.
한번의 연산으로만 처리하기때문에 한번 처리할수있는 메모리크기만큼보다 같거나 작아야지만 atomic 변수로 지정할 수 있습니다.
2. 캐시메모리의 정보를 메인 메모리에 적재합니다.
`atomic`변수에 수정이 있을때마다 메인 메모리에도 반영을 합니다. 따라서 필요한경우에 사용해야만 성능에 영향이 없을것입니다.

