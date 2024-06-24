//
//  SignUpSelectTypeVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 08/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import SwiftyDropbox
class SignUpSelectTypeVC: BaseClassVC {
    @IBOutlet weak var btn_SigUpPhoneEmail : SoftUIView!
    @IBOutlet weak var btn_SigUpTikTok     : SoftUIView!
    @IBOutlet weak var btn_SigUpFacebook   : SoftUIView!
    @IBOutlet weak var btn_SigUpInstagram  : SoftUIView!
    @IBOutlet weak var btn_SigUpSoundCloud : SoftUIView!
    @IBOutlet weak var btn_SigUpAppleID    : SoftUIView!
    @IBOutlet weak var lbl_TermAndCondition: UILabel!
    private var viewModel           : RegistrationViewModel!
    private let text   = "By continuing, you agree to Muselink Terms of Use and confirm that you have read Muselink Privacy Policy."
    override func viewDidLoad() {
        super.viewDidLoad()

        lbl_TermAndCondition.text = text
        lbl_TermAndCondition.textColor =  UIColor.white
        lbl_TermAndCondition.font = UIFont.AvenirLTPRo_Regular(size: 15)
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Terms of Use")
        let range2 = (text as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.AvenirLTPRo_Regular(size: 15), range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.skyBlue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.AvenirLTPRo_Regular(size: 15), range: range2)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.skyBlue, range: range2)
        lbl_TermAndCondition.attributedText = underlineAttriString
        lbl_TermAndCondition.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        
    }
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let termsRange = (text as NSString).range(of: " Terms of Use and ")
        let privacyRange = (text as NSString).range(of: "read Muselink Privacy Policy")
        // comment for now
        //let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        if gesture.didTapAttributedTextInLabel(label: lbl_TermAndCondition, inRange: termsRange) {
            let termURL = URL(string: NetworkManager.termOfUserURL)!
            if UIApplication.shared.canOpenURL(termURL) {
                UIApplication.shared.open(termURL, options: [:]) { res in
                    
                }
            }
            
        } else if gesture.didTapAttributedTextInLabel(label: lbl_TermAndCondition, inRange: privacyRange) {
            let privacyURL = URL(string: NetworkManager.privacyURL)!
            if UIApplication.shared.canOpenURL(privacyURL) {
                UIApplication.shared.open(privacyURL, options: [:]) { res in
                    
                }
            }
        } else {
            print("Tapped none")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    private func setUpViews() {
        btn_SigUpPhoneEmail.type = .pushButton
        btn_SigUpPhoneEmail.addTarget(self, action: #selector(action_PhoneEmail), for: .touchDown)
        btn_SigUpPhoneEmail.cornerRadius = 10
        btn_SigUpPhoneEmail.mainColor = UIColor.darkBackGround.cgColor
        btn_SigUpPhoneEmail.darkShadowColor = UIColor.black.cgColor
        btn_SigUpPhoneEmail.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_SigUpPhoneEmail.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "mobile-mail"), font: .AvenirLTPRo_Regular(size: 18), title: "Sign up with Phone/Email",titleColor: .white)
        
        btn_SigUpTikTok.type = .pushButton
        btn_SigUpTikTok.addTarget(self, action: #selector(action_TikTok), for: .touchDown)
        btn_SigUpTikTok.cornerRadius = 10
        btn_SigUpTikTok.mainColor = UIColor.darkBackGround.cgColor
        btn_SigUpTikTok.darkShadowColor = UIColor.black.cgColor
        btn_SigUpTikTok.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_SigUpTikTok.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "email"), font: .AvenirLTPRo_Regular(size: 18), title: "Sign up with TikTok",titleColor: .white)
        
        btn_SigUpFacebook.type = .pushButton
        btn_SigUpFacebook.addTarget(self, action: #selector(action_Facebook), for: .touchDown)
        btn_SigUpFacebook.cornerRadius = 10
        btn_SigUpFacebook.mainColor = UIColor.darkBackGround.cgColor
        btn_SigUpFacebook.darkShadowColor = UIColor.black.cgColor
        btn_SigUpFacebook.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_SigUpFacebook.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "facebook_regis"), font: .AvenirLTPRo_Regular(size: 18), title: "Sign up with Facebook",titleColor: .white)
        
        btn_SigUpInstagram.type = .pushButton
        btn_SigUpInstagram.addTarget(self, action: #selector(action_Instagram), for: .touchDown)
        btn_SigUpInstagram.cornerRadius = 10
        btn_SigUpInstagram.mainColor = UIColor.darkBackGround.cgColor
        btn_SigUpInstagram.darkShadowColor = UIColor.black.cgColor
        btn_SigUpInstagram.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_SigUpInstagram.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "instagram"), font: .AvenirLTPRo_Regular(size: 18), title: "Sign up with Instagram",titleColor: .white)
        
        btn_SigUpSoundCloud.type = .pushButton
        btn_SigUpSoundCloud.addTarget(self, action: #selector(action_DropBox), for: .touchDown)
        btn_SigUpSoundCloud.cornerRadius = 10
        btn_SigUpSoundCloud.mainColor = UIColor.darkBackGround.cgColor
        btn_SigUpSoundCloud.darkShadowColor = UIColor.black.cgColor
        btn_SigUpSoundCloud.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_SigUpSoundCloud.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "soundcloud"), font: .AvenirLTPRo_Regular(size: 18), title: "Sign up with DropBox",titleColor: .white)
        
        btn_SigUpAppleID.type = .pushButton
        btn_SigUpAppleID.addTarget(self, action: #selector(action_AppleID), for: .touchDown)
        btn_SigUpAppleID.cornerRadius = 10
        btn_SigUpAppleID.mainColor = UIColor.darkBackGround.cgColor
        btn_SigUpAppleID.darkShadowColor = UIColor.black.cgColor
        btn_SigUpAppleID.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_SigUpAppleID.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "apple"), font: .AvenirLTPRo_Regular(size: 18), title: "Sign up with Apple ID",titleColor: .white)
    }
    @objc private func action_PhoneEmail() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpEmail_PhoneVC") as? SignUpEmail_PhoneVC else {
                return
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc private func action_TikTok() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpSuccessVC") as? SignUpSuccessVC else {
                return
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc private func action_Facebook() {
        viewModel = RegistrationViewModel(type: .SignUp(type: .Facebook))
        setUpVM(model: viewModel)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            FacebookIntegeration.basicInfoWithCompletionHandler(self) { [weak self](dataDictionary, error) in
                guard let self = self else {return}
                if dataDictionary != nil {
                    //let fbEmail      = dataDictionary?["email"] as? String ?? ""
                    let faceBookID   = dataDictionary?["id"] as? String ?? ""
                    //let facebookName = dataDictionary?["name"] as? String ?? ""
                    
                    self.viewModel.socialID = faceBookID
                    self.viewModel.signUP(type: .Facebook)
                    self.viewModel.didFinishFetch = {
                        DispatchQueue.main.async {
                            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpSuccessVC") as? SignUpSuccessVC else {
                                return
                            }
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
    @objc private func action_Instagram() {
        viewModel = RegistrationViewModel(type: .SignUp(type: .Instagram))
        setUpVM(model: viewModel)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "InstagramWebView") as? InstagramWebView else {
                return
            }
            vc.delegate = self
            navigationController?.present(vc, animated: true)
        }
    }
    @objc private func action_DropBox() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            // Use only one of these two flows at once:

            // Legacy authorization flow that grants a long-lived token.
            DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                          controller: self,
                                                          openURL: { (url: URL) -> Void in
                                                            UIApplication.shared.open(url, options: [ :]) { res in
                                                                print("Dropbox res - \(res)")
                                                            }
                                                          })

          // New: OAuth 2 code flow with PKCE that grants a short-lived token with scopes.
          let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read"], includeGrantedScopes: false)
          DropboxClientsManager.authorizeFromControllerV2(
              UIApplication.shared,
              controller: self,
              loadingStatusDelegate: nil,
              openURL: { (url: URL) -> Void in
                UIApplication.shared.open(url, options: [ :]) { res in
                    print("Dropbox res - \(res)")
                }
              },
              scopeRequest: scopeRequest
          )
        }
    }
    @objc private func action_AppleID() {
        viewModel = RegistrationViewModel(type: .SignUp(type: .AppleID))
        setUpVM(model: viewModel)
        AppleLogin.shared.setUpAppleSignIn {[weak self](userDetails, msg) in
            guard  let self = self else {return}
            guard let userDetail = userDetails else {
                self.showErrorMessages(message: "Authentication failed!")
                return
            }
            self.viewModel.socialID = userDetail.socialId ?? ""
            self.viewModel.signUP(type: .AppleID)
            self.viewModel.didFinishFetch = {[weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
                    guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "SignUpSuccessVC") as? SignUpSuccessVC else {
                        return
                    }
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    @IBAction func action_LogIn() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "logInSelectTypeVC") as? logInSelectTypeVC else {
            return
        }
        navigationController?.setViewControllers([vc], animated: true)
    }
}
extension SignUpSelectTypeVC: InstagramWebViewDelegate {
    func fetchedInstagram(userID: Int) {
        self.viewModel.socialID = "\(userID)"
        self.viewModel.signUP(type: .Instagram)
        self.viewModel.didFinishFetch = {
            DispatchQueue.main.async {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpSuccessVC") as? SignUpSuccessVC else {
                    return
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
