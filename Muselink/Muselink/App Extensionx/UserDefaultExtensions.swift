//
//  UserDefaultExtensions.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 11/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import Foundation
fileprivate enum DefaultKey : String {
    case SoundProfileCheck
    case UploadTutsCount
    case HasLogIn
    case HasSubscribed
    case HasShownTutorial
    case UserID
    case JWTToken
    case ChatUniqueNumber
    case AudioSearchHistory
    case GuestNextCount
    case DownloadedSongURL
    case ProfileImageURL
}
extension UserDefaults {
    fileprivate class var appSuit : UserDefaults {
        if let suit =  UserDefaults(suiteName: "Muselink") {
            return suit
        }
        else {
            return UserDefaults.standard
        }
    }
}
struct AppSettings {
    static var isSoundProfile: Bool {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.bool(forKey: DefaultKey.SoundProfileCheck.rawValue)
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.SoundProfileCheck.rawValue)
            useDef.synchronize()
        }
    }
    static var hasShowTutorials: Bool {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.bool(forKey: DefaultKey.HasShownTutorial.rawValue)
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.HasShownTutorial.rawValue)
            useDef.synchronize()
        }
    }
    static var uploadTutsCount: Int {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.integer(forKey: DefaultKey.UploadTutsCount.rawValue)
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.UploadTutsCount.rawValue)
            useDef.synchronize()
        }
    }
    static var guestNextCount: Int {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.integer(forKey: DefaultKey.GuestNextCount.rawValue)
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.GuestNextCount.rawValue)
            useDef.synchronize()
        }
    }
    static var hasLogin: Bool {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.bool(forKey: DefaultKey.HasLogIn.rawValue)
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.HasLogIn.rawValue)
            useDef.synchronize()
        }
    }
    static var hasSubscription: Bool {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.bool(forKey: DefaultKey.HasSubscribed.rawValue)
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.HasSubscribed.rawValue)
            useDef.synchronize()
        }
    }
    static var userID: Int {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.integer(forKey: DefaultKey.UserID.rawValue)
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.UserID.rawValue)
            useDef.synchronize()
        }
    }
    static var jwtToken: String {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.string(forKey: DefaultKey.JWTToken.rawValue) ?? ""
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.JWTToken.rawValue)
            useDef.synchronize()
        }
    }
    
    static var chatUniqeNumber: String {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.string(forKey: DefaultKey.ChatUniqueNumber.rawValue) ?? ""
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.ChatUniqueNumber.rawValue)
            useDef.synchronize()
        }
    }
    static var audioSearchHistory: String {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.string(forKey: DefaultKey.AudioSearchHistory.rawValue) ?? ""
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.AudioSearchHistory.rawValue)
            useDef.synchronize()
        }
    }
    static var downloadedSongURL: String {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.string(forKey: DefaultKey.DownloadedSongURL.rawValue) ?? ""
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.DownloadedSongURL.rawValue)
            useDef.synchronize()
        }
    }
    static var profileImageURL: String {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.string(forKey: DefaultKey.ProfileImageURL.rawValue) ?? ""
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.ProfileImageURL.rawValue)
            useDef.synchronize()
        }
    }
}
