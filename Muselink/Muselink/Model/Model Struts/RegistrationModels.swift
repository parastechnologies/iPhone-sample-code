//
//  RegistrationModels.swift
//  Muselink
//
//  Created by HarishParas on 18/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import Foundation

// MARK: - LogInModel
struct LogInModel: APIModel {    
    let status, message: String?
    let data: LogInDataModel?
    let token : String?
}

// MARK: - DataClass
struct  LogInDataModel: Codable {
    let id, email: String?
    let phone, socailID: String?
    let password, userName, profileImage, countryName: String?
    let accountStatus, biography, soundFileStatus, directMessageStatus: String?
    let newAdmirerNotificationStatus, newMatchNotificationStatus, newMessageNotificationStatus, newMatchFileNotificationStatus: String?
    let signUpType, deviceToken, deviceType, chatUniqNumber: String?
    let onlineStatus, createdDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case email = "Email"
        case phone
        case socailID = "Socail_Id"
        case password
        case userName = "User_Name"
        case profileImage = "Profile_Image"
        case countryName = "Country_Name"
        case accountStatus = "Account_Status"
        case biography = "Biography"
        case soundFileStatus = "Sound_File_Status"
        case directMessageStatus = "Direct_Message_Status"
        case newAdmirerNotificationStatus = "New_Admirer_Notification_Status"
        case newMatchNotificationStatus = "New_Match_Notification_Status"
        case newMessageNotificationStatus = "New_Message_Notification_Status"
        case newMatchFileNotificationStatus = "New_Match_File_Notification_Status"
        case signUpType = "SignUp_Type"
        case deviceToken = "Device_Token"
        case deviceType = "Device_Type"
        case chatUniqNumber = "Chat_Uniq_Number"
        case onlineStatus = "Online_Status"
        case createdDate = "Created_Date"
    }
}
// MARK: - SignUpModel
struct SignUpModel: APIModel {
    let status, message: String?
    let data: LogInDataModel?
    let token: String?
}

// MARK: - SignUpModel
struct CommanApiModel: APIModel {
    let status: String?
    let message: String?
}
