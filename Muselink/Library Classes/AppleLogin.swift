//
//  AppleLogin.swift
//  Weeco
//
//  Created by iOSDeveloper on 01/09/20.
//  Copyright © 2020 apple. All rights reserved.
//


import Foundation
import AuthenticationServices

class AppleLogin : NSObject,ASAuthorizationControllerDelegate {
    static let shared = AppleLogin()
    private var handler : ((_ user:SocialAccountInfo?, _ error:String?)->())?
    //MARK:- Sign in with apple
     func setUpAppleSignIn( handler : @escaping ((_ user:SocialAccountInfo?, _ error:String?)->())){
        self.handler = handler
        if #available(iOS 13.0, *){
            let nonce = randomNonceString()
            currentNonce = nonce
            let appleIdProvider = ASAuthorizationAppleIDProvider()
            let request         = appleIdProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let signInAuthorizationController = ASAuthorizationController.init(authorizationRequests: [request])
            signInAuthorizationController.delegate = self
            signInAuthorizationController.performRequests()
            
        }else{
            handler(nil,"iOS < 13.0")
        }
    }
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    //MARK:- ---- apple---
    fileprivate var currentNonce: String?
    @available(iOS 13.0, *)
    internal func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleCredentials = authorization.credential as? ASAuthorizationAppleIDCredential{
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleCredentials.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let userIdByApple   = appleCredentials.user
            let userNameByApple = appleCredentials.fullName
            let emailByApple    = appleCredentials.email
            let dictionary : [String:Any] = ["email"        : emailByApple ?? "",
                                             "first_name"  : userNameByApple?.givenName ?? "",
                                             "last_name"   : userNameByApple?.familyName ?? "",
                                             "name"        : userNameByApple?.givenName ?? "",
                                             "id"          : userIdByApple,
                                             "idToken"     : idTokenString,
                                             "accessToken" :nonce]
            let info = SocialAccountInfo(dict: dictionary)
            print(info.accessToken ?? "")
            print(info.idToken ?? "")
            self.handler?(info, nil)
            
        }
        else {
            self.handler?(nil, "No details found")
        }
    }
    @available(iOS 13.0, *)
    internal func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.handler?(nil, error.localizedDescription)
    }
}
