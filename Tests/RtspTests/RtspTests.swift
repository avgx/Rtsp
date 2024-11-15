import XCTest
import CoreMedia
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
        let sdp3 = try await rtsp.check(url: "rtsp://1:1@192.168.1.102:554/3", describe: true)  //mjpeg
        print(sdp3)
//        v=0
//        o=- 1731664410657274 1 IN IP4 192.168.1.102
//        s=LIVE555 Streaming Media v2017.09.12
//        i=3?
//        t=0 0
//        a=tool:LIVE555 Streaming Media v2017.09.12
//        a=type:broadcast
//        a=control:*
//        a=range:npt=0-
//        a=x-qt-text-nam:LIVE555 Streaming Media v2017.09.12
//        a=x-qt-text-inf:3?
//        m=video 0 RTP/AVP 26
//        c=IN IP4 0.0.0.0
//        b=AS:0
//        a=control:track1
//        a=x-onvif-track:3.v
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
        let sdp4 = try await rtsp.check(url: "rtsp://1:1@192.168.1.102:554/4", describe: true)  //mpeg4
        print(sdp4)
//        v=0
//        o=- 1731664533010827 1 IN IP4 192.168.1.102
//        s=LIVE555 Streaming Media v2017.09.12
//        i=4?
//        t=0 0
//        a=tool:LIVE555 Streaming Media v2017.09.12
//        a=type:broadcast
//        a=control:*
//        a=range:npt=0-
//        a=x-qt-text-nam:LIVE555 Streaming Media v2017.09.12
//        a=x-qt-text-inf:4?
//        m=video 0 RTP/AVP 96
//        c=IN IP4 0.0.0.0
//        b=AS:0
//        a=rtpmap:96 MP4V-ES/90000
//        a=control:track1
//        a=x-onvif-track:4.v
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
        
        let sdp265 = try await rtsp.check(url: "rtsp://192.168.1.141:554?user=uybe&password=3f3mpn&channel=0&stream=0&onvif=0.sdp&real_stream", describe: true)  //h265
        print(sdp265)
//        v=0
//        o=- 38990265062388 38990265062388 IN IP4 192.168.1.141
//        s=RTSP Session
//        t=0 0
//        a=control:*
//        a=range:npt=0-
//        m=video 0 RTP/AVP 98
//        c=IN IP4 192.168.1.141
//        a=rtpmap:98 H265/90000
//        a=fmtp:98 profile-id=010101;sprop-pps=RAHA88DhRSQ=;sprop-sps=QgEBAWAAAAMAAAMAAAMAAAMAP6ABICACiH+curwS4IA=;sprop-vps=QAEMAf//AWAAAAMAAAMAAAMAAAMAPywMAAAPoAAAu4FA;
//        a=framerate:25
//        a=control:trackID=3
//        m=audio 0 RTP/AVP 8
//        c=IN IP4 192.168.1.141
//        a=rtpmap:8 PCMA/8000
//        a=control:trackID=4
        let sdp265_2 = try await rtsp.check(url: "rtsp://192.168.1.141:554?user=uybe&password=3f3mpn&channel=0&stream=1&onvif=0.sdp&real_stream", describe: true)  //h265
        print(sdp265_2)
//        v=0
//        o=- 38990265062388 38990265062388 IN IP4 192.168.1.141
//        s=RTSP Session
//        t=0 0
//        a=control:*
//        a=range:npt=0-
//        m=video 0 RTP/AVP 98
//        c=IN IP4 192.168.1.141
//        a=rtpmap:98 H265/90000
//        a=fmtp:98 profile-id=010101;sprop-pps=RAHA88DhRSQ=;sprop-sps=QgEBAWAAAAMAAAMAAAMAAAMAP6AFAgC0f5y6vBLggA==;sprop-vps=QAEMAf//AWAAAAMAAAMAAAMAAAMAPywMAAAPoAAAu4FA;
//        a=framerate:25
//        a=control:trackID=3
//        m=audio 0 RTP/AVP 8
//        c=IN IP4 192.168.1.141
//        a=rtpmap:8 PCMA/8000
//        a=control:trackID=4
    }
    
    func testFormatFromSpsPps264() async throws {
        let sps64 = "Z2QAFqy0BQF/y4C3AgIFpQAAAwABAAADACgPFi6g"
        let pps64 = "aO4yyLA="
        
        let sps = Data(base64Encoded: sps64, options: .ignoreUnknownCharacters)!
        let pps = Data(base64Encoded: pps64, options: .ignoreUnknownCharacters)!
        let format264 = try CMVideoFormatDescription(h264ParameterSets: [Data(sps), Data(pps)])
        print(format264)
        XCTAssertEqual(format264.dimensions.width, 640)
        XCTAssertEqual(format264.dimensions.height, 360)
    }
    
    func testFormatFromSpsPps264_2() async throws {
        let sps64 = "J0KAKNoB4AiXlQ=="
        let pps64 = "KM48gA=="
        
        let sps = Data(base64Encoded: sps64, options: .ignoreUnknownCharacters)!
        let pps = Data(base64Encoded: pps64, options: .ignoreUnknownCharacters)!
        let format264 = try CMVideoFormatDescription(h264ParameterSets: [Data(sps), Data(pps)])
        print(format264)
        XCTAssertEqual(format264.dimensions.width, 1920)
        XCTAssertEqual(format264.dimensions.height, 1080)
    }
    
    func testFormatFromSpsPps265() async throws {
        let vps64 = "QAEMAf//AWAAAAMAAAMAAAMAAAMAPywMAAAPoAAAu4FA"
        let sps64 = "QgEBAWAAAAMAAAMAAAMAAAMAP6ABICACiH+curwS4IA="
        let pps64 = "RAHA88DhRSQ="
        
        let vps = Data(base64Encoded: vps64, options: .ignoreUnknownCharacters)!
        let sps = Data(base64Encoded: sps64, options: .ignoreUnknownCharacters)!
        let pps = Data(base64Encoded: pps64, options: .ignoreUnknownCharacters)!
        let format265 = try CMVideoFormatDescription(hevcParameterSets: [Data(vps), Data(sps), Data(pps)])
        print(format265)
        XCTAssertEqual(format265.dimensions.width, 2304)
        XCTAssertEqual(format265.dimensions.height, 2592)
    }
    
    func testFormatFromSpsPps265_2() async throws {
        let vps64 = "QAEMAf//AWAAAAMAAAMAAAMAAAMAPywMAAAPoAAAu4FA"
        let sps64 = "QgEBAWAAAAMAAAMAAAMAAAMAP6AFAgC0f5y6vBLggA=="
        let pps64 = "RAHA88DhRSQ="
        
        let vps = Data(base64Encoded: vps64, options: .ignoreUnknownCharacters)!
        let sps = Data(base64Encoded: sps64, options: .ignoreUnknownCharacters)!
        let pps = Data(base64Encoded: pps64, options: .ignoreUnknownCharacters)!
        let format265 = try CMVideoFormatDescription(hevcParameterSets: [Data(vps), Data(sps), Data(pps)])
        print(format265)
        XCTAssertEqual(format265.dimensions.width, 640)
        XCTAssertEqual(format265.dimensions.height, 720)
    }
}


