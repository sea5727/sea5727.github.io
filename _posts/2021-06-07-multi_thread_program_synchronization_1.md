---
layout: archive
title: "multi-thread program synchronization #1"
date: 2021-05-13 01:32:12 +0900
categories: cs 
tag:
- computer_science
blog: true
author: ysh
description: 
comments: true
---

멀티 스레드로 프로그램을 설계하면서 가장 조심해야 할부분이 바로 동기화 문제입니다.

같은 변수 혹은 메모리를 여러 스레드에서 사용하게 될경우 프로그램은 예상치 못한 동작을 하거나 성능이 나오지 않는 문제가 발생할 수 있습니다.

이런 문제를 해결하기위한 방법은

1. lock-based
2. atomic
3. thread local storage 

정도가 있습니다.

## lock-based
lock은 다음 코드내용을 진행하기위해서는 lock권한을 가지고 있어야만 동작하게합니다. lock을 이미 다른스레드가 점유한다면 그 스레드는 block이 발생하고, wait 상태가 됩니다. 따라서 처리가 끝나 lock점유를 해제하기 전까지 다른스레드들의 접근을 막아 동기화 할 수 있습니다.
( 락의 구현마다 다를 수 있습니다. )

## atomic
atomic은 특정 메모리에 대한 특정한 처리를 여러 스텝의 명령어로 처리하는것이 아닌, 하나의 명령으로만 처리하도록 하드웨어가 지원해주는 방법입니다. 따라서 중간에 다른 스레드가 해당 메모리로 개입할 여지가 없어 메모리의 값들을 동기화 할 수 있습니다.


## thread-local-storage
thread-local-storage 는 스레드자신만 사용할 수 있는 데이터를 사용하는 기법인데 스레드간 동기화와는 크게 중요한 개념이라 생각하지 않습니다. 
사실 전역변수나 메모리를 사용할 때에도 스레드 별 인덱스를 사용한다거나, 논리적으로도 충분히 구별할 수 있다고 생각합니다.



[synchronized-2]