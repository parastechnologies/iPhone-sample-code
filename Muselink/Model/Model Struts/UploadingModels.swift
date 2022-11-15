//
//  UploadingModels.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 04/03/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import Foundation

// MARK: - GoalsModel
struct GoalsModel: APIModel {
    let status, message: String?
    let data: [GoalModel]?
}
// MARK: - Datum
struct GoalModel: Codable,Equatable {
    let goalID, goalName,GoalIcon, goalStatus, goalDate: String?

    enum CodingKeys: String, CodingKey {
        case goalID = "Goal_Id"
        case goalName = "Goal_Name"
        case GoalIcon = "Goal_Icon"
        case goalStatus = "Goal_Status"
        case goalDate = "Goal_Date"
    }
}
// MARK: - RolesModel
struct RolesModel: APIModel {
    let status, message: String?
    let data: [RoleModel]?
    let dailyTips: DailyTips?
}
// MARK: - Datum
struct RoleModel: Codable,Equatable  {
    let projectRoleID, roleName, projectRoleStatus, projectRoleDate: String?

    enum CodingKeys: String, CodingKey {
        case projectRoleID     = "Project_Role_Id"
        case roleName          = "Role_Name"
        case projectRoleStatus = "Project_Role_Status"
        case projectRoleDate   = "Project_Role_Date"
    }
}
// MARK: - DailyTips
struct DailyTips: Codable {
    let dailyTipsID, name, createdDate: String?

    enum CodingKeys: String, CodingKey {
        case dailyTipsID = "Daily_Tips_Id"
        case name = "Name"
        case createdDate = "Created_Date"
    }
}

// MARK: - Welcome
struct UploadSongResponseModel: APIModel {
    let status, message: String?
    let data: AudioModel?
}

// MARK: - CheckUploadCountModel
struct CheckUploadCountModel: APIModel {
    let status, message: String?
    let data: Int?
}
