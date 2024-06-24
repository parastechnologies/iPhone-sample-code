//
//  APIEndPoint.swift
//  OMDA(Driver app)
//
//  Created by MAC on 17/06/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

enum NetworkEnvironment : String {
    case development  = "http://ankit.parastechnologies.in/muselink"
}
enum BaseURLs : String {
    case FullAudio    = "http://ankit.parastechnologies.in/muselink/uploads/full-audio/"
    case TrimAudio    = "http://ankit.parastechnologies.in/muselink/uploads/trim-audio/"
    case RecordVideo  = "http://ankit.parastechnologies.in/muselink/uploads/recording-video/"
    case ProfileImage = "http://ankit.parastechnologies.in/muselink/uploads/user-profile/"
    case ChatImages   = "http://ankit.parastechnologies.in/muselink/uploads/Chat-stuff/"
    case TermOfUse    = "https://www.muselink.app/terms-condition/"
    case Privacy      = "https://www.muselink.app/privacy-policy/"
}
enum APIEndPoint{
    case logIn(param :[String:Any])
    case signUp(param :[String:Any])
    case verifyCode(param :[String:Any])
    case resendOTP(param :[String:Any])
    case forgetPassword(param :[String:Any])
    case manageOnlieStatus(param:[String:Any])
    
    //profile
    case interestlist
    case listOfBlockAccount(param :[String:Any])
    case unBlockUser(param: [String:Any])
    case submitSupport(param :[String:Any],supportFile:Data)
    case changeNotification(param: [String:Any])
    case editBiography(param: [String:Any])
    case changeAccountPermissionStatus(param: [String:Any])
    case settingsDetail(param: [String:Any])
    case changePassword(param: [String:Any])
    case changeEmail(param: [String:Any])
    case changePhoneNumber(param: [String:Any])
    case changeUsername(param: [String:Any])
    case getVideoForUser(param: [String:Any])
    case getAboutMe(param:[String:Any])
    case updateInterest(param: [String:Any])
    case updateGoal(param: [String:Any])
    case uploadProfilePic(userId:Int,image:UIImage)
    case removeAudio(param: [String:Any])
    case audioNotificationStatus(param: [String:Any])
    case inviteFriend(param: [String:Any])
    
    //Uploading
    case goallist
    case roleList
    case uploadSound(userId:String,fullAudio:Data,trimAudio:Data,description:String,descriptionColor:String,roleId:[String],goalId:[String],locationTags:[String],video:Data)
    case checkUploadCount(param: [String:Any])
    
    //Home
    case getAllVideos(param: [String:Any])
    case getAudioDescription(param: [String:Any])
    case giveLike(param: [String:Any])
    case getAllUsers(param: [String:Any])
    case giveLikeToUser(param:[String:Any])
    case sendDM(param:[String:Any])
    case search(param:[String:Any])
    case checkSubscription(param:[String:Any])
    case reportOnAudio(param:[String:Any])
    
    //Chat
    case getChatList(param:[String:Any])
    case getChatUserList(param:[String:Any])
    case getNotificationList(param:[String:Any])
    case uploadChatPic(userId:Int,image:UIImage)
    case userReport(param:[String:Any])
    case userBlock(param:[String:Any])
    case removeMatch(param:[String:Any])
    
    //Subscription
    case addSubscription(param:[String:Any])
}
extension APIEndPoint:EndPointType{
    var environmentBaseURL : String {
        return NetworkManager.environment.rawValue
    }
    var baseURL: URL{
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    var path: String{
        switch  self {
        // Registration
        case .signUp:
            return "/Api/user/SignUp"
        case .logIn:
            return "/Api/user/logIn"
        case .verifyCode:
            return "/Api/interest/verifyOtp"
        case .resendOTP:
            return "/Api/user/reSendOtp"
        case .forgetPassword:
            return "/Api/user/forgotPassword"
        case .manageOnlieStatus:
            return "/Api/user/updateOnlineOfflineStatus"
            
        //Uploading
        case .goallist:
            return "/Api/interest/getGoals"
        case .roleList:
            return "/Api/interest/getProjectRoles"
        case .uploadSound:
            return "/Api/audio/upload"
        case .checkUploadCount:
            return "/Api/audio/getAudioUploadCountAccordingToSubscription"
            
        //Profile
        case .interestlist:
            return "/Api/interest/getInterests"
        case .listOfBlockAccount:
            return "/Api/setting/listOfBlockAccount"
        case .unBlockUser:
            return "/Api/socailnetwork/unBlock"
        case .submitSupport:
            return "/Api/setting/support"
        case .changeNotification:
            return "/Api/setting/changeNotificationSetting"
        case .editBiography:
            return "/Api/setting/editBiography"
        case .changeAccountPermissionStatus:
            return "/Api/setting/changeAccountPermissionsStatus"
        case .settingsDetail:
            return "/Api/user/getProfile"
        case .changePassword:
            return "/Api/user/changePassword"
        case .changeEmail:
            return "/Api/setting/changeEmail"
        case .changePhoneNumber:
            return "/Api/setting/changePhone"
        case .changeUsername:
            return "/Api/setting/changeUserName"
        case .getVideoForUser:
            return "/Api/audio/getAudioAccordingToUserId"
        case .getAboutMe:
            return "/Api/interest/getPersonalInterestAndCareerGoal"
        case .updateInterest:
            return "/Api/interest/updatePersonalInterest"
        case .updateGoal:
            return "/Api/interest/updatePersonalCareerGoal"
        case .uploadProfilePic:
            return "/Api/user/uploadProfilePicture"
        case .removeAudio:
            return "/Api/audio/deleteAudio"
        case .audioNotificationStatus:
            return "/Api/audio/changeNotificationStatusForAudio"
        case .inviteFriend:
            return "/Api/socailnetwork/inviteFriend"
            
        //Home
        case .getAllVideos:
            return "/Api/audio/getAllAudio"
        case .getAudioDescription:
            return "/Api/audio/getAudioDescription"
        case .giveLike:
            return "/Api/audio/favoriteAudio"
        case .getAllUsers:
            return "/Api/user/getAllUserProfiles"
        case .giveLikeToUser:
            return "/Api/socailnetwork/favoriteUser"
        case .sendDM:
            return "/Api/socailnetwork/addDirectMessage"
        case .search:
            return "/Api/search"
        case .checkSubscription:
            return "/Api/subscription/checkSubscriptionStatus"
        case .reportOnAudio:
            return "/Api/audio/reportOnAudio"
            
        //Users
        case .getChatList:
            return "/Api/user/getChatList"
        case .getChatUserList:
            return "/Api/socailnetwork/getRecentChatListPost"
        case .getNotificationList:
            return "/Api/socailnetwork/getNotificationList"
        case .uploadChatPic:
            return "/Api/user/uploadChatStuff"
        case .userReport:
            return "/Api/socailnetwork/reportUser"
        case .userBlock:
            return "/Api/socail/userBlock"
        case .removeMatch:
            return "/Api/socailnetwork/removeMatch"
            
        //Subscription
        case .addSubscription:
            return "/Api/Subscription"
        }
    }
    var httpMethod: HTTPMethod {
        switch self {
        case .interestlist, .goallist, .roleList:
            return .get
        default:
            return .post
        }
    }
    var task: HTTPTask{
        switch self {
        case .signUp(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .verifyCode(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .logIn(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .forgetPassword(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .resendOTP(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .interestlist, .goallist, .roleList:
            return .request
        case .uploadSound(let userId,let fullAudio, let trimAudio, let description, let descriptionColor, let roleId, let goalId,let locationTags,let video):
            let boundry = "Boundary-\(UUID().uuidString)"
            var body = Data()
            let boundaryPrefix = "--\(boundry)\r\n"
            body.append( boundaryPrefix)
            body.append( "Content-Disposition: form-data; name=\"userId\"")
            body.append( "\r\n\r\n")
            body.append(userId)
            body.append( "\r\n")
            
            body.append( boundaryPrefix)
            body.append( "Content-Disposition: form-data; name=\"description\"")
            body.append( "\r\n\r\n")
            body.append(description)
            body.append( "\r\n")
            
            body.append( boundaryPrefix)
            body.append( "Content-Disposition: form-data; name=\"descriptionColor\"")
            body.append( "\r\n\r\n")
            body.append(descriptionColor)
            body.append( "\r\n")
            
            for role in roleId {
                body.append( boundaryPrefix)
                body.append( "Content-Disposition: form-data; name=\"roleId[]\"")
                body.append( "\r\n\r\n")
                body.append(role)
                body.append( "\r\n")
            }
            for goal in goalId {
                body.append( boundaryPrefix)
                body.append( "Content-Disposition: form-data; name=\"goalId[]\"")
                body.append( "\r\n\r\n")
                body.append(goal)
                body.append( "\r\n")
            }
            for loc in locationTags {
                body.append( boundaryPrefix)
                body.append( "Content-Disposition: form-data; name=\"locations[]\"")
                body.append( "\r\n\r\n")
                body.append(loc)
                body.append( "\r\n")
            }
            body.append( boundaryPrefix)
            body.append( "Content-Disposition: form-data; name=\"trimAudio\"; filename=\"trim_\(Int(Date().timeIntervalSince1970)).m4a\"\r\n")
            body.append( "Content-Type: header\r\n\r\n")
            body.append(trimAudio)
            body.append( "\r\n")
            
            body.append( boundaryPrefix)
            body.append( "Content-Disposition: form-data; name=\"fullAudio\"; filename=\"full_\(Int(Date().timeIntervalSince1970)).m4a\"\r\n")
            body.append( "Content-Type: header\r\n\r\n")
            body.append(fullAudio)
            body.append( "\r\n")
            
            body.append( boundaryPrefix)
            body.append( "Content-Disposition: form-data; name=\"recordingVideo\"; filename=\"Recoding_\(Int(Date().timeIntervalSince1970)).mp4\"\r\n")
            body.append( "Content-Type: header\r\n\r\n")
            body.append(video)
            body.append( "\r\n")
            
            body.append( "--\(boundry)--\r\n")
            return .requestMultipart(data: body, additionHeaders: ["Content-Type":"multipart/form-data; boundary=\(boundry)"])
            
        case .listOfBlockAccount(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .submitSupport(param: let param, supportFile: let file):
            let boundary = "Boundary-\(UUID().uuidString)"
            var body = Data()
            for param in param {
                let paramName = param.key
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition:form-data; name=\"\(paramName)\"")
                body.append("\r\nContent-Type: text")
                let paramValue = "\(param.value)"
                body.append("\r\n\r\n\(paramValue)\r\n")
            }
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition:form-data; name=\"supportFile\"")
            body.append("; filename=\"\(Date().timeIntervalSince1970).jpg\"\r\n"
                            + "Content-Type: \"content-type header\"\r\n\r\n")
            body.append(file)
            body.append("\r\n")
            
            body.append("--\(boundary)--\r\n")
            return .requestMultipart(data: body, additionHeaders: ["Content-Type":"multipart/form-data; boundary=\(boundary)"])
        case .changeNotification(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .editBiography(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .changeAccountPermissionStatus(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .settingsDetail(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .unBlockUser(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .changePassword(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .changeEmail(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .changePhoneNumber(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .changeUsername(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .getVideoForUser(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .getAllVideos(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .getAboutMe(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .updateInterest(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .updateGoal(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .uploadProfilePic(userId: let userID, image: let image):
            let boundary = "Boundary-\(UUID().uuidString)"
            var body = Data()
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition:form-data; name=\"userId\"")
            body.append("\r\nContent-Type: text")
            body.append("\r\n\r\n\(userID)\r\n")
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition:form-data; name=\"profilePicture\"")
            body.append("; filename=\"\(Date().timeIntervalSince1970).jpg\"\r\n"
                            + "Content-Type: \"content-type header\"\r\n\r\n")
            body.append(image.jpegData(compressionQuality: 0.5) ?? Data())
            body.append("\r\n")
            
            body.append("--\(boundary)--\r\n")
            return .requestMultipart(data: body, additionHeaders: ["Content-Type":"multipart/form-data; boundary=\(boundary)"])
        case .getAudioDescription(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .giveLike(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .getAllUsers(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .getChatList(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .giveLikeToUser(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .getChatUserList(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .getNotificationList(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .addSubscription(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .sendDM(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .search(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .checkSubscription(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .reportOnAudio(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .manageOnlieStatus(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .uploadChatPic(userId: let userId, image: let image):
            let boundary = "Boundary-\(UUID().uuidString)"
            var body = Data()
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition:form-data; name=\"userId\"")
            body.append("\r\nContent-Type: text")
            body.append("\r\n\r\n\(userId)\r\n")
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition:form-data; name=\"chatStuff\"")
            body.append("; filename=\"\(Date().timeIntervalSince1970).jpg\"\r\n"
                            + "Content-Type: \"content-type header\"\r\n\r\n")
            body.append(image.jpegData(compressionQuality: 0.5) ?? Data())
            body.append("\r\n")
            body.append("--\(boundary)--\r\n")
            return .requestMultipart(data: body, additionHeaders: ["Content-Type":"multipart/form-data; boundary=\(boundary)"])
            
        case .userReport(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .userBlock(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .removeMatch(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .removeAudio(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .audioNotificationStatus(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .inviteFriend(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .checkUploadCount(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        }
    }
    var headers: HTTPHeaders? {
        return nil
    }
}
