//
//  APIEndPoint.swift
//  GunInstructor
//
//  Created by MAC on 17/06/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

enum NetworkEnvironment : String {
    case development = "https://php.parastechnologies.in/highMindEnergy/api/v1/"
}
enum OtherURLs : String {
    case profileURL = " "
    case TermsPrivacyUrl = "https://orchestrated.harishparas.com/Terms/Terms_&_Policy.html"
    case AboutUsUrl = "https://orchestrated.harishparas.com/EmailContent/About%20_Us.html"
}

enum APIEndPoint{
    case socialLogIn(param : [String:Any])
    case logIn(param : [String:Any])
    case signUp(param : [String:Any])
    case socialSignUp(param : [String:Any])
    case emailVerify(param : [String:Any])
    case forgotPassword(param : [String:Any])
    case resetPassword(param : [String:Any])
    case addReminder(param : [String:Any])
    case getReminderData
    case changePassword(param : [String:Any])
    case getCategories
    case getSubCategories(param : [String:Any])
    case getChoices
    case logout
    case getFaqList
    case deleteAccount
    case favListing(param : [String:Any])
    case getPageContent(param : [String:Any])
    case myProfile
    case editProfile(param : [String:Any], img: UIImage?)
    case homeDashboard
    case contactUs(param : [String:Any])
    case suggestAffirmaiton(param : [String:Any])
    case markFav(param : [String:Any])
    case deleteSubCategory(param : [String:Any])
    case updateUserCategory(param : [String:Any])
    case getAffirmationDetails(param : [String:Any])
    case exploreSection
    case seeAll(param : [String:Any])
    case seeAllMusic(param : [String:Any])
    case searchApi(param : [String:Any])
    case getThemeImgLibrary
    case getThemeAudioLibrary(param : [String:Any])
    case scrollAff
    case changeAffDayBgImg(param : [String:Any])
    case getNotifications(param : [String:Any])
    case addSubscription(param : [String:Any])
    case recentPlay(param : [String:Any])
    case recentTrackList(param : [String:Any])
    case followUs
    case redeemCode(param : [String:Any])
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
        case .logIn:
            return "auth/login"
        case .signUp:
            return "auth/register"
        case .getCategories:
            return "api/getCategories"
        case .getSubCategories:
            return "api/getSubCategories"
        case .getChoices:
            return "api/getChoices"
        case .emailVerify:
            return "api/emailVerification"
        case .forgotPassword:
            return "api/forgotPassword"
        case .resetPassword:
            return "api/resetPassword"
        case .logout:
            return "auth/logOut"
        case .myProfile:
            return "auth/getProfile"
        case .homeDashboard:
            return "user/homeDashboard"
        case .changePassword:
            return "user/changePassword"
        case .contactUs:
            return "user/postContact"
        case .getFaqList:
            return "api/getFaqs"
        case .deleteAccount:
            return "auth/deleteAccount"
        case .editProfile:
            return "user/editProfile"
        case .getPageContent:
            return "api/getpageContent"
        case .markFav:
            return "user/markFavourite"
        case .favListing:
            return "user/getFavouriteList"
        case .addReminder:
            return "user/addReminder"
        case .suggestAffirmaiton:
            return "user/suggestAffirmate"
        case .getAffirmationDetails:
            return "user/getAffirmatonByTrackId"
        case .getReminderData:
            return "user/getReminder"
        case .exploreSection:
            return "user/exploreSection"
        case .deleteSubCategory:
            return "user/delSubCategory"
        case .seeAll:
            return "user/seeallTracks"
        case .socialSignUp:
            return "auth/socialRegister"
        case .socialLogIn:
            return "auth/socialLogin"
        case .updateUserCategory:
            return "user/updateUserCategory"
        case .searchApi:
            return "user/searchAffirmationTrack"
        case .getThemeImgLibrary:
            return "user/getBackgroundThemeImageLibrary"
        case .getThemeAudioLibrary:
            return "user/getBackgroundAudioLibrary"
        case .scrollAff:
            return "user/scrollAffirmation"
        case .changeAffDayBgImg:
            return "user/changeAffirmationDayBackgroundImage"
        case .getNotifications:
            return "user/getNotificationList"
        case .seeAllMusic:
            return "user/seeAllMusicLibrary"
        case .addSubscription:
            return "user/addsubscriptionStatus"
        case .recentPlay:
            return "user/playTrack"
        case .recentTrackList:
            return "user/recentTrackList"
        case .followUs:
            return "api/followUsLink"
        case .redeemCode:
            return "user/redeemedCode"
        default: return ""
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getCategories, .getChoices, .getFaqList:
            return .get
        default:
            return .post
        }
    }
    var task: HTTPTask{
        switch self {
        case .followUs:
            return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: [:])
        case .logIn(param: let param), .signUp(param: let param), .emailVerify(param: let param), .forgotPassword(param: let param), .resetPassword(param: let param), .getSubCategories(param: let param), .getPageContent(param: let param), .socialSignUp(param: let param), .socialLogIn(param: let param):
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: [:])
            
        case .logout, .myProfile, .homeDashboard, .deleteAccount, .getReminderData, .exploreSection, .getThemeImgLibrary, .scrollAff:
            return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: headers)
            
        case .changePassword(param: let param), .contactUs(param: let param), .markFav(param: let param), .favListing(param: let param), .addReminder(param: let param), .suggestAffirmaiton(param: let param), .getAffirmationDetails(param: let param), .deleteSubCategory(param: let param), .seeAll(param: let param), .updateUserCategory(param: let param), .searchApi(param: let param), .getThemeAudioLibrary(param: let param), .changeAffDayBgImg(param: let param), .getNotifications(param: let param), .seeAllMusic(param: let param), .addSubscription(param: let param), .recentPlay(param: let param), .recentTrackList(param: let param), .redeemCode(param: let param):
            
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: headers)
            
            
//        case .fetchMyProfile(param: let param):
//            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: headers)
            
        case .editProfile(param: let param, img: let img):
            
            let boundary = "Boundary-\(UUID().uuidString)"
            var body = Data()
            if param != nil {
                for (key, value) in param {
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.append("\(value)\r\n")
                }
            }
            if let pic = img {
                body.append("--\(boundary)\r\n")
                let imageData = pic.jpegData(compressionQuality: 0.5) ?? Data()
                body.append("Content-Disposition: form-data; name=\"img\"; filename=\"\(Date().timeIntervalSince1970).jpg\"\r\n")
                body.append("Content-Type: image/jpg\r\n\r\n")
                body.append(imageData)
                body.append("\r\n")
            }
            body.append("--".appending(boundary.appending("--")))
            
            return .requestMultipart(data: body, additionHeaders: ["Content-Type":"multipart/form-data; boundary=\(boundary)","Authorization": "Bearer \(UserData.LoginToken)"])
            
        case .getCategories, .getChoices, .getFaqList:
            return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: [:])
        default:
            return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: [:])
        }
    }
    var headers: HTTPHeaders? {
        return ["Authorization": "Bearer \(UserData.LoginToken)"]
    }
}

extension APIEndPoint{
    private func setBodyParams(profilePicture:UIImage?,primaryIdProof:UIImage?,secondaryIdProof:UIImage?,param:[String:Any]) -> (Data, String)  {
        let boundry = "Boundary-\(UUID().uuidString)"
        var body = Data()
        param.forEach { (key, value) in
            body.append(string: "--\(boundry)\r\n")
            body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append(string: "\(value)\r\n")
        }
        
        // Add the profile image
        if  let proflePhoto = profilePicture{
            let imageData = proflePhoto.jpegData(compressionQuality: 0.8)
            body.append("--\(boundry)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"ProfilePic\"; filename=\"image1.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            if let imageData1 = imageData {
                body.append(imageData1)
            }
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Add the primaryID image
        if  let proflePhoto1 = primaryIdProof{
            let imageData1 = proflePhoto1.jpegData(compressionQuality: 0.8)
            body.append("--\(boundry)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"PrimaryIdProof\"; filename=\"image1.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            if let imageData1 = imageData1 {
                body.append(imageData1)
            }
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Add the secondaryID image
        if let proflePhoto2 = secondaryIdProof{
            let imageData2 = proflePhoto2.jpegData(compressionQuality: 0.8)
            body.append("--\(boundry)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"SecondaryIdProof\"; filename=\"image2.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            if let imageData2 = imageData2 {
                body.append(imageData2)
            }
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Add the end boundary
        body.append("--\(boundry)--\r\n".data(using: .utf8)!)
        
        return (body,boundry)
    }
    
    private func setBodyParam(profileImage:UIImage?,param:[String:Any]) -> (Data, String)  {
        let boundry = "Boundary-\(UUID().uuidString)"
        var body = Data()
        param.forEach { (key, value) in
            body.append(string: "--\(boundry)\r\n")
            body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append(string: "\(value)\r\n")
        }
        let boundaryPrefix = "--\(boundry)\r\n"
        
        if let profile_img = profileImage{
            body.append( string: boundaryPrefix)
            let filename = "\(Date().timeIntervalSince1970).jpg"
            body.append(string: "Content-Disposition: form-data; name=\"img\"; filename=\"\(filename)\"\r\n")
            body.append(string: "Content-Type: image/jpg\r\n\r\n")
            body.append(profile_img.jpegData(compressionQuality: 0.1) ?? Data())
        }
        body.append(string: "\r\n")
        body.append( string: "--\(boundry)--\r\n")
        return (body,boundry)
    }
    
    private func setBodyParamForMultipleImages(InstrumentImages:[UIImage]?, param:[String:Any]) -> (Data, String)  {
        let boundary = UUID().uuidString
        var bodyData = Data()
        
        // Add the parameters to the body
        for (key, value) in param {
            bodyData.append(string: "--\(boundary)\r\n")
            bodyData.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            bodyData.append(string: "\(value)\r\n")
        }
        
        // Add the images to the body
        if InstrumentImages != nil {
            for (index, image) in InstrumentImages!.enumerated() {
                let imageData = image.jpegData(compressionQuality: 0.8)
                bodyData.append(string: "--\(boundary)\r\n")
                bodyData.append(string: "Content-Disposition: form-data; name=\"InstrumentAddImages\"; filename=\"\(UUID().uuidString).jpg\"\r\n")
                bodyData.append(string: "Content-Type: image/jpeg\r\n\r\n")
                if let imageData = imageData {
                    bodyData.append(imageData)
                }
                bodyData.append(string: "\r\n")
            }
        }
        
        // Add the final boundary
        bodyData.append(string: "--\(boundary)--\r\n")
        return (bodyData,boundary)
    }
    
    private func setBodyParamForMultipleImagesWithoutParam(Images:[UIImage]?) -> (Data, String)  {
        let boundary = UUID().uuidString
        var bodyData = Data()
        
        // Add the images to the body
        for (index, image) in Images!.enumerated() {
            let imageData = image.jpegData(compressionQuality: 0.8)
            bodyData.append(string: "--\(boundary)\r\n")
            bodyData.append(string: "Content-Disposition: form-data; name=\"Files\"; filename=\"\(UUID().uuidString).jpg\"\r\n")
            bodyData.append(string: "Content-Type: image/jpeg\r\n\r\n")
            if let imageData = imageData {
                bodyData.append(imageData)
            }
            bodyData.append(string: "\r\n")
        }
        
        // Add the final boundary
        bodyData.append(string: "--\(boundary)--\r\n")
        return (bodyData,boundary)
    }
    
    private func setBodyParameter(video: URL?/*,params:[String:Any]*/) -> (Data, String)  {
        
        let boundry = "Boundary-\(UUID().uuidString)"
        var body = Data()
        //            params.forEach { (key, value) in
        //                body.append(string: "--\(boundry)\r\n")
        //                body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        //                body.append(string: "\(value)\r\n")
        //            }
        let boundaryPrefix = "--\(boundry)\r\n"
        
        if let video = video{
            body.append(string: boundaryPrefix)
            let filename = "\(Date().timeIntervalSince1970).\(video.absoluteURL.pathExtension)"
            body.append(string: "Content-Disposition: form-data; name=\"Intro\"; filename=\"\(filename)\"\r\n")
            if filename.lowercased() == "mov"{
                body.append(string: "Content-Type: video/quicktime\r\n\r\n")
            }
            else{
                body.append(string: "Content-Type: video/mp4\r\n\r\n")
            }
            let data = try? Data.init(contentsOf: video)
            
            print(data)
            body.append(data ?? Data())
            body.append(string: "\r\n")
        }
        body.append( string: "--\(boundry)--\r\n")
        return (body,boundry)
    }
    
    private func setBodyParameters(params:[String:Any],user_Imag:UIImage?,pdf:URL?) -> (Data, String){
        let boundry = "Boundary-\(UUID().uuidString)"
        let boundaryPrefix = "--\(boundry)\r\n"
        var body = Data()
        params.forEach { (key, value) in
            body.append(string: "--\(boundry)\r\n")
            body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append(string: "\(value)\r\n")
        }
        
        if let profile_img = user_Imag{
            body.append(string: boundaryPrefix)
            let filename = "\(Date().timeIntervalSince1970).jpg"
            body.append(string: "Content-Disposition: form-data; name=\"ProfilePic\"; filename=\"\(filename)\"\r\n")
            body.append(string: "Content-Type: image/jpg\r\n\r\n")
            body.append(profile_img.jpegData(compressionQuality: 0.1) ?? Data())
            body.append(string: "\r\n")
        }
        if let pdfimg = pdf{
            body.append(string: boundaryPrefix)
            let filename = "\(Date().timeIntervalSince1970).\(pdfimg.absoluteURL.pathExtension)"
            body.append(string:"Content-Disposition: form-data; name=\"ProofPic\"; filename=\"\(filename)\"\r\n")
            if filename.lowercased() == "mov"{
                body.append(string: "Content-Type: pdf/pdf\r\n\r\n")
            }
            else{
                body.append(string: "Content-Type: document/pdf\r\n\r\n")
            }
            let data = try? Data.init(contentsOf: pdfimg)
            body.append(data ?? Data())
            body.append(string: "\r\n")
        }
        body.append( string: "--\(boundry)--\r\n")
        body.append( string: "--\(boundry)--\r\n")
        return (body,boundry)
    }
    
    private func addNewInstrumentSetBodyParamForMultipleImages(InstrumentImages:[String]?, param:[String:Any]) -> (Data, String)  {
    //        let boundary = UUID().uuidString
            let boundary = "Boundary-\(UUID().uuidString)"
            var body = Data()
            
            // Add the parameters to the body
            param.forEach { (key, value) in
                if key == "uploadedFiles" {
                    if let value = value as? [String] {
                        for each in value {
                            body.append(string: "--\(boundary)\r\n")
                            body.append(string: "Content-Disposition: form-data; name=\"uploadedFiles[]\"\r\n\r\n")
                            body.append(string: "\(each)\r\n")
                        }
                    }
                } else {
                    body.append(string: "--\(boundary)\r\n")
                    body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.append(string: "\(value)\r\n")
                }
            }
            
            // Add the final boundary
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            return (body,boundary)
        }

}

