---
layout: archive
title: "vscode c/c++ c_cpp_properties"
date: 2021-05-13 01:32:12 +0900
categories: c-cpp
tag:
- c-cpp
blog: true
author: ysh
description: 
comments: true
---

c/c++ 개발 에디터로 vscode를 사용하는데, include 관련 설정을 해주지 않으면 코드에서 에러라인이 표시됩니다. 
이때 설정해주는 설정값으로 `c_cpp_properties.json` 설정파일이 있습니다.
## extension install
1. c/c++ extension install
2. c++ Intellisense install


## configuration
`Ctrl + P` 단축키 이후 `C/C++: Edit Configurations (JSON)`을 선택합니다. 

`.vscode` 폴더에 `c_cpp_properties.json` 파일이 생성됩니다.

`c_cpp_properties` 설정은 `build` 과정에 전혀 영향을 주지 않으며, 단지 화면에서 `include path` 나 `error`같은 부분을 체크해주는 설정입니다.

## c_cpp_properties.json
``` json
{
    "configurations": [
        {
            "name": "Linux",
            "includePath": [
                "${workspaceFolder}/**"
            ],
            "defines": [],
            "compilerPath": "/usr/bin/gcc",
            "cStandard": "gnu17",
            "cppStandard": "gnu++17",
            "intelliSenseMode": "linux-gcc-x64",
            "configurationProvider": "ms-vscode.cmake-tools"
        }
    ],
    "version": 4
}
```


설정 파라미터는 `C/C++: Edit Configurations (UI)` 를 선택해서 설정하는것이 편할수 있습니다.

## params
name : 설정의 이름입니다. 리스트형식으로 여러개가 될때 구분값으로 사용됩니다.
includePath : `-I`옵션에 해당하는 설정값입니다.
defines : `-D` 옵션에 해당하는 설정값입니다.
compilerPath : `gcc`의 `path` 입니다.
cStandard : `.c` 파일의 문법 확인을 위한 버전입니다.
cppStandard : `.cpp` 파일의 문법 확인을 위한 버전입니다.
configurationProvider : 다른 설정값을 사용할때 사용합니다. 예를들어 저는 `cmake`사용하는데 `CMakeLists.txt` 파일에 설정된 값들을 우선적으로 사용하고싶은경우 사용됩니다.

## issue
includePath에 올바른 위치를 입력하였음에도 `include<~~~>` 에서 찾을수 없다는 에러가 표시되었습니다. `configurationProvider`에 `cmake` 로 설정되어있었고, `CMakeLists.txt` 에서 정상적으로 설정하였으나 해결되지 않았습니다.

## solutaion
`vscode extension` 인 `CMake`, `CMake Tools` 를 `reinstall` 하니 해결되었습니다... 👍