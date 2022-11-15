//
//  SocialAccountModel.swift
//  WTC
//
//  Created by paras on 02/06/21.
//

import Foundation

struct SocialAccountInfo {
    var email       : String?
    var firstName   : String?
    var lastName    : String?
    var fullName    : String?
    var socialId    : String?
    var accessToken : String?
    var idToken     : String?

    init(dict:[String:Any]) {
        
        email       = dict["email"] as? String ?? ""
        firstName   = dict["first_name"] as? String ?? ""
        lastName    = dict["last_name"] as? String ?? ""
        fullName    = dict["name"] as? String ?? ""
        socialId    = dict["id"] as? String ?? ""
        accessToken = dict["accessToken"] as? String ?? ""
        idToken     = dict["idToken"] as? String ?? ""
       
    }
}
