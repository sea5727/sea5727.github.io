---
layout: archive
title: "youtube-dl 시작하기!"
date: 2021-04-25 01:21:00 +0900
categories: summary
tag:
- youtube-dl
blog: true
author: ysh
description: youtube-dl 설치과정 및 실행방법 정리
comments: true
---

## youtube-dl
커맨드 라인으로 유튜브 영상을 다운받을 수 있는 프로그램 입니다. 오픈소스로 무료로 사용가능하며 다양한 기능이 있어 많이 사용되고 있습니다. 유튜브 영상 하나를 다운로드 받거나, playlist를 모두 다운로드하거나, 특정 포맷의 영상을 다운로드 받는등 다양한 기능이 가능합니다.


### install
```
python -m pip install --upgrade pip
python -m pip install youtube-dl
python -m pip install -U youtube-dl
```


### Usage

#### 영상 하나 다운로드
```
youtube-dl <Youtube-URL>
```

#### playlist 다운로드
유튜브 영상을 "재생목록만들기" 또는 "나중에 볼 동영상" 등으로 저장한 playlist를 "공개"형식으로 설정 해놓은 경우 youtube-dl로 동영상 리스트를 다운받을 수 있습니다.
[Youtube 재생목록 만들기 및 관리](https://support.google.com/youtube/answer/57792?co=GENIE.Platform%3DDesktop&hl=ko)

- 폴더를 지정하여 번호를 매기는 포맷으로 다운로드
```
youtube-dl -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' <Youtube-URL>
```

- 업로더/날짜/제목 포맷으로 다운로드
```
youtube-dl -o '%(uploader)s/%(date)s/%(title)s.%(ext)s' <Youtube-URL>
```

- list 파일로 다운로드
```
youtube-dl -a lists.txt
```

#### 영상 포맷 지정하여 다운받기

- youtube Format 확인하기
```
youtube-dl --list-formats <Youtube-URL>

결과 : 
[info] Available formats for oCkAUDJKa10:
format code  extension  resolution note
249          webm       audio only tiny   52k , webm_dash container, opus @ 52k (48000Hz), 906.14KiB
250          webm       audio only tiny   65k , webm_dash container, opus @ 65k (48000Hz), 1.11MiB
251          webm       audio only tiny  117k , webm_dash container, opus @117k (48000Hz), 1.98MiB
140          m4a        audio only tiny  129k , m4a_dash container, mp4a.40.2@129k (44100Hz), 2.18MiB
394          mp4        256x144    144p   59k , mp4_dash container, av01.0.00M.08@  59k, 24fps, video only, 1.00MiB
160          mp4        256x144    144p   62k , mp4_dash container, avc1.4d400c@  62k, 24fps, video only, 1.06MiB
278          webm       256x144    144p   74k , webm_dash container, vp9@  74k, 24fps, video only, 1.25MiB
133          mp4        426x240    240p   92k , mp4_dash container, avc1.4d4015@  92k, 24fps, video only, 1.55MiB
395          mp4        426x240    240p  100k , mp4_dash container, av01.0.00M.08@ 100k, 24fps, video only, 1.69MiB
242          webm       426x240    240p  141k , webm_dash container, vp9@ 141k, 24fps, video only, 2.38MiB
134          mp4        640x360    360p  155k , mp4_dash container, avc1.4d401e@ 155k, 24fps, video only, 2.61MiB
396          mp4        640x360    360p  175k , mp4_dash container, av01.0.01M.08@ 175k, 24fps, video only, 2.96MiB
243          webm       640x360    360p  237k , webm_dash container, vp9@ 237k, 24fps, video only, 4.00MiB
135          mp4        854x480    480p  220k , mp4_dash container, avc1.4d401e@ 220k, 24fps, video only, 3.70MiB
397          mp4        854x480    480p  283k , mp4_dash container, av01.0.04M.08@ 283k, 24fps, video only, 4.77MiB
244          webm       854x480    480p  388k , webm_dash container, vp9@ 388k, 24fps, video only, 6.52MiB
136          mp4        1280x720   720p  318k , mp4_dash container, avc1.4d401f@ 318k, 24fps, video only, 5.35MiB
398          mp4        1280x720   720p  536k , mp4_dash container, av01.0.05M.08@ 536k, 24fps, video only, 9.02MiB
247          webm       1280x720   720p  721k , webm_dash container, vp9@ 721k, 24fps, video only, 12.13MiB
18           mp4        640x360    360p  362k , avc1.42001E, 24fps, mp4a.40.2 (44100Hz), 6.10MiB
22           mp4        1280x720   720p  447k , avc1.64001F, 24fps, mp4a.40.2 (44100Hz) (best)
```

- 영상 포맷 지정하여 다운로드하기
```
youtube-dl -f 249 <Youtube-URL>
```
