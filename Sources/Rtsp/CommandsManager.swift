import Foundation

public class CommandsManager {
    private var host: String?
    private var port: Int?
    private var path: String?
    private var cSeq = 0
    private var sessionId: String? = nil
    private var authorization: String? = nil
    private var timeStamp: Int64?
    
    private let commandParser = CommandParser()
    
    public init() {
        let time = Date().millisecondsSince1970
        timeStamp = (time / 1000) << 32 & (((time - ((time / 1000) * 1000)) >> 32) / 1000)
    }
    
    private func addHeader() -> String {
        let session = sessionId != nil ? "Session: \(sessionId!)\r\n" : ""
        let auth = authorization != nil ? "Authorization: \(authorization!)\r\n" : ""
        let result = "CSeq: \(cSeq)\r\n\(session)\(auth)"
        cSeq += 1
        return result
    }
    
    public func createOptions() -> String {
        let options = "OPTIONS rtsp://\(host!):\(port!)\(path!) RTSP/1.0\r\n\(addHeader())\r\n"
        print(options)
        return options
    }
    
    public func createTeardown() -> String {
        let teardown = "TEARDOWN rtsp://\(host!):\(port!)\(path!) RTSP/1.0\r\n\(addHeader())\r\n"
        print(teardown)
        return teardown
    }
    
    public func setUrl(host: String, port: Int, path: String) {
        self.host = host
        self.port = port
        self.path = path
    }
    
    public func getResponse(socket: Socket, method: Method = Method.UNKNOWN) async throws -> Command {
        let response = try await socket.readString()
        print(response)
        if (method == Method.UNKNOWN) {
            return commandParser.parseCommand(commandText: response)
        } else {
            let command = commandParser.parseResponse(method: method, responseText: response)
            sessionId = commandParser.getSessionId(command: command)
            
            return command
        }
    }
    
}

extension Date {
    var millisecondsSince1970:Int64 {
        Int64((timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
