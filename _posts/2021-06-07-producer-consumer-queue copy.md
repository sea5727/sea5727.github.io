---
layout: archive
title: "d"
date: 2021-05-13 01:32:12 +0900
categories: cs 
tag:
- computer_science
blog: true
author: ysh
description: 
comments: true
---

`Producer-Consumer Queue` 는 `concurrent system`의 가장 기본적인 컴퍼넌트입니다. 

producer와 consumer 수에 따라 구분하면

-   MPMC : Multi-Producer/Multi-Consumer Queue 
-   SPMC : Sigle-Producer/Multi-Consumer Queue 
-   MPSC : Multi-Producer/Sigle-Consumer Queue 
-   SPSC : Sigle-Producer/Sigle-Consumer Queue 

만약 하나의 producer와 하나의 consumer를 사용한다면 SPSC queue를 사용해야 할것입니다.

데이터 구조에 따라 구분하면
- Array-Based
- Linked-List-Based
- Hybrid

Array-Based queue는 아주 빠르지만, 명확하게는 Lockfree가 아닙니다. 단점으로는 최악의경우 미리 메모리를 할당해야 한다는점입니다. Linked-List-Based queue는 미리 메모리를 할당할 필요는 없습니다. Hybrid는 두 구조의 장점을 섞어 사용합니다.

Linked-List Based queues는 아래로 나눌 수 있습니다.
- Intrusive Linked-List 
- Non-Instrusive Linked-List 

Non-Instrusive Linked-List는 데이터값과 다음노드요소가 함께 포함되어 있습니다.
[Linked-List](https://www.data-structures-in-practice.com/linked-lists/)
Instrusive Linked-List는 데이터를 다시 link하는 구조입니다. 
[Instrusive Linked-List](https://www.data-structures-in-practice.com/intrusive-linked-lists/)

Instrusive Linkst-List는 이미 메모리할당된 데이터를 전달하는것이 성능에 좋습니다. 하지만 데이터가 동적할당이 아니거나, 같은 데이터를 여러번 전달해야할 때 적용할 수 없습니다.


Linked-List를 크기로 구분한다면 아래로 나눌 수 있습니다.
- Bounded
- Unbounded 

Unbounded queue는 크기가 제한되지 않은 무한한 수의 메시지를 보유할 수 있습니다. 시스템의 한계까지 다다르면 euqueue 작업이 실패가 발생합니다. Unbounded queue가 더 매력적으로 보이지만, 메시지의 수가 무한히 증가하는것을 조심하는 수 밖에 없습니다. 따라서 강제로 이런일을 막기 위해서는 bounded queue가 필요합니다.

bounded queue를 overflow behavior 로 구분한다면 아래로 나눌수 있습니다.
- Fails on overflow
- Overwrites the oldest item on overflow

대부분의 queue들은 Fails on overflow로 구현되어 있습니다. 왜냐하면 producer-consumer구조에서 consumer가 producer를 따라 갈수 없다면 최신 데이터보다 가장 오래된 데이터를 읽는것이 낫습니다. ? ( 그럼 Overwrites the oldest item on overflow 큐인데..)


가비지 콜랙션에 따라 구분한다면 
- Requires GC
- Dose not required GC

우선순위지원에 따라 구분한다면
- with surpport for message priorities
- without support for message priorities
우선순위 큐는 대기열을 재정렬 하여 consumer가 항상 우선순위의 데이터를 받도록 합니다. 일반적으로 더 느리고 스케일이 적습니다.

https://www.1024cores.net/home/lock-free-algorithms/queues

https://www.1024cores.net/home/lock-free-algorithms/queues/bounded-mpmc-queue

https://www.1024cores.net/home/lock-free-algorithms/introduction
