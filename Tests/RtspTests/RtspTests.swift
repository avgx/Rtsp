import XCTest
@testable import Rtsp

final class RtspTests: XCTestCase {
    func testDemo() async throws {
        
        let rtsp = RtspClient()
        try await rtsp.check(url: "rtsp://136.243.144.109:554/-")
        try await rtsp.check(url: "rtsp://192.168.1.102:554/-")
    }
}


