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
    
    public func check(url: String, describe: Bool = false) async throws -> [String] {
        
        guard let comp = URLComponents(string: url) else {
            throw Socket.IOException.runtimeError("invalid rtsp url")
        }
        
        self.url = comp.url?.absoluteString
        
        self.tlsEnabled = comp.scheme?.hasPrefix("rtsps") ?? false
        guard let host = comp.host else {
            throw Socket.IOException.runtimeError("invalid rtsp host")
        }
        
        let port = comp.port ?? 554
        let path = comp.path + "?" + (comp.query ?? "")
        self.commandsManager.setUrl(host: host, port: port, path: path)
        self.commandsManager.setAuth(user: comp.user ?? "-", password: comp.password ?? "-")
        
        self.socket = Socket(tlsEnabled: self.tlsEnabled, host: host, port: port)
        try await self.socket?.connect()
        defer { socket?.disconnect() }
        //Options
        try await self.socket?.write(data: self.commandsManager.createOptions())
        let _ = try await self.commandsManager.getResponse(socket: self.socket!, method: Method.OPTIONS)
        
        if describe {
            try await self.socket?.write(data: self.commandsManager.createDescribe())
            let describeResp = try await self.commandsManager.getResponse(socket: self.socket!, method: Method.DESCRIBE)
            
            if describeResp.status == 403 {
                
            } else if describeResp.status == 401 {
                try await self.socket?.write(data: self.commandsManager.createDescribeWithAuth(response: describeResp.text))
                
                let timeoutTask = Task {
                    try await Task.sleep(nanoseconds: UInt64(1) * NSEC_PER_SEC)
                    //throw URLError(.timedOut)
                    self.socket!.disconnect()
                }
                
                let describeResp2 = try await self.commandsManager.getResponse(socket: self.socket!, method: Method.DESCRIBE)
                timeoutTask.cancel()
                
                if describeResp2.status == 401 {
                    //self.connectCheckerRtsp?.onAuthErrorRtsp()
                    //error
                    print("error")
                } else if describeResp2.status == 200 {
                    //self.connectCheckerRtsp?.onAuthSuccessRtsp()
                    //ok
                    print("ok")
                    return Array(
                        describeResp2.text
                            .lines
                            .drop(while: { $0 != ""})
                            .drop(while: { $0 == ""})
                    )
                } else if describeResp2.status == 404 {
                    print("error")
                    throw URLError(URLError.Code(rawValue: 404))
                } else {
                    //self.connectCheckerRtsp?.onConnectionFailedRtsp(reason: "Error configure stream, announce with auth failed \(authStatus)")
                    print("error")
                    throw URLError(.badServerResponse)
                }

            } else if describeResp.status != 200 {
                //failed
                print("error")
                throw URLError(.badServerResponse)
            } else {
                //ok
                print("ok")
            }
        }
        
        return []
        //            try await self.socket?.write(data: self.commandsManager.createTeardown())
        //            let _ = try await self.commandsManager.getResponse(socket: self.socket!, method: Method.TEARDOWN)
        
        //socket?.disconnect()
        
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

extension String {
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
}
