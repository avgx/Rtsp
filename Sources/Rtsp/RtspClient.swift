import Foundation

public class RtspClient {
    
    private var socket: Socket?
    private let commandsManager = CommandsManager()
    private var tlsEnabled = false
    private var url: String? = nil
    //    private var semaphore: Task<Bool, Error>? = nil
    
    public init() {
        print("\(String(describing: self))")
    }
    deinit {
        print("~\(String(describing: self))")
    }
    
    public func check(url: String) async throws {
        
        guard let comp = URLComponents(string: url) else {
            throw Socket.IOException.runtimeError("invalid rtsp url")
        }
        
        self.url = comp.url?.absoluteString
        
        self.tlsEnabled = comp.scheme?.hasPrefix("rtsps") ?? false
        guard let host = comp.host else {
            throw Socket.IOException.runtimeError("invalid rtsp host")
        }
        
        let port = comp.port ?? 554
        let path = comp.path
        self.commandsManager.setUrl(host: host, port: port, path: path)
        
        self.socket = Socket(tlsEnabled: self.tlsEnabled, host: host, port: port)
        try await self.socket?.connect()
        
        //Options
        try await self.socket?.write(data: self.commandsManager.createOptions())
        let _ = try await self.commandsManager.getResponse(socket: self.socket!, method: Method.OPTIONS)
        
        //            try await self.socket?.write(data: self.commandsManager.createTeardown())
        //            let _ = try await self.commandsManager.getResponse(socket: self.socket!, method: Method.TEARDOWN)
        
        socket?.disconnect()
        
    }
    
    //    public func disconnect(clear: Bool = true) {
    //
    //        let sync = DispatchGroup()
    //        sync.enter()
    //        let task = Task {
    //            do {
    //                try await self.socket?.write(data: self.commandsManager.createTeardown())
    //                sync.leave()
    //            } catch {
    //                sync.leave()
    //            }
    //        }
    //        let _ = sync.wait(timeout: DispatchTime.now() + 0.1)
    //        task.cancel()
    //        socket?.disconnect()
    //    }
    
}
//
//extension String {
//    func groups(for regexPattern: String) -> [[String]] {
//        do {
//            let text = self
//            let regex = try NSRegularExpression(pattern: regexPattern)
//            let matches = regex.matches(in: text,
//                                    range: NSRange(text.startIndex..., in: text))
//            return matches.map { match in
//                (0..<match.numberOfRanges).map {
//                    let rangeBounds = match.range(at: $0)
//                    guard let range = Range(rangeBounds, in: text) else {
//                        return ""
//                    }
//                    return String(text[range])
//                }
//            }
//        } catch let error {
//            print("invalid regex: \(error.localizedDescription)")
//            return []
//        }
//    }
//
//}
