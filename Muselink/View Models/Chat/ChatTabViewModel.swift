//
//  ChatTabViewModel.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 25/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit

class ChatTabViewModel :NSObject, ViewModel {
    enum NotificationTableType {
        case Notification
        case UnreadMessage
    }
    var brokenRules : [BrokenRule]    = [BrokenRule]()
    var isValid     : Bool = true
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    var didSelectChat:((ChatUserModel)->())?
    //API related Variable
    var error: String? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var tableType  = NotificationTableType.Notification {
        didSet {
            didFinishFetch?()
        }
    }
    var chatUserList     = [ChatUserModel]()
    var notificationList = [NotificationModel]()
}
extension ChatTabViewModel {
    func fetchNotifiactionList() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getNotificationList { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(let res):
                self.notificationList = res.data ?? []
                DispatchQueue.main.async {
                    self.didFinishFetch?()
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    print(desc)
                    //self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    func fetchChatUserList() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getChatUserList { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(let res):
                self.chatUserList = res.data ?? []
                DispatchQueue.main.async {
                    self.didFinishFetch?()
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    print(desc)
                    //self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
}
extension ChatTabViewModel : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableType {
        case .Notification:
            return notificationList.count
        case .UnreadMessage:
            return chatUserList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableType {
        case .Notification:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ChatTab_Notification") as? Cell_ChatTab_Notification else {
                return Cell_ChatTab_Notification()
            }
            let data = notificationList[indexPath.row]
            if data.message?.lowercased().contains("match") ?? false{
                let attributedText_1_1 = NSAttributedString.init(string: "Your have matched with ", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Regular(size: 14),NSAttributedString.Key.foregroundColor : UIColor.semiDarkBackGround])
                let attributedText_1_2 = NSAttributedString.init(string: "\(data.userName  ?? "User Name").", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Regular(size: 14),NSAttributedString.Key.foregroundColor : UIColor.brightPurple])
                let combinationText_1 = NSMutableAttributedString()
                combinationText_1.append(attributedText_1_1)
                combinationText_1.append(attributedText_1_2)
                cell.lbl_Title.attributedText = combinationText_1
            }
            else {
                let attributedText_1_1 = NSAttributedString.init(string: "You have a new admirer, keep swiping to match", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Regular(size: 14),NSAttributedString.Key.foregroundColor : UIColor.semiDarkBackGround])
                let combinationText_1 = NSMutableAttributedString()
                combinationText_1.append(attributedText_1_1)
                cell.lbl_Title.attributedText = combinationText_1
            }
            cell.imgView_profile?.setImage(name: data.profileImage ?? "")
            cell.selectionStyle = .none
            return cell
        case .UnreadMessage:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ChatTab_UnreadMessage") as? Cell_ChatTab_UnreadMessage else {
                return Cell_ChatTab_UnreadMessage()
            }
            let data = chatUserList[indexPath.row]
            if data.senderID ?? "" == "\(AppSettings.userID)" {
                cell.imgView_profile?.setImage(name: data.receiverProfilePicture ?? "")
                let attributedText_1_1 = NSAttributedString.init(string: "You have a message from\n", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Regular(size: 14),NSAttributedString.Key.foregroundColor : UIColor.semiDarkBackGround])
                let attributedText_1_2 = NSAttributedString.init(string: "\(data.receiverName  ?? "User Name").", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Regular(size: 14),NSAttributedString.Key.foregroundColor : UIColor.brightPurple])
                let combinationText_1 = NSMutableAttributedString()
                combinationText_1.append(attributedText_1_1)
                combinationText_1.append(attributedText_1_2)
                cell.lbl_Title.attributedText = combinationText_1
            }
            else {
                cell.imgView_profile?.setImage(name: data.senderProfilePicture ?? "")
                let attributedText_1_1 = NSAttributedString.init(string: "You have a message from\n", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Regular(size: 14),NSAttributedString.Key.foregroundColor : UIColor.semiDarkBackGround])
                let attributedText_1_2 = NSAttributedString.init(string: "\(data.senderName  ?? "User Name").", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Regular(size: 14),NSAttributedString.Key.foregroundColor : UIColor.brightPurple])
                let combinationText_1 = NSMutableAttributedString()
                combinationText_1.append(attributedText_1_1)
                combinationText_1.append(attributedText_1_2)
                cell.lbl_Title.attributedText = combinationText_1
            }
            if data.onlineStatus ?? "0" == "1" {
                cell.btn_OnlineStatus.setTitle(" Online", for: .normal)
                cell.btn_OnlineStatus.setImage(#imageLiteral(resourceName: "online"), for: .normal)
            }
            else {
                cell.btn_OnlineStatus.setTitle(" Offline", for: .normal)
                cell.btn_OnlineStatus.setImage(#imageLiteral(resourceName: "offline"), for: .normal)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
}
extension ChatTabViewModel : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableType == .UnreadMessage {
            didSelectChat?(chatUserList[indexPath.row])
        }
    }
}
