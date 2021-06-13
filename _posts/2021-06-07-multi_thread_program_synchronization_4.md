---
layout: archive
title: "multi-thread program synchronization #4"
date: 2021-05-13 01:32:12 +0900
categories: cs 
tag:
- computer_science
blog: true
author: ysh
description: 
comments: true
---

## 용어 정리

## 동시성(Concurrency)
동시에 실행 되는것 처럼 보이는것. 싱글 코어에서 멀티 스레드를 실행시키는 것입니다. `context switch` 를 통해 스레드들간에 스케쥴링을 하여 동시에 실행되는것처럼 보입니다. 논리적인 개념입니다.

## 병렬성(Parallelism)
실제로 여러작업이 동시에 실행됩니다. 멀티 코어에서 멀티스레드를 동작시키는 것입니다. 실제로 각각의 코어에서 각각의 스레드를 동시에 실행시키는 것입니다. 물리적인 개념입니다.

## cpu
cpu란 `central processing unit` 으로 중앙 처리 장치입니다.

## core
명령어를 처리하는 장치입니다. cpu는 단일코어 또는 멀티코어를 가질 수 있습니다.

## thread
하나의 core는 하나의 thread를 가집니다. hyper-threading 과 같은 기술이 발전하여 하나의 코어에서 여러 thread를 실행할 수 있습니다.


## false sharing
멀티코어 환경에서 발생할 수 있습니다. 각각의 코어가 가지고 있는 cache 데이터 중에 주소가 겹치는 영역에 대해 어느 한쪽이 업데이트가 발생하면, 다른 한쪽도 반영해주는 하드웨어 기능으로 인해 발생하는 지연현상입니다.

## word
싱글코어 환경 cpu가 cache를 읽어오는 단위입니다. ( 32bit 또는 64bit )

## cacheline
멀티코어 환경에서 메모리 I/O 효율성을 위해 cache에 저장하는 단위입니다. (64 bytes)

리눅스환경에서는 cacheline을 아래 명령어로 확인할 수 있습니다.
```
$ getconf LEVEL1_DCACHE_LINESIZE
64
```



## 예제

캐시와 메모리 관련 예제

## cache hitrate #1

[어느 블로그](https://blog.naver.com/hermet/68290454)에서 예제 코드를 가져왔습니다.
그리고 전체 소스코드는 [링크] 에서 볼수 있습니다.
``` cpp
#define SIZE 10000
int temp[SIZE][SIZE];

void func1() {
    for(int i = 0 ; i < SIZE ; i++) {
        for(int j = 0 ; j < SIZE; j++) {
            temp[i][j] = i * j;
        }
    }
}

void func2() {
    for(int i = 0 ; i < SIZE ; i++) {
        for(int j = 0 ; j < SIZE ; j++) {
            temp[j][i] = i * j;
        }
    }
}

...

0.402862
--------------------
1.0145
--------------------
why func1 faster than func2
```
위 코드는 반복문을 통해서 array에 값을 대입하고 있습니다. 
`func1` 은 temp 배열에 순차적으로 값을 저장하지만, `func2` 는 temp 배열의 `SIZE` 만큼 점프를 하여 저장하고 있습니다. `Cacheline` 크기인 64바이트 보다 큰 값으로 점프를 하기 때문에 값을 저장할 때마다 새롭게 메모리에서 cache로 값을 읽어드려야 합니다. 따라서 `func1`이 `func2`보다 빠르며 이유는 cache hitrate(캐시 히트율) 이 func1이 func2보다 높기때문입니다.

## false sharing 1

[어느 블로그](https://blog.naver.com/hermet/68290454)에서 예제 코드를 가져왔습니다.
그리고 전체 소스코드는 [링크] 에서 볼수 있습니다.
``` cpp
#define SIZE 100000000
constexpr int idx = SIZE - 1;

int a[SIZE];
int b[SIZE];

void func1_th1() {
    for(int i = 0 ; i < SIZE; i++)
        a[idx] = i;
}

void func1_th2() {
    for(int i = 0 ; i < SIZE; i++){
        b[0] = i;
    }
}
void func2_th1() {
    for(int i = 0 ; i < SIZE; i++)
        a[0] = i;
}

void func2_th2() {
    for(int i = 0 ; i < SIZE; i++){
        b[0] = i;
    }
}
...

0.405329
--------------------
0.264316
--------------------
why func2 faster than func1
```
위 코드는 배열 a와 배열 b의 값을 저장하는 스레드가 있습니다. 
첫번째 테스트는 배열 a의 끝에 가까운 값과 b의 첫번째값에 값을 쓰는 동작을 합니다.   
두번째 테스트는 배열 a의 첫번째값과 b의 첫번째 값에 값을 쓰는 동작을 합니다.   
첫번째 테스느는 `cachline`만큼 가까운 위치에 있고, 두번째 테스트 충분히 먼 상태입니다.
결과는 두번째 테스트의 성능이 더 좋았습니다. 왜냐하면 첫번째 테스트는 a값 또는 b값을 쓰는 스레드에서 쓰기동작을 하면, 다른 코어쪽에서도 값을 맞추어 주는 동작을 하기 때문에 하드웨어적으로 좀더 지연이 생기지만, 두번째 테스트는 그렇지 않습니다.

이 현상이 false sharing 입니다.

## false sharing solution 1
그리고 전체 소스코드는 [링크] 에서 볼수 있습니다.
false sharing을 해소하기 위한 솔루션으로는 cacheline만큼 padding 바이트를 추가하는것입니다.
```
typedef char Cacheline[64];
#define SIZE 100000000
constexpr int idx = SIZE - 1;

int a[SIZE];
Cacheline line;
int b[SIZE];

...

0.274132
--------------------
0.27497
--------------------
same same
```
결과를 보면 실행 시간이 거의 같아 졌습니다.




https://rein.kr/blog/archives/906#footnote_2_906
https://blog.naver.com/hermet/68290454
https://seamless.tistory.com/42
