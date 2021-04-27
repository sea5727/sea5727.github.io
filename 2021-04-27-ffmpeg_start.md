---
layout: archive
title: "ffmpeg  시작하기"
date: 2021-04-26 17:02:40 +0900
categories: summary ffmpeg
tag:
- ffmpeg
blog: true
author: ysh
description: 
sidebar:
  nav: "posts_navi"
---

This example will create a 10 second output, 30 fps (300 frames total), with a frame size of 640x360 (testsrc.mpg):
```
ffmpeg -f lavfi -i testsrc=duration=10:size=1280x720:rate=30 testsrc.mpg
```


The following command will generate a video with a duration of 5.3 seconds, with size 176x144 and a frame rate of 10 frames per second.
```
ffmpeg -f lavfi -i testsrc=duration=5.3:size=qcif:rate=10 testsrc2.mp4
```

```
ffmpeg -f lavfi -i smptebars=duration=10:size=640x360:rate=30 smptebars.mp4
```


```
ffmpeg -f lavfi -i color=c=red@0.2:duration=5:s=qcif:r=10 colorsrc.mp4
```

```
ffmpeg -f lavfi -i rgbtestsrc -pix_fmt yuv420p -t 5 rgbtestsrc.mp4
```

```
ffmpeg [global_options] { [input_options] -i input_url } { [output_options] output_url }
```

```
ffmpeg -re -i video.mp4 -an -c:v copy -f rtp -sdp_file video.sdp rtp://192.168.1.109:5004
```

```
ffmpeg -fflags +genpts -i files\2005-SFSD-sample-mpeg1.mpg  -an -threads 0 -r 10 -g 45 -s 352x240 -deinterlace -f rtp rtp://192.168.200.198:9008 > config.sdp
```
[testsrc](https://www.bogotobogo.com/FFMpeg/ffmpeg_video_test_patterns_src.php)
[rtp-streaming](https://www.kurento.org/blog/rtp-ii-streaming-ffmpeg)
[cheat-sheet](https://github.com/beyondszine/ffmpeg-cheatsheet)

[cheat-sheet#2](https://devhints.io/ffmpeg)

[tt](https://fftrac-bg.ffmpeg.org/wiki/StreamingGuide)

[ffmpeg-protocol](https://ffmpeg.org/ffmpeg-protocols.html#rtp)

https://superuser.com/questions/516806/how-to-encode-audio-with-opus-codec

https://github.com/pczech/docs/blob/master/ffmpeg.txt


ffmpeg -f lavfi -re -i aevalsrc="sin(400*2*PI*t)" -ar 8000 -c:a libopus -b:a 48000 -f rtp -payload_type 111 rtp://127.0.0.1:5002; 
ffmpeg -f lavfi -re -i testsrc=size=640x360:rate=30 -c:v vp8 -f rtp -payload_type 112 rtp://127.0.0.1:5004;