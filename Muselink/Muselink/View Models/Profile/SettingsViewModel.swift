//
//  SettingsViewModel.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 13/04/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.


import UIKit
enum PushNotificationType : String {
    case newAdmirer    = "NewAdmirerNotificationStatus"
    case newMatch      = "NewMatchNotificationStatus"
    case newMessage    = "NewMessageNotificationStatus"
    case uploadNewFile = "NewMatchFileNotificationStatus"
}

enum PermissionType : String {
    case explorer      = "AccountStatus"
    case share         = "SoundFileStatus"
    case directMessage = "DirectMessageStatus"
}
enum SupportType : String {
    case reportAProblem = "ReportAProblem"
    case submitAnIdea   = "SubmitAIdea"
}
enum ValidationType {
    case ChangePassword
    case Username
    case Email
    case PhoneNumber
}
class SettingsViewModel :NSObject, ViewModel {
    var brokenRules : [BrokenRule]    = [BrokenRule]()
    var isValid          : Bool {
        get {
            self.brokenRules = [BrokenRule]()
            self.Validate()
            return self.brokenRules.count == 0 ? true : false
        }
    }
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure        : (() -> ())?
    var updateLoadingStatus     : (() -> ())?
    var didFinishFetch          : (() -> ())?
    var didFinishBlockingFetch  : (() -> ())?
    var didFinishSupport        : (() -> ())?
    var didFinishChangePassword : (() -> ())?
    var didFinishChangeusername : (() -> ())?
    var didFinishChangeEmail    : (() -> ())?
    var didFinishChangePhoneNo  : (() -> ())?
    
    var oldPassword             : Dynamic<String> = Dynamic("")
    var newPassword             : Dynamic<String> = Dynamic("")
    var confirmNewPassword      : Dynamic<String> = Dynamic("")
    
    var userName                : Dynamic<String> = Dynamic("")
    var email                   : Dynamic<String> = Dynamic("")
    var phoneNumber             : Dynamic<String> = Dynamic("")
    var phoneCode               : Dynamic<String> = Dynamic("+91")
    
    //API related Variable
    var error: String? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var settingDetails : SettingDetailsModel?
    var blockedList = [BlockUserModel]()
    var review      = String()
    var supportFile = Data()
    var selectedValidationType = ValidationType.ChangePassword

    func Validate() {
        switch selectedValidationType {
            case .ChangePassword:
                if oldPassword.value == "" || oldPassword.value == " " {
                    self.brokenRules.append(BrokenRule(propertyName: "NoOldPassword",           message: "Enter Old password"))
                }
                if newPassword.value == "" || newPassword.value == " " {
                    self.brokenRules.append(BrokenRule(propertyName: "NoNwwPassword",           message: "Enter New password"))
                }
                if confirmNewPassword.value == "" || confirmNewPassword.value == " " {
                    self.brokenRules.append(BrokenRule(propertyName: "NoConfirmPassword",       message: "Re-Enter New password"))
                }
                if confirmNewPassword.value != newPassword.value {
                    self.brokenRules.append(BrokenRule(propertyName: "ConfirmPasswordMisMatch", message: "Confirm Password not matched"))
                }
            case .Username:
                if userName.value == "" || userName.value == " " {
                    self.brokenRules.append(BrokenRule(propertyName: "NoUsername",    message: "Enter Username"))
                }
            case .Email:
                if email.value == "" || email.value == " " {
                    self.brokenRules.append(BrokenRule(propertyName: "NoEmail",       message: "Enter Email"))
                }
            case .PhoneNumber:
                if phoneNumber.value == "" || phoneNumber.value == " " {
                    self.brokenRules.append(BrokenRule(propertyName: "NoPhoneNumber", message: "Enter Phone Number"))
                }
        }
    }
}
extension SettingsViewModel {
    func fetchSettings() {
        let model = NetworkManager.sharedInstance
        model.getSettingsDetails { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .success(let res):
                self.settingDetails = res.data
                self.didFinishFetch?()
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
    
    func fetchBlockedList() {
        let model = NetworkManager.sharedInstance
        model.getListOfBlockedUsers { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .success(let res):
                self.blockedList = res.data ?? []
                self.didFinishBlockingFetch?()
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
    
    func unBlockAnUser(user:BlockUserModel) {
        let model = NetworkManager.sharedInstance
        model.unblockUser(accountID: user.blockedAccountID ?? "0") { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .success(_):
                self.fetchBlockedList()
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
    
    func updateNotificationStatus(for notification:PushNotificationType,status:Bool) {
        let model = NetworkManager.sharedInstance
        model.updateNotificationSettings(type: notification, status: status) { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .success(_):
                switch notification {
                case .newAdmirer:
                    self.settingDetails?.newAdmirerNotificationStatus   = status ? "1" : "0"
                case .newMatch:
                    self.settingDetails?.newMatchNotificationStatus     = status ? "1" : "0"
                case .newMessage:
                    self.settingDetails?.newMessageNotificationStatus   = status ? "1" : "0"
                case .uploadNewFile:
                    self.settingDetails?.newMatchFileNotificationStatus = status ? "1" : "0"
                }
                self.didFinishBlockingFetch?()
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
    func updateAccountPermissionStatus(for permission:PermissionType,status:String) {
        let model = NetworkManager.sharedInstance
        model.updateAccountPermissionSettings(type: permission, status: status) { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .success(_):
                switch permission {
                case .explorer:
                    self.settingDetails?.accountStatus       = status
                case .share:
                    self.settingDetails?.soundFileStatus     = status
                case .directMessage:
                    self.settingDetails?.directMessageStatus = status
                }
                self.didFinishBlockingFetch?()
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
    func submintSupport(type:SupportType) {
        let model = NetworkManager.sharedInstance
        model.submitSupport(type: type, review: review, supportFile: supportFile) { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .success(_):
                self.review = ""
                self.didFinishSupport?()
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
    func changePassword() {
        let model = NetworkManager.sharedInstance
        model.changePassword(oldPassword: oldPassword.value, newPassword: newPassword.value) { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .success(_):
                self.oldPassword.value        = ""
                self.newPassword.value        = ""
                self.confirmNewPassword.value = ""
                self.didFinishChangePassword?()
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
    
    func changeUserName() {
        let model = NetworkManager.sharedInstance
        model.changeUsername(username: userName.value) { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .success(_):
                self.settingDetails?.userName = self.userName.value
                self.userName.value = ""
                self.didFinishChangeusername?()
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
    
    func changeEmail() {
        let model = NetworkManager.sharedInstance
        model.changeEmail(email: email.value) { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .success(_):
                self.settingDetails?.email = self.email.value
                self.email.value = ""
                self.didFinishChangeEmail?()
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
    
    func changePhoneNumber() {
        let model = NetworkManager.sharedInstance
        model.changePhoneNumber(phone: phoneCode.value+phoneNumber.value) { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .success(_):
                self.settingDetails?.phone = self.phoneNumber.value
                self.phoneNumber.value = ""
                self.didFinishChangePhoneNo?()
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
