//
//  ChatSocketHelper.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 08/06/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import Starscream

let chatKHost = "ws://208.109.12.159:8089"


final class ChatSocketHelper: NSObject,ViewModel {
    var brokenRules : [BrokenRule]    = [BrokenRule]()
    var isValid     : Bool = true
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    var didFinishFetch_More: (() -> ())?
    var didFinishUploadChatImage: (() -> ())?
    //API related Variable
    var error: String? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    private var room   = "0-0"
    private var socket : WebSocket?
    var updateMessages : (([ChatModel])->())?
    var isConnected = false
    override init() {
        super.init()
    }
    func configureSocketClient(receiverID:Int) {
        let room = receiverID < AppSettings.userID ? "\(receiverID)-\(AppSettings.userID)" : "\(AppSettings.userID)-\(receiverID)"
        guard let url = URL(string: kHost + "?token=\(AppSettings.chatUniqeNumber)&room=\(room)&userID=\(AppSettings.userID)") else {
            return
        }
        self.room = room
        socket = WebSocket(request: URLRequest(url: url))
        socket?.delegate = self
        establishConnection()
    }
    func establishConnection() {
        socket?.connect()
    }
    func closeConnection() {
        socket?.disconnect()
    }
    func fetchMessage(receiverID:String) {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getChatList(receiverID: receiverID, completion: { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(let res):
                if let dat = res.data {
                    self.updateMessages?(dat.reversed())
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        })
    }
    func readMessage(receiverID:String) {
        let sendMsg = "{\"userID\":\"\(AppSettings.userID)\",\"recieverID\":\"\(receiverID)\",\"type\":\"read\",\"msg\":\"\",\"serviceType\":\"Chat\",\"MessageType\":\"Text\",\"room\":\"\(room)\"}"
        print(sendMsg)
        socket?.write(string: sendMsg)
    }
    func sendMessage(message: String,receiverID:String) {
        let sendMsg = "{\"userID\":\"\(AppSettings.userID)\",\"recieverID\":\"\(receiverID)\",\"type\":\"Chat\",\"msg\":\"\(message)\",\"serviceType\":\"Chat\",\"MessageType\":\"Text\",\"room\":\"\(room)\"}"
        print(sendMsg)
        socket?.write(string: sendMsg)
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd Hh:mm:ss"
        let chat = ChatModel(senderName: "", senderID: "\(AppSettings.userID)", receiverName: "", receiverID: receiverID, message: message, createdOn: dateFormate.string(from: Date()), messageType: "Text")
        updateMessages?([chat])
    }
    func uploadChatImage(image:UIImage,receiverID:String) {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.addChatPic(image: image) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(let res):
                let sendMsg = "{\"userID\":\"\(AppSettings.userID)\",\"recieverID\":\"\(receiverID)\",\"type\":\"Chat\",\"msg\":\"\(res.fileName ?? "")\",\"serviceType\":\"Chat\",\"MessageType\":\"Image\",\"room\":\"\(self.room)\"}"
                print(sendMsg)
                self.socket?.write(string: sendMsg)
                let dateFormate = DateFormatter()
                dateFormate.dateFormat = "yyyy-MM-dd Hh:mm:ss"
                let chat = ChatModel(senderName: "", senderID: "\(AppSettings.userID)", receiverName: "", receiverID: receiverID, message: res.fileName ?? "", createdOn: dateFormate.string(from: Date()), messageType: "Image")
                self.updateMessages?([chat])
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func userBlock(receiverID:String) {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.blockUser(otherUserID: Int(receiverID) ?? 0) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(_):
                self.didFinishFetch_More?()
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    func removeMatch(receiverID:String) {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.removeMatch(otherUserID: Int(receiverID) ?? 0) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(_):
                self.didFinishFetch_More?()
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
}
// MARK: - WebSocketDelegate
extension ChatSocketHelper : WebSocketDelegate {
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
                let commentRes = try JSONDecoder().decode(ChatResponseModel.self, from: textData)
                if let dat = commentRes.data {
                    updateMessages?(dat)
                }
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
