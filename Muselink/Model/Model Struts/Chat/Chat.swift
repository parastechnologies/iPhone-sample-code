//Chat.swift
/*
 * ChatUI
 * Created by penumutchu.prasad@gmail.com on 07/04/19
 * Is a product created by abnboys
 * For the ChatUI in the ChatUI
 
 * Here the permission is granted to this file with free of use anywhere in the IOS Projects.
 * Copyright © 2018 ABNBoys.com All rights reserved.
 */

import UIKit

struct Chat: Codable {
    
    var user_name: String!
    var user_image_url: String!
    var is_sent_by_me: Bool
    var text: String!
}
// MARK: - ChatResponseModel
struct ChatResponseModel: APIModel {
    var status: String?
    let message: String?
    let data: [ChatModel]?
}

// MARK: - Datum
struct ChatModel: Codable {
    let senderName: String?
    let senderID: String?
    let receiverName: String?
    let receiverID, message, createdOn, messageType: String?
    
    enum CodingKeys: String, CodingKey {
        case senderName
        case senderID = "sender_id"
        case receiverName
        case receiverID = "receiver_id"
        case message
        case createdOn = "created_on"
        case messageType = "MessageType"
    }
}


// MARK: - ChatUserListResponseModel
struct ChatUserListResponseModel: APIModel {
    let status, message: String?
    let data: [ChatUserModel]?
}

// MARK: - Datum
struct ChatUserModel: Codable {
    let senderName: String?
    let senderID: String?
    let senderProfilePicture, onlineStatus, receiverName: String?
    let receiverID: String?
    let receiverProfilePicture: String?
    let message: String?
    let readStatus, createdOn, hash: String?
    let unreadCount: Int?
    let senderOfflineTime, recieverOfflineTime: String?
    
    enum CodingKeys: String, CodingKey {
        case senderName
        case senderID = "sender_id"
        case senderProfilePicture = "sender_profile_picture"
        case onlineStatus, receiverName
        case receiverID = "receiver_id"
        case receiverProfilePicture = "receiver_profile_picture"
        case message, readStatus
        case createdOn = "created_on"
        case hash
        case unreadCount = "UnreadCount"
        case senderOfflineTime, recieverOfflineTime
    }
}

// MARK: - NotificationListResponseModel
struct NotificationListResponseModel: APIModel {
    let status, message: String?
    let data: [NotificationModel]?
}

// MARK: - Datum
struct NotificationModel: Codable {
    let notificationID, message, notificationDate: String?
    let userName, profileImage: String?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case notificationID = "Notification_Id"
        case message = "Message"
        case notificationDate = "Notification_Date"
        case userName = "User_Name"
        case profileImage = "Profile_Image"
        case id
    }
}

struct ChatImageModel: APIModel {
    let status, message, fileName: String?
}
