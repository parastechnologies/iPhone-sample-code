//
//  ProfileModes.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 04/03/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import Foundation


// MARK: - InsterestsModel
struct InsterestsModel: APIModel {
    let status, message: String?
    let data: [InsterestCategoryModel]?
}

// MARK: - Datum
struct InsterestCategoryModel: Codable {
    let interestsCategoryID, interestsCategoryName: String?
    let interestsData: [InsterestModel]?

    enum CodingKeys: String, CodingKey {
        case interestsCategoryID = "Interests_Category_Id"
        case interestsCategoryName = "Interests_Category_Name"
        case interestsData
    }
}
// MARK: - Datum
struct InsterestModel: Codable {
    let interestID, interestsCategoryID, interestName, interestsIcon: String?
    let interestStatus: String?
    let interestDate: String?

    enum CodingKeys: String, CodingKey {
        case interestID = "Interest_Id"
        case interestsCategoryID = "Interests_Category_Id"
        case interestName = "Interest_Name"
        case interestsIcon = "Interests_Icon"
        case interestStatus = "Interest_Status"
        case interestDate = "Interest_Date"
    }
}

// MARK: - AboutMeResponse
struct AboutMeResponse: APIModel {
    let status, message: String?
    let data: AboutMeModel?
}

// MARK: - DataClass
struct AboutMeModel: Codable {
    var personalInterest : [InsterestModel]?
    var personalCareerGoal: [GoalModel]?
    var biography: String?
}

// MARK: - Encode/decode helpers
