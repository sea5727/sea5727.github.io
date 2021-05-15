---
layout: archive
title: "[Error] this statement may fall through [-Werror=implicit-fallthrough=]"
date: 2021-05-13 01:32:12 +0900
categories: c-cpp
tag:
- c-cpp
blog: true
author: ysh
description: 
comments: true
---


`nginx 1.20.0` 버전을 빌드하는 중 컴파일 오류가 발생하였습니다.
`gcc`는 `gcc-10` 입니다.

## 컴파일 에러 문구
``` 
error: this statement may fall through [-Werror=implicit-fallthrough=]
  160 |                 switch (c) {
      |                 ^~~~~~
/home/ysh8361/pkg/nginx-rtmp-module/ngx_rtmp_eval.c:171:13: note: here
  171 |             case ESCAPE:
```

## 해결법
`-Wno-implicit-fallthrough` 옵션 추가

## 예
```
g++ -std=c++17 -Wimplicit-fallthrough main.cpp
```


## 추가 내용
switch문 내부에 case 간 break; 가 누락이 되어있는 오류입니다. 

case간 break누락을 의도적으로 사용한것이라면 컴파일을 할수있도록 `-Wno-implicit-fallthrough` 옵션을 추가합니다.
```
gcc ... -Wno-implicit-fallthrough ...
```

case간 break누락 검사를 필수로 하려면 `-Wimplicit-fallthrough` 옵션을 추가하세요.

```
g++ -std=c++17 -Wimplicit-fallthrough main.cpp
```

c++17에서는 `[[fallthrough]]`로 컴파일 오류를 피해갈 수 있습니다.
``` c++
int main(int argc, char **argv) {
    switch (argc) {
        case 0:
            argc = 1;
            [[fallthrough]];
        case 1:
            argc = 2;
    };
}
```
또는 
``` c
switch (cond)
 {
 case 1:
   bar (1);
   __attribute__ ((fallthrough)); // C and C++03
 case 2:
   bar (2);
   [[gnu::fallthrough]]; // C++11 and C++14
 case 3:
   bar (3);
   [[fallthrough]]; // C++17 and above
 /* ... */
 }
```

## Reference 
https://stackoverflow.com/questions/45129741/gcc-7-wimplicit-fallthrough-warnings-and-portable-way-to-clear-them
https://developers.redhat.com/blog/2017/03/10/wimplicit-fallthrough-in-gcc-7/