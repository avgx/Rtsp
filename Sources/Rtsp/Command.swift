import Foundation

public struct Command {
    let method: Method,
    cSeq: Int,
    status: Int,
    text: String
    
    init(method: Method, cSeq: Int, status: Int, text: String) {
        self.method = method
        self.cSeq = cSeq
        self.status = status
        self.text = text
    }
}
