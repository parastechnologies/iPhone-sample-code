//
//  ApiEndPintManager.swift
//  Muselink
//
//  Created by HarishParas on 18/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import Firebase

//Registration Apis
extension NetworkManager {
    func Sign_up(phone:String = "",email:String = "",signUpType:String,password:String = "",socialID:String = "",countryName:String,completion: @escaping ((Result<SignUpModel,APIError>) -> Void)) {
        let param = [
            "email"            : email,
            "SignUpType"       : signUpType,
            "phone"            : phone,
            "password"         : password,
            "Socailid"         : socialID,
            "deviceToken"      : Messaging.messaging().fcmToken ?? "",
            "deviceType"       : "iOS",
            "countryName"      :countryName]
        handleAPICalling(request: .signUp(param: param), completion: completion)
    }
    func login(phone:String = "",email:String = "",logInType:String,password:String = "",socialID:String = "",completion: @escaping ((Result<LogInModel,APIError>) -> Void)) {
        let param = [
            "email"            : email,
            "logInType"        : logInType,
            "phone"            : phone,
            "password"         : password,
            "Socailid"         : socialID,
            "deviceToken"      : Messaging.messaging().fcmToken ?? "",
            "deviceType"       : "iOS"]
        handleAPICalling(request: .logIn(param: param), completion: completion)
    }
    func resendOTP(phone:String = "",completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "phone"           : phone ]
        handleAPICalling(request: .resendOTP(param: param), completion: completion)
    }
    func forgetPassword(email:String = "",completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "email"           : email ]
        handleAPICalling(request: .forgetPassword(param: param), completion: completion)
    }
    func verifyCode(phone:String = "",code:String = "",isSignUp:Bool,countryName:String,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "phone"       : phone,
            "otp"         : code,
            "verifyType"  : isSignUp ? "SignUp" : "logIn",
            "countryName" : countryName]
        handleAPICalling(request: .verifyCode(param: param), completion: completion)
    }
    func updateOnlieStatus(status:Bool,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "userId" : AppSettings.userID,
            "status" : status ? 1 : 0]
        handleAPICalling(request: .manageOnlieStatus(param: param), completion: completion)
    }
}

//Uploading Apis
extension NetworkManager{
    func uploadSound(roles:[RoleModel],goals:[GoalModel],locationTags:[String],description:String,descriptionColor:String,shortAudio:Data,fulludio:Data,recVideo:Data,completion: @escaping ((Result<UploadSongResponseModel,APIError>) -> Void),uploadProgress : @escaping (Double)->()) {
        var goalID = [String]()
        var roleID = [String]()
        for role in roles {
            roleID.append(role.projectRoleID ?? "0")
        }
        for goal in goals {
            goalID.append(goal.goalID ?? "0")
        }
        handleAPICalling(request: .uploadSound(userId: "\(AppSettings.userID)", fullAudio: fulludio, trimAudio: shortAudio, description: description, descriptionColor: descriptionColor, roleId: roleID, goalId: goalID, locationTags: locationTags,video:recVideo), completion: completion)
        handleMultipartProgress(completion: uploadProgress)
    }
    func checkForUploadingCount(completion: @escaping ((Result<CheckUploadCountModel,APIError>) -> Void)) {
        let param = ["userId" : AppSettings.userID]
        handleAPICalling(request: .checkUploadCount(param: param), completion: completion)
    }
}

//Profiles Apis
extension NetworkManager {
    func getSettingsDetails(completion: @escaping ((Result<SettingDetailsResponse,APIError>) -> Void)) {
        let param = ["userId" : AppSettings.userID]
        handleAPICalling(request: .settingsDetail(param: param), completion: completion)
    }
    func getListOfBlockedUsers(completion: @escaping ((Result<ListOfBlockUserResponse,APIError>) -> Void)) {
        let param = [
            "userId"      : AppSettings.userID]
        handleAPICalling(request: .settingsDetail(param: param), completion: completion)
    }
    func unblockUser(accountID:String,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "blockedAccountId" : accountID]
        handleAPICalling(request: .unBlockUser(param: param), completion: completion)
    }
    func updateNotificationSettings(type:PushNotificationType,status:Bool,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "notificationSettingType" : type.rawValue,
            "userId"                  : AppSettings.userID,
            "statusValue"             : status ? "1" : "0"] as [String : Any]
        handleAPICalling(request: .changeNotification(param: param), completion: completion)
    }
    func updateAccountPermissionSettings(type:PermissionType,status:String,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        switch type {
        case .explorer:
            let param = [
                "permissionsType" : type.rawValue,
                "userId"          : AppSettings.userID,
                "accountStatus"   : status ] as [String : Any]
            handleAPICalling(request: .changeAccountPermissionStatus(param: param), completion: completion)
        case .share:
            let param = [
                "permissionsType" : type.rawValue,
                "userId"          : AppSettings.userID,
                "soundFileStatus"   : status ] as [String : Any]
            handleAPICalling(request: .changeAccountPermissionStatus(param: param), completion: completion)
        case .directMessage:
            let param = [
                "permissionsType" : type.rawValue,
                "userId"          : AppSettings.userID,
                "directMessageStatus"   : status ] as [String : Any]
            handleAPICalling(request: .changeAccountPermissionStatus(param: param), completion: completion)
        }
    }
    func submitSupport(type:SupportType,review:String,supportFile:Data,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "supportType" : type.rawValue,
            "userId"      : AppSettings.userID,
            "review"      : review ] as [String : Any]
        handleAPICalling(request: .submitSupport(param: param, supportFile: supportFile), completion: completion)
    }
    func changePassword(oldPassword:String,newPassword:String,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "userId"      : AppSettings.userID,
            "oldPassword" : oldPassword,
            "newPassword" : newPassword,
            "confirmPassword":newPassword] as [String : Any]
        handleAPICalling(request: .changePassword(param: param), completion: completion)
    }
    func changeUsername(username:String,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "userId"   : AppSettings.userID,
            "userName" : username] as [String : Any]
        handleAPICalling(request: .changeUsername(param: param), completion: completion)
    }
    func changeEmail(email:String,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "userId"   : AppSettings.userID,
            "email" : email] as [String : Any]
        handleAPICalling(request: .changeEmail(param: param), completion: completion)
    }
    func changePhoneNumber(phone:String,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "userId"   : AppSettings.userID,
            "phone" : phone] as [String : Any]
        handleAPICalling(request: .changePhoneNumber(param: param), completion: completion)
    }
    func getUploadedAudiolist(completion: @escaping ((Result<AudioListResponse,APIError>) -> Void)) {
        let param = [
            "userId"      : AppSettings.userID]
        handleAPICalling(request: .getVideoForUser(param: param), completion: completion)
    }
    func getAboutMe(completion: @escaping ((Result<AboutMeResponse,APIError>) -> Void)) {
        let param = [
            "userId"      : AppSettings.userID]
        handleAPICalling(request: .getAboutMe(param: param), completion: completion)
    }
    func getRoles(completion: @escaping ((Result<RolesModel,APIError>) -> Void)) {
        handleAPICalling(request: .roleList, completion: completion)
    }
    func getGoals(completion: @escaping ((Result<GoalsModel,APIError>) -> Void)) {
        handleAPICalling(request: .goallist, completion: completion)
    }
    func getInterests(completion: @escaping ((Result<InsterestsModel,APIError>) -> Void)) {
        handleAPICalling(request: .interestlist, completion: completion)
    }
    func editBiography(text:String,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "biography" : text,
            "userId"    : AppSettings.userID] as [String : Any]
        handleAPICalling(request: .editBiography(param: param), completion: completion)
    }
    func updateInterest(interest:[InsterestModel],completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let interestArr = interest.map({ (data) -> String in
            data.interestID ?? ""
        })
        let param = [
            "userId"      : AppSettings.userID,
            "interestsId" : interestArr.joined(separator: ",")] as [String : Any]
        handleAPICalling(request: .updateInterest(param: param), completion: completion)
    }
    func updateGoal(goals:[GoalModel],completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let goalArr = goals.map({ (data) -> String in
            data.goalID ?? ""
        })
        let param = [
            "userId" : AppSettings.userID,
            "goalId" : goalArr.joined(separator:",")] as [String : Any]
        handleAPICalling(request: .updateGoal(param: param), completion: completion)
    }
    func submitProfilePic(image:UIImage,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        handleAPICalling(request: .uploadProfilePic(userId: AppSettings.userID, image: image), completion: completion)
    }
    func removeAudio(audioID:Int,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "audioId" : audioID]
        handleAPICalling(request: .removeAudio(param: param), completion: completion)
    }
    func setAudioNotification(audioID:Int,status:Bool,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "statusValue" : status ? "1" : "0",
            "audioId"      : audioID] as [String : Any]
        handleAPICalling(request: .audioNotificationStatus(param: param), completion: completion)
    }
    func inviiteFriend(completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "userId"    : AppSettings.userID] as [String : Any]
        handleAPICalling(request: .inviteFriend(param: param), completion: completion)
    }
}

// Home Apis
extension NetworkManager {
    func downloadShortAudio(link:URL,completion: @escaping ((Result<URL,APIError>) -> Void)) {
        downloadAudio(link: link, completion: completion)
    }
    func getAudiolist(completion: @escaping ((Result<AudioListResponse,APIError>) -> Void)) {
        let param = [
            "userId" : AppSettings.userID]
        handleAPICalling(request: .getAllVideos(param: param), completion: completion)
    }
    func getAudioDescription(audioId:String,completion: @escaping ((Result<AudioDescriptionResponseModel,APIError>) -> Void)) {
        let param = [
            "audioId" : audioId]
        handleAPICalling(request: .getAudioDescription(param: param), completion: completion)
    }
    func giveLike(audioID:String,toID:String,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)){
        let param = [
            "audioId":audioID,
            "toId" : toID,
            "fromId" : AppSettings.userID] as [String : Any]
        handleAPICalling(request: .giveLike(param: param), completion: completion)
    }
    func getUserlist(completion: @escaping ((Result<UserProfileResponseModel,APIError>) -> Void)) {
        let param = [
            "userId" : AppSettings.userID]
        handleAPICalling(request: .getAllUsers(param: param), completion: completion)
    }
    func giveLikeToUser(toID:String,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)){
        let param = [
            "toId" : toID,
            "fromId" : AppSettings.userID] as [String : Any]
        handleAPICalling(request: .giveLikeToUser(param: param), completion: completion)
    }
    func sendDM(message:String,toID:String,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)){
        let param = [
            "message":message,
            "targetUserId" : toID,
            "sourceUserId" : AppSettings.userID] as [String : Any]
        handleAPICalling(request: .sendDM(param: param), completion: completion)
    }
    func search(searchType:String,type:String,text:String,completion: @escaping ((Result<AudioListResponse,APIError>) -> Void)){
        let param = [
            "searchType":searchType,
            "type" : type,
            "searchContent" : text] as [String : Any]
        handleAPICalling(request: .search(param: param), completion: completion)
    }
    func checkSubscription(completion: @escaping ((Result<CheckSubscriptionResponseModel,APIError>) -> Void)) {
        let param = [
            "userId" : AppSettings.userID]
        handleAPICalling(request: .checkSubscription(param: param), completion: completion)
    }
    func sendReport(audioID:String,reportText:String,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)){
        let param = [
            "audioId":audioID,
            "message" : reportText,
            "userId" : AppSettings.userID] as [String : Any]
        handleAPICalling(request: .reportOnAudio(param: param), completion: completion)
    }
}


// Premium
extension NetworkManager {
    func addSubscription(transcationID:String,PaymanetID:String,amount:String,product:String,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "userId" : AppSettings.userID,
            "paymentId":PaymanetID,
            "transactionId":transcationID,
            "amount":amount,
            "Product":product] as [String : Any]
        handleAPICalling(request: .addSubscription(param: param), completion: completion)
    }
}

//Chat Apis
extension NetworkManager {
    func getChatUserList(completion: @escaping ((Result<ChatUserListResponseModel,APIError>) -> Void)) {
        let param = [ "userId" : "\(AppSettings.userID)"]
        handleAPICalling(request: .getChatUserList(param: param), completion: completion)
    }
    func getNotificationList(completion: @escaping ((Result<NotificationListResponseModel,APIError>) -> Void)) {
        let param = [ "userId" : "\(AppSettings.userID)"]
        handleAPICalling(request: .getNotificationList(param: param), completion: completion)
    }
    func getChatList(receiverID:String,completion: @escaping ((Result<ChatResponseModel,APIError>) -> Void)) {
        let param = [ "userId" : "\(AppSettings.userID)",
                      "recieverID":receiverID ]
        handleAPICalling(request: .getChatList(param: param), completion: completion)
    }
    func addChatPic(image:UIImage,completion: @escaping ((Result<ChatImageModel,APIError>) -> Void)) {
        handleAPICalling(request: .uploadChatPic(userId: AppSettings.userID, image: image), completion: completion)
    }
    func addReportToUser(otherUserID:Int,text:String,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "fromId"  : AppSettings.userID,
            "toId"    : otherUserID,
            "message" :text] as [String : Any]
        handleAPICalling(request: .userReport(param: param), completion: completion)
    }
    func blockUser(otherUserID:Int,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "fromId" : AppSettings.userID,
            "toId"   : otherUserID]
        handleAPICalling(request: .userBlock(param: param), completion: completion)
    }
    func removeMatch(otherUserID:Int,completion: @escaping ((Result<CommanApiModel,APIError>) -> Void)) {
        let param = [
            "fromId" : AppSettings.userID,
            "toId"   : otherUserID,
            "matchingType" : "0" ] as [String : Any]
        handleAPICalling(request: .removeMatch(param: param), completion: completion)
    }
}
