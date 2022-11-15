//
//  RegistrationViewModel.swift
//  Muselink
//
//  Created by HarishParas on 18/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import Foundation
enum SignUpType : String {
    case Email
    case Phone
    case Facebook
    case Instagram
    case Tiktok
    case SoundCloud
    case AppleID
}
class RegistrationViewModel :NSObject, ViewModel {
    enum ModelType {
        case SignIn(type: SignUpType)
        case SignUp(type: SignUpType)
        case Forget
        case LogOut
    }
    var modelType        : ModelType
    var brokenRules      : [BrokenRule]    = [BrokenRule]()
    var phoneCode        : Dynamic<String> = Dynamic("+91")
    var phone            : Dynamic<String> = Dynamic("")
    var email            : Dynamic<String> = Dynamic("")
    var password         : Dynamic<String> = Dynamic("")
    var confirmPasswrd   : Dynamic<String> = Dynamic("")
    var verificationCode = String()
    var socialID         = String()
    var isValid          : Bool {
        get {
            self.brokenRules = [BrokenRule]()
            self.Validate()
            return self.brokenRules.count == 0 ? true : false
        }
    }
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    init(type:ModelType) {
        modelType = type
    }
    
    //API related Variable
    var error: String? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    //Firebase Auth User ID
    var userID : String? {
        didSet {
            guard let _ = userID else { return }
            self.didFinishFetch?()
        }
    }
    var isSocialAccountVerified = false
}
extension RegistrationViewModel {
    private func Validate() {
        switch modelType {
        case .SignIn(let type):
            switch type {
            case .Email:
                if email.value == "" || email.value == " " {
                    self.brokenRules.append(BrokenRule(propertyName: "NoEmail", message: "Enter Email"))
                }
                if !email.value.isValidEmail() {
                    self.brokenRules.append(BrokenRule(propertyName: "InValidEmail", message: "Enter Valid Email"))
                }
                if password.value == "" || password.value == " " {
                    self.brokenRules.append(BrokenRule(propertyName: "NoPassword", message: "Enter password"))
                }
                break
            case .Phone:
                if phoneCode.value == "" || phoneCode.value == " " {
                    self.brokenRules.append(BrokenRule(propertyName: "NoPhoneCode", message: "Select Phone code"))
                }
                if phone.value == "" || phone.value == " " {
                    self.brokenRules.append(BrokenRule(propertyName: "NoPhone", message: "Enter phone number"))
                }
                break
            case .Facebook:
                if socialID == "" || socialID == " " {
                    self.brokenRules.append(BrokenRule(propertyName: "NoSocialID", message: "Please Login Again"))
                }
                break
            case .Instagram:
                if socialID == "" || socialID == " " {
                    self.brokenRules.append(BrokenRule(propertyName: "NoSocialID", message: "Please Login Again"))
                }
                break
            case .Tiktok:
                if socialID == "" || socialID == " " {
                    self.brokenRules.append(BrokenRule(propertyName: "NoSocialID", message: "Please Login Again"))
                }
                break
            case .SoundCloud:
                if socialID == "" || socialID == " "{
                    self.brokenRules.append(BrokenRule(propertyName: "NoSocialID", message: "Please Login Again"))
                }
                break
            case .AppleID:
                if socialID == "" || socialID == " "{
                    self.brokenRules.append(BrokenRule(propertyName: "NoSocialID", message: "Please Login Again"))
                }
                break
            }
        case .SignUp(let type):
            switch type {
            case .Email:
                if email.value == "" || email.value == " "{
                    self.brokenRules.append(BrokenRule(propertyName: "NoEmail", message: "Enter Email"))
                }
                if !email.value.isValidEmail() {
                    self.brokenRules.append(BrokenRule(propertyName: "InValidEmail", message: "Enter Valid Email"))
                }
                if password.value == "" || password.value == " "{
                    self.brokenRules.append(BrokenRule(propertyName: "NoPassword", message: "Enter password"))
                }
                if password.value.count < 16 && password.value.count > 8 {
                    self.brokenRules.append(BrokenRule(propertyName: "InvalidPassword", message: "Password should be in range of 8-16 character"))
                }
                break
            case .Phone:
                if phoneCode.value == "" || phoneCode.value == " "{
                    self.brokenRules.append(BrokenRule(propertyName: "NoPhoneCode", message: "Select Phone code"))
                }
                if phone.value == "" || phone.value == " "{
                    self.brokenRules.append(BrokenRule(propertyName: "NoPhone", message: "Enter phone number"))
                }
                break
            case .Facebook:
                if socialID == "" || socialID == " "{
                    self.brokenRules.append(BrokenRule(propertyName: "NoSocialID", message: "Please Login Again"))
                }
                break
            case .Instagram:
                if socialID == "" || socialID == " "{
                    self.brokenRules.append(BrokenRule(propertyName: "NoSocialID", message: "Please Login Again"))
                }
                break
            case .Tiktok:
                if socialID == "" || socialID == " "{
                    self.brokenRules.append(BrokenRule(propertyName: "NoSocialID", message: "Please Login Again"))
                }
                break
            case .SoundCloud:
                if socialID == "" || socialID == " "{
                    self.brokenRules.append(BrokenRule(propertyName: "NoSocialID", message: "Please Login Again"))
                }
                break
            case .AppleID:
                if socialID == "" || socialID == " "{
                    self.brokenRules.append(BrokenRule(propertyName: "NoSocialID", message: "Please Login Again"))
                }
                break
            }
        case .Forget:
            if email.value == "" || email.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "NoEmail", message: "Enter Email"))
            }
            break
        case .LogOut:
            break
        }
    }
}
// MARK: - Network call
extension RegistrationViewModel {
    func checkSubscription() {
        let model = NetworkManager.sharedInstance
        model.checkSubscription { (result) in
            switch result{
            case .success(let res):
                AppSettings.hasSubscription = res.data?.subscriptionStatus ?? 0 == 1
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    func signIn(type:SignUpType) {
        switch type {
        case .Email:
            isLoading = true
            let model = NetworkManager.sharedInstance
            model.login(email: email.value, logInType: "email",password:password.value) { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result{
                case .success(let res):
                    AppSettings.hasLogin = true
                    AppSettings.jwtToken = res.token ?? ""
                    AppSettings.chatUniqeNumber = res.data?.chatUniqNumber ?? ""
                    AppSettings.userID   = Int(res.data?.id ?? "0") ?? 0
                    AppSettings.profileImageURL = res.data?.profileImage ?? ""
                    self.checkSubscription()
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
        case .Phone:
            isLoading = true
            let model = NetworkManager.sharedInstance
            model.login(phone: phoneCode.value+phone.value, logInType: "phone") { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result{
                case .success(let res):
                    AppSettings.hasLogin = true
                    AppSettings.jwtToken = res.token ?? ""
                    AppSettings.chatUniqeNumber = res.data?.chatUniqNumber ?? ""
                    AppSettings.userID   = Int(res.data?.id ?? "0") ?? 0
                    AppSettings.profileImageURL = res.data?.profileImage ?? ""
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
        case .Facebook:
            isLoading = true
            let model = NetworkManager.sharedInstance
            model.login(logInType: "social", socialID: socialID) { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result{
                case .success(let res):
                    AppSettings.hasLogin = true
                    AppSettings.jwtToken = res.token ?? ""
                    AppSettings.chatUniqeNumber = res.data?.chatUniqNumber ?? ""
                    AppSettings.userID   = Int(res.data?.id ?? "0") ?? 0
                    AppSettings.profileImageURL = res.data?.profileImage ?? ""
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
        case .Instagram:
            let model = NetworkManager.sharedInstance
            model.login(logInType: "social", socialID: socialID) { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result{
                case .success(let res):
                    AppSettings.hasLogin = true
                    AppSettings.jwtToken = res.token ?? ""
                    AppSettings.chatUniqeNumber = res.data?.chatUniqNumber ?? ""
                    AppSettings.userID   = Int(res.data?.id ?? "0") ?? 0
                    AppSettings.profileImageURL = res.data?.profileImage ?? ""
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
        case .Tiktok:
            isLoading = true
            let model = NetworkManager.sharedInstance
            model.login(logInType: "social", socialID: socialID) { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result{
                case .success(let res):
                    AppSettings.hasLogin = true
                    AppSettings.jwtToken = res.token ?? ""
                    AppSettings.chatUniqeNumber = res.data?.chatUniqNumber ?? ""
                    AppSettings.userID   = Int(res.data?.id ?? "0") ?? 0
                    AppSettings.profileImageURL = res.data?.profileImage ?? ""
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
        case .SoundCloud:
            isLoading = true
            let model = NetworkManager.sharedInstance
            model.login(logInType: "social", socialID: socialID) { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result{
                case .success(let res):
                    AppSettings.hasLogin = true
                    AppSettings.jwtToken = res.token ?? ""
                    AppSettings.chatUniqeNumber = res.data?.chatUniqNumber ?? ""
                    AppSettings.userID   = Int(res.data?.id ?? "0") ?? 0
                    AppSettings.profileImageURL = res.data?.profileImage ?? ""
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
        case .AppleID:
            isLoading = true
            let model = NetworkManager.sharedInstance
            model.login(logInType: "social", socialID: socialID) { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result{
                case .success(let res):
                    AppSettings.hasLogin = true
                    AppSettings.jwtToken = res.token ?? ""
                    AppSettings.chatUniqeNumber = res.data?.chatUniqNumber ?? ""
                    AppSettings.userID   = Int(res.data?.id ?? "0") ?? 0
                    AppSettings.profileImageURL = res.data?.profileImage ?? ""
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
    }
    func signUP(type:SignUpType) {
        switch type {
        case .Email:
            isLoading = true
            let model = NetworkManager.sharedInstance
            model.Sign_up(email: email.value, signUpType: "email",password:password.value,countryName: String().currentCountryName()) { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result{
                case .success(let res):
                    AppSettings.hasLogin = true
                    AppSettings.jwtToken = res.token ?? ""
                    AppSettings.chatUniqeNumber = res.data?.chatUniqNumber ?? ""
                    AppSettings.userID   = Int(res.data?.id ?? "0") ?? 0
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
        case .Phone:
            isLoading = true
            let model = NetworkManager.sharedInstance
            model.Sign_up(phone: phoneCode.value+phone.value, signUpType: "phone",countryName: String().currentCountryName()) { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result{
                case .success(let res):
                    AppSettings.hasLogin = true
                    AppSettings.jwtToken = res.token ?? ""
                    AppSettings.chatUniqeNumber = res.data?.chatUniqNumber ?? ""
                    AppSettings.userID   = Int(res.data?.id ?? "0") ?? 0
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
        case .Facebook:
            isLoading = true
            let model = NetworkManager.sharedInstance
            model.Sign_up(signUpType: "social", socialID: socialID,countryName: String().currentCountryName()) { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result{
                case .success(let res):
                    AppSettings.hasLogin = true
                    AppSettings.jwtToken = res.token ?? ""
                    AppSettings.chatUniqeNumber = res.data?.chatUniqNumber ?? ""
                    AppSettings.userID   = Int(res.data?.id ?? "0") ?? 0
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
        case .Instagram :
            isLoading = true
            let model = NetworkManager.sharedInstance
            model.Sign_up(signUpType: "social", socialID: socialID,countryName: String().currentCountryName()) { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result{
                case .success(let res):
                    AppSettings.hasLogin = true
                    AppSettings.jwtToken = res.token ?? ""
                    AppSettings.chatUniqeNumber = res.data?.chatUniqNumber ?? ""
                    AppSettings.userID   = Int(res.data?.id ?? "0") ?? 0
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
        case .Tiktok:
            isLoading = true
            let model = NetworkManager.sharedInstance
            model.Sign_up(signUpType: "social", socialID: socialID,countryName: String().currentCountryName()) { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result{
                case .success(let res):
                    AppSettings.hasLogin = true
                    AppSettings.jwtToken = res.token ?? ""
                    AppSettings.chatUniqeNumber = res.data?.chatUniqNumber ?? ""
                    AppSettings.userID   = Int(res.data?.id ?? "0") ?? 0
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
        case .SoundCloud:
            isLoading = true
            let model = NetworkManager.sharedInstance
            model.Sign_up(signUpType: "social", socialID: socialID,countryName: String().currentCountryName()) { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result{
                case .success(let res):
                    AppSettings.hasLogin = true
                    AppSettings.jwtToken = res.token ?? ""
                    AppSettings.chatUniqeNumber = res.data?.chatUniqNumber ?? ""
                    AppSettings.userID   = Int(res.data?.id ?? "0") ?? 0
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
        case .AppleID:
            isLoading = true
            let model = NetworkManager.sharedInstance
            model.Sign_up(signUpType: "social", socialID: socialID,countryName: String().currentCountryName()) { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result{
                case .success(let res):
                    AppSettings.hasLogin = true
                    AppSettings.jwtToken = res.token ?? ""
                    AppSettings.chatUniqeNumber = res.data?.chatUniqNumber ?? ""
                    AppSettings.userID   = Int(res.data?.id ?? "0") ?? 0
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
    }
    
    func verifyCode() {
        if verificationCode.isEmpty {
            error = "Please enter verification code."
            return
        }
        var isSignUp = false
        switch modelType {
            case .SignIn:
                isSignUp = false
            case .SignUp:
                isSignUp = true
            default:
                print("Not Match")
        }
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.verifyCode(phone: phoneCode.value + phone.value, code: verificationCode, isSignUp: isSignUp,countryName: String().currentCountryName()) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(_):
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
    
    func forgetPassword() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.forgetPassword(email: email.value) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(_):
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
    
    func logOut() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.forgetPassword(email: email.value) {[weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(_):
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
}
