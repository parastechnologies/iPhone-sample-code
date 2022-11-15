//
//  HomeModels.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 27/04/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

// MARK: - CheckSubscriptionResponseModel
struct CheckSubscriptionResponseModel: APIModel {
    let status, message: String?
    let data: SubscriptionStatusModel?
}

// MARK: - DataClass
struct SubscriptionStatusModel: Codable {
    let subscriptionStatus: Int?
}


// MARK: - UserProfileResponseModel
struct UserProfileResponseModel: APIModel {
    let status, message: String?
    let data: [UserProfileModel]?
    let subscriptionStatus: Int?
}

// MARK: - Datum
struct UserProfileModel: Codable {
    let id: String?
    let userName, profileImage, biography: String?
    var favoriteStaus: Int?
    let personalInterest: [InsterestModel]?
    let careerGoals: [GoalModel]?

    enum CodingKeys: String, CodingKey {
        case id
        case userName = "User_Name"
        case profileImage = "Profile_Image"
        case biography = "Biography"
        case favoriteStaus = "Favorite_Staus"
        case personalInterest = "Personal_Interest"
        case careerGoals = "Career_Goals"
    }
}
// MARK: - AudioListResponse
struct AudioListResponse: APIModel {
    let status, message: String?
    let data: [AudioModel]?
    let profileImage:String?
    let subscriptionStatus, dmCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case status, message, data, subscriptionStatus, profileImage
        case dmCount = "DMCount"
    }
}

struct AudioModel: Codable {
    let audioID, userID, fullAudio,recordingVideo , trimAudio: String?
    let datumDescription, descriptionColor, notificationStatus, audioDate: String?
    var favoriteAudio: Int?

    enum CodingKeys: String, CodingKey {
        case audioID = "Audio_Id"
        case userID = "User_Id"
        case fullAudio = "Full_Audio"
        case trimAudio = "Trim_Audio"
        case datumDescription = "Description"
        case descriptionColor = "Description_Color"
        case notificationStatus = "Notification_Status"
        case audioDate = "Audio_Date"
        case recordingVideo = "Recording_Video"
        case favoriteAudio
    }
}

// MARK: - AudioDescriptionResponseModel
struct AudioDescriptionResponseModel: APIModel {
    let status, message: String?
    let data: AudioDescriptionData?
}

// MARK: - DataClass
struct AudioDescriptionData: Codable {
    let dataDescription, descriptionColor: String?
    let projectRoles: [ProjectRoleModel]?
    let projectGoals: [ProjectGoalModel]?

    enum CodingKeys: String, CodingKey {
        case dataDescription = "Description"
        case descriptionColor = "Description_Color"
        case projectRoles, projectGoals
    }
}

// MARK: - ProjectGoal
struct ProjectGoalModel: Codable {
    let userGoalID, audioID, goalID, userGoalDate: String?
    let goalName, goalIcon, goalStatus, goalDate: String?

    enum CodingKeys: String, CodingKey {
        case userGoalID = "User_Goal_Id"
        case audioID = "Audio_Id"
        case goalID = "Goal_Id"
        case userGoalDate = "UserGoal_Date"
        case goalName = "Goal_Name"
        case goalIcon = "Goal_Icon"
        case goalStatus = "Goal_Status"
        case goalDate = "Goal_Date"
    }
}

// MARK: - ProjectRole
struct ProjectRoleModel: Codable {
    let userRoleID, audioID, roleID, userRoleDate: String?
    let projectRoleID: String?
    let roleName: String?
    let projectRoleIcon: String?
    let projectRoleStatus: String?
    let projectRoleDate: String?

    enum CodingKeys: String, CodingKey {
        case userRoleID = "User_Role_Id"
        case audioID = "Audio_Id"
        case roleID = "Role_Id"
        case userRoleDate = "User_Role_Date"
        case projectRoleID = "Project_Role_Id"
        case roleName = "Role_Name"
        case projectRoleIcon = "ProjectRole_Icon"
        case projectRoleStatus = "Project_Role_Status"
        case projectRoleDate = "Project_Role_Date"
    }
}

// MARK: - AudioDescriptionResponseModel
struct CommentResponseModel: Decodable {
    let response, message: String?
    let data: CommentResponse?

    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case message, data
    }
}

// MARK: - Datum
struct CommentModel: Codable {
    let commentID, userID, musicID, comment: String?
    let createdDate, userName: String?
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case commentID, userID, musicID, comment, createdDate
        case userName = "User_Name"
        case profileImage = "Profile_Image"
    }
}
enum CommentResponse: Decodable {
    case single(CommentModel)
    case array([CommentModel])
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(CommentModel.self) {
            self = .single(x)
            return
        }
        if let x = try? container.decode([CommentModel].self) {
            self = .array(x)
            return
        }
        throw DecodingError.typeMismatch(CommentModel.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Rating"))
    }
}
