import UIKit
import Starscream

let kHost = "ws://208.109.12.159:8089"

final class SocketHelper: NSObject {
    
    static  let shared = SocketHelper()
    private var socket : WebSocket?
    var fetchedComment : ((CommentResponse?)->())?
    var isConnected = false
    private override init() {
        super.init()
        configureSocketClient()
    }
    private func configureSocketClient() {
        guard let url = URL(string: kHost) else {
            return
        }
        socket = WebSocket(request: URLRequest(url: url))
        socket?.delegate = self
    }
    func establishConnection() {
        socket?.connect()
    }
    func closeConnection() {
        socket?.disconnect()
    }
    func sendMessage(message: String, withNickname nickname: String) {
        socket?.write(string: message)
    }
}
// MARK: - WebSocketDelegate
extension SocketHelper : WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
            guard let textData = string.data(using: .utf8) else {
                return
            }
            do {
                let commentRes = try JSONDecoder().decode(CommentResponseModel.self, from: textData)
                fetchedComment?(commentRes.data)
            }
            catch {
                print("Error in fetching comment")
            }
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            print(error?.localizedDescription ?? "")
        }
    }
    
}
