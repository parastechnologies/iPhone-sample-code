//
//  UserData.swift
//  GunInstructor
//
//  Created by appsdeveloper Developer on 27/10/21.
//

import Foundation
import UIKit

final class UserData {
    private enum DataKey: String {
        case User
        case LoginToken
        case error
        case IsLogin
        case IsVisitedAffFullScreen
        case isSilentAff
        case email
        case inviteCode
        case phone
        case password
        case FCMToken
        case user_ID
        case firstName
        case lastName
        case LoginUser
        case SocialUser
        case isComplete
        case verificationType
        case profileType
        case profilePic
        case gender
        case minAge
        case maxAge
        case deviceId
        case deviceType
        case imgPath
        case deviceToken
        case email_otp
        case currentUserType
        case appLink
        case IsEmailVerify
        case userType
        case socialType
        case socialId
        case language
        case isNotification
        case isSubscription
        case createdAt
        case isUserActive
        case choices
        case categories
        case rowHeights
        case token
    }
    
    static private let hasLaunchedKey = "HasLaunchedBefore"
    
        
    static func isFirstLaunch() -> Bool {
        let userDefaults = UserDefaults.standard
        let hasLaunchedBefore = userDefaults.bool(forKey: hasLaunchedKey)
        if !hasLaunchedBefore {
            userDefaults.set(true, forKey: hasLaunchedKey)
        }
        return !hasLaunchedBefore
    }
    static var appLink : String {
        get{
            if let appLink = UserDefaults.standard.value(forKey: DataKey.appLink.rawValue) as? String{
                return appLink
            }else{
                return ""
            }
        }set{
            let useDef = UserDefaults.standard
            useDef.setValue(newValue, forKey: DataKey.appLink.rawValue)
        }
    }
    static var currentUserType : String {
        get{
            if let userDef = UserDefaults.standard.value(forKey: DataKey.currentUserType.rawValue) as? String{
                return userDef
            }else{
                return ""
            }
        }set{
            let useDef = UserDefaults.standard
            useDef.setValue(newValue, forKey: DataKey.currentUserType.rawValue)
        }
    }
    static var profileType: Int {
        get {
            if let userType = UserDefaults.standard.value(forKey: DataKey.profileType.rawValue) as? Int {
                return userType
            } else {
                return 0
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.profileType.rawValue)
        }
    }
    static var gender: String {
        get {
            if let gender = UserDefaults.standard.value(forKey: DataKey.gender.rawValue) as? String {
                return gender
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.gender.rawValue)
        }
    }
    static var minAge: Int {
        get {
            if let minAge = UserDefaults.standard.value(forKey: DataKey.minAge.rawValue) as? Int {
                return minAge
            } else {
                return 0
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.minAge.rawValue)
        }
    }
    static var maxAge: Int {
        get {
            if let maxAge = UserDefaults.standard.value(forKey: DataKey.maxAge.rawValue) as? Int {
                return maxAge
            } else {
                return 0
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.maxAge.rawValue)
        }
    }
    static var deviceId: String {
        get {
            if let deviceId = UserDefaults.standard.value(forKey: DataKey.deviceId.rawValue) as? String {
                return deviceId
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.deviceId.rawValue)
        }
    }
    static var deviceType: String {
        get {
            if let deviceType = UserDefaults.standard.value(forKey: DataKey.deviceType.rawValue) as? String {
                return deviceType
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.deviceType.rawValue)
        }
    }
    static var profilePic: String {
        get {
            if let profilePic = UserDefaults.standard.value(forKey: DataKey.profilePic.rawValue) as? String {
                return profilePic
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.profilePic.rawValue)
        }
    }
    static var imgPath: String {
        get {
            if let path = UserDefaults.standard.value(forKey: DataKey.imgPath.rawValue) as? String {
                return path
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.imgPath.rawValue)
        }
    }
    static var deviceToken: String {
        get {
            if let profilePic = UserDefaults.standard.value(forKey: DataKey.deviceToken.rawValue) as? String {
                return profilePic
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.deviceToken.rawValue)
        }
    }
    static var email_otp: String {
        get {
            if let email_otp = UserDefaults.standard.value(forKey: DataKey.email_otp.rawValue) as? String {
                return email_otp
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.email_otp.rawValue)
        }
    }
    static var firstName: String {
        get {
            if let firstName = UserDefaults.standard.value(forKey: DataKey.firstName.rawValue) as? String {
                return firstName
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.firstName.rawValue)
        }
    }
    static var lastName: String {
            get {
                if let lastName = UserDefaults.standard.value(forKey: DataKey.lastName.rawValue) as? String {
                    return lastName
                } else {
                    return ""
                }
            } set {
                UserDefaults.standard.setValue(newValue, forKey: DataKey.lastName.rawValue)
            }
        }
    static var user_ID: Int {
        get {
            if let userId = UserDefaults.standard.value(forKey: DataKey.user_ID.rawValue) as? Int {
                return userId
            } else {
                return 0
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.user_ID.rawValue)
        }
    }
    static var LoginToken: String {
        get {
            if let token = UserDefaults.standard.value(forKey: DataKey.LoginToken.rawValue) as? String {
                return token
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.LoginToken.rawValue)
        }
    }
    static var FCMToken: String {
        get {
            if let token = UserDefaults.standard.value(forKey: DataKey.FCMToken.rawValue) as? String {
                return token
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.FCMToken.rawValue)
        }
    }
    static var IsEmailVerify: Bool {
        get {
            if let IsEmailVerify = UserDefaults.standard.value(forKey: DataKey.IsEmailVerify.rawValue) as? Bool {
                return IsEmailVerify
            } else {
                return false
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.IsEmailVerify.rawValue)
        }
    }
    static var userType: String {
        get {
            if let userType = UserDefaults.standard.value(forKey: DataKey.userType.rawValue) as? String {
                return userType
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.userType.rawValue)
        }
    }
    static var socialType: String {
        get {
            if let socialType = UserDefaults.standard.value(forKey: DataKey.socialType.rawValue) as? String {
                return socialType
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.socialType.rawValue)
        }
    }
    static var socialId: String {
        get {
            if let socialId = UserDefaults.standard.value(forKey: DataKey.socialId.rawValue) as? String {
                return socialId
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.socialId.rawValue)
        }
    }
    static var language: String {
        get {
            if let language = UserDefaults.standard.value(forKey: DataKey.language.rawValue) as? String {
                return language
            } else {
                return "english"
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.language.rawValue)
        }
    }
    static var error: String {
        get {
            if let token = UserDefaults.standard.value(forKey: DataKey.error.rawValue) as? String {
                return token
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.error.rawValue)
        }
    }
    static var isComplete: Int {
        get {
            if let token = UserDefaults.standard.value(forKey: DataKey.isComplete.rawValue) as? Int{
                return token
            } else {
                return 0
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.isComplete.rawValue)
        }
    }
    
    static var phone: String {
        get {
            if let token = UserDefaults.standard.value(forKey: DataKey.phone.rawValue) as? String {
                return token
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.phone.rawValue)
        }
    }
    static var email: String {
        get {
            if let token = UserDefaults.standard.value(forKey: DataKey.email.rawValue) as? String {
                return token
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.email.rawValue)
        }
    }
    static var inviteCode: String {
        get {
            if let code = UserDefaults.standard.value(forKey: DataKey.inviteCode.rawValue) as? String {
                return code
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.inviteCode.rawValue)
        }
    }
    static var isNotification: Bool {
        get {
            if let isNotification = UserDefaults.standard.value(forKey: DataKey.isNotification.rawValue) as? Bool {
                return isNotification
            } else {
                return false
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.isNotification.rawValue)
        }
    }
    static var createdAt: String {
        get {
            if let createdAt = UserDefaults.standard.value(forKey: DataKey.createdAt.rawValue) as? String {
                return createdAt
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.createdAt.rawValue)
        }
    }
    static var isSubscription: Bool {
        get {
            if let isSubscription = UserDefaults.standard.value(forKey: DataKey.isSubscription.rawValue) as? Bool {
                return isSubscription
            } else {
                return false
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.isSubscription.rawValue)
        }
    }
    static var isUserActive: String {
        get {
            if let isUserActive = UserDefaults.standard.value(forKey: DataKey.isUserActive.rawValue) as? String {
                return isUserActive
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.isUserActive.rawValue)
        }
    }
    static var choices: [Choice] {
        get {
//            if let choices = UserDefaults.standard.value(forKey: DataKey.choices.rawValue) as? [Choice] {
//                return choices
//            } else {
//                return []
//            }
            if let data = UserDefaults.standard.object(forKey: DataKey.choices.rawValue) as? Data,
               let choices = try? JSONDecoder().decode([Choice].self, from: data) {
                return choices
            } else {
                return []
            }
        } set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: DataKey.choices.rawValue)
            }
//            UserDefaults.standard.setValue(newValue, forKey: DataKey.choices.rawValue)
        }
    }
//    static var choices: Choice {
//        get {
//            if let choices = UserDefaults.standard.value(forKey: DataKey.choices.rawValue) as? Choice {
//                return choices
//            } else {
//                return Choice()
//            }
//        } set {
//            UserDefaults.standard.setValue(newValue, forKey: DataKey.choices.rawValue)
//        }
//    }
    static var categories: [CategoriesData] {
        get {
//            if let categories = UserDefaults.standard.value(forKey: DataKey.categories.rawValue) as? [Category] {
//                return categories
//            } else {
//                return []
//            }
            if let data = UserDefaults.standard.object(forKey: DataKey.categories.rawValue) as? Data,
               let categories = try? JSONDecoder().decode([CategoriesData].self, from: data) {
                return categories
            } else {
                return []
            }
        } set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: DataKey.categories.rawValue)
            }
//            UserDefaults.standard.setValue(newValue, forKey: DataKey.categories.rawValue)
        }
    }
    static var token: Int {
        get {
            if let token = UserDefaults.standard.value(forKey: DataKey.token.rawValue) as? Int {
                return token
            } else {
                return 0
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.token.rawValue)
        }
    }
    static var password: String {
        get {
            if let token = UserDefaults.standard.value(forKey: DataKey.password.rawValue) as? String {
                return token
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.password.rawValue)
        }
    }
    
    static var IsLogin: Bool {
        get {
            if let token = UserDefaults.standard.value(forKey: DataKey.IsLogin.rawValue) as? Bool {
                return token
            } else {
                return false
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.IsLogin.rawValue)
        }
    }
    static var IsVisitedAffFullScreen: Bool {
        get {
            if let IsVisitedAffFullScreen = UserDefaults.standard.value(forKey: DataKey.IsVisitedAffFullScreen.rawValue) as? Bool {
                return IsVisitedAffFullScreen
            } else {
                return false
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.IsVisitedAffFullScreen.rawValue)
        }
    }
    static var isSilentAff: Bool {
        get {
            if let isSilentAff = UserDefaults.standard.value(forKey: DataKey.isSilentAff.rawValue) as? Bool {
                return isSilentAff
            } else {
                return false
            }
        } set {
            UserDefaults.standard.setValue(newValue, forKey: DataKey.isSilentAff.rawValue)
        }
    }
}
