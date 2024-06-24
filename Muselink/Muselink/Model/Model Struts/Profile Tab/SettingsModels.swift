//
//  SettingsModels.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 14/04/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit


// MARK: - SettingDetailsModel
struct SettingDetailsResponse: APIModel {
    let status, message: String?
    let data: SettingDetailsModel?
}

// MARK: - DataClass
struct SettingDetailsModel: Codable {
    let id: String?
    var email: String?
    var phone, socailID: String?
    var password, userName, accountStatus, biography: String?
    var soundFileStatus, directMessageStatus, newAdmirerNotificationStatus, newMatchNotificationStatus: String?
    var newMessageNotificationStatus, newMatchFileNotificationStatus, signUpType, deviceToken: String?
    var deviceType, createdDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case email = "Email"
        case phone
        case socailID = "Socail_Id"
        case password
        case userName = "User_Name"
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
        case createdDate = "Created_Date"
    }
}



// MARK: - ListOfBlockUserResponse
struct ListOfBlockUserResponse: APIModel {
    let status, message: String?
    let data: [BlockUserModel]?
}

// MARK: - Datum
struct BlockUserModel: Codable {
    let blockedAccountID, fromID, toID, blockStatus: String?
    let blockDate, id, email: String?
    let phone, socailID: String?
    let password: String?
    let userName: String?
    let accountStatus: String?
    let biography: String?
    let soundFileStatus, directMessageStatus, newAdmirerNotificationStatus, newMatchNotificationStatus: String?
    let newMessageNotificationStatus, newMatchFileNotificationStatus, signUpType, deviceToken: String?
    let deviceType, createdDate: String?

    enum CodingKeys: String, CodingKey {
        case blockedAccountID = "BlockedAccountId"
        case fromID = "From_Id"
        case toID = "To_Id"
        case blockStatus = "Block_Status"
        case blockDate = "Block_Date"
        case id
        case email = "Email"
        case phone
        case socailID = "Socail_Id"
        case password
        case userName = "User_Name"
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
        case createdDate = "Created_Date"
    }
}
