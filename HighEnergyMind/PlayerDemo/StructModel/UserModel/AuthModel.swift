//
//  AuthModel.swift
//  KeyChange
//
//  Created by mac11 on 09/05/23.
//

import Foundation

// MARK: - SignUpModel
struct CommonModel: APIModel {
    var errorMessage: String?
    var success: Bool?
    var message: String?
    var code: Int?
}

// MARK: - LoginModel
struct LoginModel: APIModel {
//    var response: Bool?
    
//    var errorMessage: String?
//    var success: Bool?
//    var message: String?
//    var data: [CategoriesData]?
//    var code: Int?
    
    var errorMessage: String?
    var success: Bool?
    var message, token: String?
    var data: LoginData?
    var code: Int?
}

// MARK: - LoginData
struct LoginData: Codable {
    var notifyReminder: NotifyReminder?
    
    var id: Int?
        var firstName: String?
        var lastName: String?
        var email, password: String?
        var userImg: String?
        var gender: String?
        var minAge, maxAge: Int?
        var deviceID, deviceType, deviceToken, emailOtp: String?
        var isEmailVerify: Int?
        var userType, socialType: String?
        var socialID: String?
        var language, inviteCode: String?
        var isNotification: Int?
        var paymentToken: String?
        var subscriptionStatus, isUserActive, isSubscription, subscriptionStartDate: String?
        var createdAt: String?
        var userImgPath: String?
        var choices: [Choice]?
        var categories: [CategoriesData]?

        enum CodingKeys: String, CodingKey {
            case id
            case firstName = "first_name"
            case lastName = "last_name"
            case email, password
            case userImg = "user_img"
            case gender
            case minAge = "min_age"
            case maxAge = "max_age"
            case deviceID = "device_id"
            case deviceType = "device_type"
            case deviceToken = "device_token"
            case emailOtp = "email_otp"
            case isEmailVerify = "is_email_verify"
            case userType = "user_type"
            case socialType = "social_type"
            case socialID = "social_id"
            case language
            case inviteCode = "invite_code"
            case isNotification = "is_notification"
            case paymentToken = "payment_token"
            case subscriptionStatus = "subscription_status"
            case isUserActive = "is_user_active"
            case isSubscription = "is_subscription"
            case subscriptionStartDate = "subscription_start_date"
            case createdAt = "created_at"
            case userImgPath = "user_img_path"
            case choices, categories, notifyReminder
        }
}

// MARK: - Category
struct Category: Codable {
//    var id: Int?
//    var categoryImg, categoryName, categoryStatus: String?
//    var subcategories: [SubCategoriesData]?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case categoryImg = "category_img"
//        case categoryName = "category_name"
//        case categoryStatus = "category_status"
//        case subcategories
//    }
    
    var id: Int?
    var categoryImg, categoryImgActive, categoryName, categoryStatus: String?
    var categoryImgPath, categoryImgActivePath: String?
    var subcategories: [SubCategoriesData]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryImg = "category_img"
        case categoryImgActive = "category_img_active"
        case categoryName = "category_name"
        case categoryStatus = "category_status"
        case categoryImgPath = "category_img_path"
        case categoryImgActivePath = "category_img_active_path"
        case subcategories
    }
}

//// MARK: - Subcategory
//struct Subcategory: Codable {
//    var id: Int?
//    var subCategoryImg, subCategoryName: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case subCategoryImg = "sub_category_img"
//        case subCategoryName = "sub_category_name"
//    }
//}

// MARK: - Choice
struct Choice: Codable {
//    var id: Int?
//    var choiceImg, choiceName: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case choiceImg = "choice_img"
//        case choiceName = "choice_name"
//    }
    
    var id: Int?
    var choiceImg, choiceImgActive, choiceName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case choiceImg = "choice_img"
        case choiceImgActive = "choice_img_active"
        case choiceName = "choice_name"
    }
}


// MARK: - CategoriesModel
struct CategoriesModel: APIModel {
//    var response: Int?
    var errorMessage: String?
    var success: Bool?
    var message: String?
    var data: [CategoriesData]?
    var code: Int?
}

// MARK: - Datum
struct CategoriesData: Codable {
//    var id: Int?
//    var categoryImg, categoryName, categoryStatus: String?
//    var categoryImgPath: String?
//
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case categoryImg = "category_img"
//        case categoryName = "category_name"
//        case categoryStatus = "category_status"
//        case categoryImgPath = "category_img_path"
//    }
    
    var id: Int?
    var categoryImg, categoryImgActive, categoryName, categoryStatus: String?
    var categoryImgPath, categoryImgActivePath: String?
    var subcategories: [SubCategoriesData]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryImg = "category_img"
        case categoryImgActive = "category_img_active"
        case categoryName = "category_name"
        case categoryStatus = "category_status"
        case categoryImgPath = "category_img_path"
        case categoryImgActivePath = "category_img_active_path"
        case subcategories
    }
}

// MARK: - SubCategoriesModel
struct SubCategoriesModel: APIModel {
    var errorMessage: String?
    var success: Bool?
    var message: String?
    var data: [SubCategoriesData]?
    var code: Int?
}

// MARK: - SubCategoriesData
struct SubCategoriesData: Codable {
    var id: Int?
    var subCategoryImg, subCategoryName: String?
    var categoryID: Int?
    var subCategoryImgPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case subCategoryImg = "sub_category_img"
        case subCategoryName = "sub_category_name"
        case categoryID = "category_id"
        case subCategoryImgPath = "sub_category_img_path"
    }
}

// MARK: - ChoicesModel
struct ChoicesModel: APIModel {
    var errorMessage: String?
    var success: Bool?
    var message: String?
    var data: [ChoicesData]?
    var code: Int?
}

// MARK: - ChoicesData
struct ChoicesData: Codable {
//    var id: Int?
//    var choiceImg, choiceName: String?
//    var choiceImgPath: String?
//    var isSelected          : Bool = false
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case choiceImg = "choice_img"
//        case choiceName = "choice_name"
//        case choiceImgPath = "choice_img_path"
//    }
    
    var id: Int?
    var choiceImg, choiceImgActive, choiceName: String?
    var choiceImgPath, choiceImgActivePath: String?
    var isSelected          : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case choiceImg = "choice_img"
        case choiceImgActive = "choice_img_active"
        case choiceName = "choice_name"
        case choiceImgPath = "choice_img_path"
        case choiceImgActivePath = "choice_img_active_path"
        }
}

// MARK: - EmailVerifyModel
struct EmailVerifyModel: APIModel {
    var errorMessage: String?
    var success: Bool?
    var message: String?
    var data: SignUpData?
    var token : Int?
    var code: Int?
}

// MARK: - SignUpModel
struct SignUpModel: APIModel {
    var errorMessage: String?
    var success: Bool?
    var message: String?
    var data: SignUpData?
    var token : String?
    var code: Int?
}

// MARK: - SignUpData
struct SignUpData: Codable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var email, password: String?
    var userImg: String?
    var gender: String?
    var minAge, maxAge: Int?
    var deviceID: String?
    var deviceType: String?
    var deviceToken: String?
    var emailOtp: String?
    var isEmailVerify: Int?
    var userType, socialType: String?
    var socialID: String?
    var language: String?
    var isNotification: Int?
    var isUserActive, isSubscription, createdAt: String?
    var userImgPath: String?
    var choices : [Choice]
    var categories: [CategoriesData]?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, password
        case userImg = "user_img"
        case gender
        case minAge = "min_age"
        case maxAge = "max_age"
        case deviceID = "device_id"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case emailOtp = "email_otp"
        case isEmailVerify = "is_email_verify"
        case userType = "user_type"
        case socialType = "social_type"
        case socialID = "social_id"
        case language
        case isNotification = "is_notification"
        case isUserActive = "is_user_active"
        case isSubscription = "is_subscription"
        case createdAt = "created_at"
        case userImgPath = "user_img_path"
        case choices, categories
    }
}

struct SuggestAffirmationModel: APIModel {
    var errorMessage: String?
    var success: Bool?
    var message: String?
    var data: SuggestAffirmationData?
    var code: Int?
}

// MARK: - DataClass
struct SuggestAffirmationData: Codable {
    var id: Int?
    var suggestName, suggestEmail, suggestMsg: String?
    var userID: Int?
    var createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case suggestName = "suggest_name"
        case suggestEmail = "suggest_email"
        case suggestMsg = "suggest_msg"
        case userID = "user_id"
        case createdAt = "created_at"
    }
}

// MARK: - Get Reminder Model below

//struct Welcome: Codable {
//    var success: Bool?
//    var message: String?
//    var data: DataClass?
//    var code: Int?
//}
//
//// MARK: - DataClass
//struct DataClass: Codable {
//    var id: Int?
//    var firstName, lastName, email, password: String?
//    var userImg, gender: String?
//    var minAge, maxAge: Int?
//    var deviceID: String?
//    var deviceType: String?
//    var deviceToken: String?
//    var emailOtp: String?
//    var isEmailVerify: Int?
//    var userType, socialType: String?
//    var socialID: String?
//    var language, inviteCode: String?
//    var isNotification: Int?
//    var isUserActive, isSubscription, createdAt: String?
//    var userImgPath: String?
//    var choices: [Choice]?
//    var categories: [Category]?
//    var notifyReminder: NotifyReminder?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case email, password
//        case userImg = "user_img"
//        case gender
//        case minAge = "min_age"
//        case maxAge = "max_age"
//        case deviceID = "device_id"
//        case deviceType = "device_type"
//        case deviceToken = "device_token"
//        case emailOtp = "email_otp"
//        case isEmailVerify = "is_email_verify"
//        case userType = "user_type"
//        case socialType = "social_type"
//        case socialID = "social_id"
//        case language
//        case inviteCode = "invite_code"
//        case isNotification = "is_notification"
//        case isUserActive = "is_user_active"
//        case isSubscription = "is_subscription"
//        case createdAt = "created_at"
//        case userImgPath = "user_img_path"
//        case choices, categories, notifyReminder
//    }
//}
//
//// MARK: - Category
//struct Category: Codable {
//    var id: Int?
//    var categoryImg, categoryName, categoryStatus: String?
//    var subcategories: [Subcategory]?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case categoryImg = "category_img"
//        case categoryName = "category_name"
//        case categoryStatus = "category_status"
//        case subcategories
//    }
//}
//
//// MARK: - Subcategory
//struct Subcategory: Codable {
//    var id: Int?
//    var subCategoryImg, subCategoryName: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case subCategoryImg = "sub_category_img"
//        case subCategoryName = "sub_category_name"
//    }
//}
//
//// MARK: - Choice
//struct Choice: Codable {
//    var id: Int?
//    var choiceImg, choiceName: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case choiceImg = "choice_img"
//        case choiceName = "choice_name"
//    }
//}
//
// MARK: - NotifyReminder
struct NotifyReminder: Codable {
    var id: Int?
    var days: [String]?
    var startTime, endTime: String?
    var timesPerDay, userID: Int?

    enum CodingKeys: String, CodingKey {
        case id, days
        case startTime = "start_time"
        case endTime = "end_time"
        case timesPerDay = "times_per_day"
        case userID = "user_id"
    }
}

// MARK: - PagesContentModel
struct PagesContentModel: APIModel {
    var errorMessage: String?
    var success: Bool?
    var message: String?
    var data: PagesContentData?
    var code: Int?
}

// MARK: - DataClass
struct PagesContentData: Codable {
    var id: Int?
    var slug, description: String?
}


// MARK: - ChangeAffImgModel
struct ChangeAffImgModel: APIModel {
    var errorMessage: String?
    var success: Bool?
    var message: String?
    var data: ChangeAffImgData?
    var code: Int?
}

// MARK: - ChangeAffImgData
struct ChangeAffImgData: Codable {
    var id, affirmationID: Int?
    var affirmationList, affirmationImg: String?
    var userID: Int?
    var createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case affirmationID = "affirmation_id"
        case affirmationList = "affirmation_list"
        case affirmationImg = "affirmation_img"
        case userID = "user_id"
        case createdAt = "created_at"
    }
}

// MARK: - FollowUsModel
struct FollowUsModel: APIModel {
    var errorMessage: String?
    var success: Bool?
    var message: String?
    var data: [FollowUsData]?
    var code: Int?
}

// MARK: - FollowUsData
struct FollowUsData: Codable {
    var id: Int?
    var socialLinkTitle: String?
    var linkName: String?
    var linkImg: String?

    enum CodingKeys: String, CodingKey {
        case id
        case socialLinkTitle = "social_link_title"
        case linkName = "link_name"
        case linkImg = "link_img"
    }
}

// MARK: - NotificationsModel
struct NotificationsModel: APIModel{
    var errorMessage: String?
    var success: Bool?
    var message: String?
    var data: [NotificationsData]?
    var code: Int?
}

// MARK: - NotificationsData
struct NotificationsData: Codable {
    var id: Int?
    var notificationTitle, notificationMsg: String?
    var senderID, receiverID, affID: Int?
    var notificationType, notificationReadStatus, createdAt: String?
    var categoryImgPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case notificationTitle = "notification_title"
        case notificationMsg = "notification_msg"
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case affID = "aff_id"
        case notificationType = "notification_type"
        case notificationReadStatus = "notification_read_status"
        case createdAt = "created_at"
        case categoryImgPath = "category_img_path"
    }
}
