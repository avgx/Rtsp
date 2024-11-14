import Foundation
import CommonCrypto

public class CommandsManager {
    private var host: String?
    private var port: Int?
    private var path: String?
    private var cSeq = 0
    private var sessionId: String? = nil
    private var authorization: String? = nil
    private var timeStamp: Int64?
    //Auth
    private var user: String? = nil
    private var password: String? = nil
    
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
    
    public func createDescribe() -> String {
        let options = "DESCRIBE rtsp://\(host!):\(port!)\(path!) RTSP/1.0\r\n\(addHeader())\r\n"
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
    
    public func setAuth(user: String, password: String) {
        self.user = user
        self.password = password
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
    
    public func createDescribeWithAuth(response: String) -> String {
        authorization = createAuth(response: response)
        return createDescribe()
    }
    
    private func createAuth(response: String) -> String {
        let authPattern = response.groups(for: "realm=\"(.+)\",\\s+nonce=\"(\\w+)\"")
        if authPattern.count > 0 {
            print("using digest auth")
            let realm = authPattern[0][1]
            let nonce = authPattern[0][2]
            let hash1 = "\(user!):\(realm):\(password!)".md5
            let hash2 = "DESCRIBE:rtsp://\(host!):\(port!)\(path!)".md5
            let hash3 = "\(hash1):\(nonce):\(hash2)".md5
            return "Digest username=\"\(user!)\", realm=\"\(realm)\", nonce=\"\(nonce)\", uri=\"rtsp://\(host!):\(port!)\(path!)\", response=\"\(hash3)\""
        } else {
            print("using basic auth")
            let data = "\(user!):\(password!)"
            let base64Data = data.data(using: .utf8)!.base64EncodedString()
            return "Basic \(base64Data)"
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


extension String {
    func groups(for regexPattern: String) -> [[String]] {
        do {
            let text = self
            let regex = try NSRegularExpression(pattern: regexPattern)
            let matches = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return matches.map { match in
                (0..<match.numberOfRanges).map {
                    let rangeBounds = match.range(at: $0)
                    guard let range = Range(rangeBounds, in: text) else {
                        return ""
                    }
                    return String(text[range])
                }
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    var md5: String {
        let data = Data(utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
