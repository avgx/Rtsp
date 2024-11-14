import XCTest
@testable import Rtsp

final class RtspTests: XCTestCase {
    func testDemo() async throws {
        
        let rtsp = RtspClient()
        //check that rtsp port in opened and answers
        try await rtsp.check(url: "rtsp://136.243.144.109:554/-")
        //get SPS / PPS
        let sdp1 = try await rtsp.check(url: "rtsp://root:root@136.243.144.109:554/hosts/DEMOSERVER/DeviceIpint.1/SourceEndpoint.video:0:1", describe: true)
        print(sdp1)
//        v=0
//        o=- 7585904709114874142 1 IN IP4 136.243.144.109
//        s=Session streamed with GStreamer
//        i=rtsp-server
//        t=0 0
//        a=tool:GStreamer
//        a=type:broadcast
//        a=control:*
//        a=range:npt=now-
//        m=video 0 RTP/AVP 96
//        c=IN IP4 0.0.0.0
//        a=rtpmap:96 H264/90000
//        a=framerate:20
//        a=fmtp:96 packetization-mode=1;profile-level-id=640016;sprop-parameter-sets=Z2QAFqy0BQF/y4C3AgIFpQAAAwABAAADACgPFi6g,aO4yyLA=
//        a=control:stream=0
//        a=ts-refclk:local
//        a=mediaclk:sender
        let sdp2 = try await rtsp.check(url: "rtsp://1:1@192.168.1.102:554/1", describe: true)
        print(sdp2)
//        v=0
//        o=- 1731578881378808 1 IN IP4 192.168.1.102
//        s=LIVE555 Streaming Media v2017.09.12
//        i=1?
//        t=0 0
//        a=tool:LIVE555 Streaming Media v2017.09.12
//        a=type:broadcast
//        a=control:*
//        a=range:npt=0-
//        a=x-qt-text-nam:LIVE555 Streaming Media v2017.09.12
//        a=x-qt-text-inf:1?
//        m=video 0 RTP/AVP 96
//        c=IN IP4 0.0.0.0
//        b=AS:0
//        a=rtpmap:96 H264/90000
//        a=fmtp:96 packetization-mode=1;profile-level-id=428028;sprop-parameter-sets=J0KAKNoB4AiXlQ==,KM48gA==
//        a=control:track1
//        a=x-onvif-track:1.v
//        m=text 0 RTP/AVP 97
//        c=IN IP4 0.0.0.0
//        b=AS:48
//        a=rtpmap:97 T140/1000
//        a=label:Subtitles
//        a=lang:Subtitles
//        a=control:track2
//        m=text 0 RTP/AVP 98
//        c=IN IP4 0.0.0.0
//        b=AS:48
//        a=rtpmap:98 T140/90000
//        a=label:Timestamps
//        a=lang:Timestamps
//        a=control:track3
    }
}


