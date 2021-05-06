``` sdp
{"janus":"message","body":{"audio":true,"video":true},"transaction":"mo2EqfHcYv5f",
"jsep":
    {"type":"offer",
    "sdp":
    "v=0\r\n
    o=- 5141528695476738228 2 IN IP4 127.0.0.1\r\n
    s=-\r\n
    t=0 0\r\n
    a=group:BUNDLE 0 1 2\r\n
    a=extmap-allow-mixed\r\n
    a=msid-semantic: WMS Sp8O8XFTsuxSkhdNFgfrwkeVs2A58H6Ih9tP\r\n
    m=audio 9 UDP/TLS/RTP/SAVPF 111 103 104 9 0 8 106 105 13 110 112 113 126\r\n
    c=IN IP4 0.0.0.0\r\n
    a=rtcp:9 IN IP4 0.0.0.0\r\n
    a=ice-ufrag:DGjk\r\n
    a=ice-pwd:rjg1c+acM0KX3vkTfFv+ebn2\r\n
    a=ice-options:trickle\r\n
    a=fingerprint:sha-256 27:5F:49:D7:60:AB:C5:AE:32:2E:DF:6D:C9:C7:C8:70:1E:DA:BA:CC:5D:46:DE:88:AA:36:2D:90:E6:5C:1C:44\r\n
    a=setup:actpass\r\n
    a=mid:0\r\n
    a=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level\r\n
    a=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time\r\n
    a=extmap:3 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01\r\n
    a=extmap:4 urn:ietf:params:rtp-hdrext:sdes:mid\r\n
    a=extmap:5 urn:ietf:params:rtp-hdrext:sdes:rtp-stream-id\r\n
    a=extmap:6 urn:ietf:params:rtp-hdrext:sdes:repaired-rtp-stream-id\r\n
    a=sendrecv\r\n
    a=msid:Sp8O8XFTsuxSkhdNFgfrwkeVs2A58H6Ih9tP 8e15d19c-55be-4d17-b404-e57bddcceeac\r\n
    a=rtcp-mux\r\n
    a=rtpmap:111 opus/48000/2\r\n
    a=rtcp-fb:111 transport-cc\r\n
    a=fmtp:111 minptime=10;useinbandfec=1\r\n
    a=rtpmap:103 ISAC/16000\r\n
    a=rtpmap:104 ISAC/32000\r\n
    a=rtpmap:9 G722/8000\r\n
    a=rtpmap:0 PCMU/8000\r\n
    a=rtpmap:8 PCMA/8000\r\n
    a=rtpmap:106 CN/32000\r\n
    a=rtpmap:105 CN/16000\r\n
    a=rtpmap:13 CN/8000\r\n
    a=rtpmap:110 telephone-event/48000\r\n
    a=rtpmap:112 telephone-event/32000\r\n
    a=rtpmap:113 telephone-event/16000\r\n
    a=rtpmap:126 telephone-event/8000\r\na=ssrc:2482317383 cname:uumzBZarB06uOYim\r\n
    a=ssrc:2482317383 msid:Sp8O8XFTsuxSkhdNFgfrwkeVs2A58H6Ih9tP 8e15d19c-55be-4d17-b404-e57bddcceeac\r\n
    a=ssrc:2482317383 mslabel:Sp8O8XFTsuxSkhdNFgfrwkeVs2A58H6Ih9tP\r\n
    a=ssrc:2482317383 label:8e15d19c-55be-4d17-b404-e57bddcceeac\r\n
    m=video 9 UDP/TLS/RTP/SAVPF 96 97 98 99 100 101 102 121 127\r\nc=IN IP4 0.0.0.0\r\n
    a=rtcp:9 IN IP4 0.0.0.0\r\n
    a=ice-ufrag:DGjk\r\n
    a=ice-pwd:rjg1c+acM0KX3vkTfFv+ebn2\r\n
    a=ice-options:trickle\r\n
    a=fingerprint:sha-256 27:5F:49:D7:60:AB:C5:AE:32:2E:DF:6D:C9:C7:C8:70:1E:DA:BA:CC:5D:46:DE:88:AA:36:2D:90:E6:5C:1C:44\r\n
    a=setup:actpass\r\n
    a=mid:1\r\n
    a=extmap:14 urn:ietf:params:rtp-hdrext:toffset\r\n
    a=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time\r\n
    a=extmap:13 urn:3gpp:video-orientation\r\n
    a=extmap:3 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01\r\n
    a=extmap:12 http://www.webrtc.org/experiments/rtp-hdrext/playout-delay\r\n
    a=extmap:11 http://www.webrtc.org/experiments/rtp-hdrext/video-content-type\r\n
    a=extmap:7 http://www.webrtc.org/experiments/rtp-hdrext/video-timing\r\n
    a=extmap:8 http://www.webrtc.org/experiments/rtp-hdrext/color-space\r\n
    a=extmap:4 urn:ietf:params:rtp-hdrext:sdes:mid\r\n
    a=extmap:5 urn:ietf:params:rtp-hdrext:sdes:rtp-stream-id\r\n
    a=extmap:6 urn:ietf:params:rtp-hdrext:sdes:repaired-rtp-stream-id\r\n
    a=sendrecv\r\n
    a=msid:Sp8O8XFTsuxSkhdNFgfrwkeVs2A58H6Ih9tP 37aed9fb-8874-42d1-86e6-fc3c9f406790\r\n
    a=rtcp-mux\r\n
    a=rtcp-rsize\r\n
    a=rtpmap:96 VP8/90000\r\n
    a=rtcp-fb:96 goog-remb\r\n
    a=rtcp-fb:96 transport-cc\r\n
    a=rtcp-fb:96 ccm fir\r\n
    a=rtcp-fb:96 nack\r\n
    a=rtcp-fb:96 nack pli\r\n
    a=rtpmap:97 rtx/90000\r\n
    a=fmtp:97 apt=96\r\n
    a=rtpmap:98 VP9/90000\r\n
    a=rtcp-fb:98 goog-remb\r\n
    a=rtcp-fb:98 transport-cc\r\n
    a=rtcp-fb:98 ccm fir\r\n
    a=rtcp-fb:98 nack\r\n
    a=rtcp-fb:98 nack pli\r\n
    a=fmtp:98 profile-id=0\r\n
    a=rtpmap:99 rtx/90000\r\n
    a=fmtp:99 apt=98\r\n
    a=rtpmap:100 H264/90000\r\n
    a=rtcp-fb:100 goog-remb\r\n
    a=rtcp-fb:100 transport-cc\r\n
    a=rtcp-fb:100 ccm fir\r\n
    a=rtcp-fb:100 nack\r\n
    a=rtcp-fb:100 nack pli\r\n
    a=fmtp:100 level-asymmetry-allowed=1;packetization-mode=1;profile-level-id=42e01f\r\n
    a=rtpmap:101 rtx/90000\r\n
    a=fmtp:101 apt=100\r\n
    a=rtpmap:102 red/90000\r\n
    a=rtpmap:121 rtx/90000\r\n
    a=fmtp:121 apt=102\r\n
    a=rtpmap:127 ulpfec/90000\r\n
    a=ssrc-group:FID 3240337377 816665117\r\n
    a=ssrc:3240337377 cname:uumzBZarB06uOYim\r\n
    a=ssrc:3240337377 msid:Sp8O8XFTsuxSkhdNFgfrwkeVs2A58H6Ih9tP 37aed9fb-8874-42d1-86e6-fc3c9f406790\r\n
    a=ssrc:3240337377 mslabel:Sp8O8XFTsuxSkhdNFgfrwkeVs2A58H6Ih9tP\r\n
    a=ssrc:3240337377 label:37aed9fb-8874-42d1-86e6-fc3c9f406790\r\n
    a=ssrc:816665117 cname:uumzBZarB06uOYim\r\n
    a=ssrc:816665117 msid:Sp8O8XFTsuxSkhdNFgfrwkeVs2A58H6Ih9tP 37aed9fb-8874-42d1-86e6-fc3c9f406790\r\n
    a=ssrc:816665117 mslabel:Sp8O8XFTsuxSkhdNFgfrwkeVs2A58H6Ih9tP\r\n
    a=ssrc:816665117 label:37aed9fb-8874-42d1-86e6-fc3c9f406790\r\n
    m=application 9 UDP/DTLS/SCTP webrtc-datachannel\r\n
    c=IN IP4 0.0.0.0\r\n
    a=ice-ufrag:DGjk\r\n
    a=ice-pwd:rjg1c+acM0KX3vkTfFv+ebn2\r\n
    a=ice-options:trickle\r\n
    a=fingerprint:sha-256 27:5F:49:D7:60:AB:C5:AE:32:2E:DF:6D:C9:C7:C8:70:1E:DA:BA:CC:5D:46:DE:88:AA:36:2D:90:E6:5C:1C:44\r\n
    a=setup:actpass\r\n
    a=mid:2\r\n
    a=sctp-port:5000\r\n
    a=max-message-size:262144\r\n"
    }}
```