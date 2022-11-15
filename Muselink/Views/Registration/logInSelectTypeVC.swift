//
//  logInSelectTypeVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 25/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import SwiftyDropbox
class logInSelectTypeVC: BaseClassVC {
    @IBOutlet weak var btn_SigUpPhoneEmail : SoftUIView!
    @IBOutlet weak var btn_SigUpTikTok     : SoftUIView!
    @IBOutlet weak var btn_SigUpFacebook   : SoftUIView!
    @IBOutlet weak var btn_SigUpInstagram  : SoftUIView!
    @IBOutlet weak var btn_SigUpSoundCloud : SoftUIView!
    @IBOutlet weak var btn_SigUpAppleID    : SoftUIView!
    private var viewModel : RegistrationViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        btn_SigUpPhoneEmail.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "mobile-mail"), font: .AvenirLTPRo_Regular(size: 18), title: "Log in with Phone/Email",titleColor: .white)
        
        btn_SigUpTikTok.type = .pushButton
        btn_SigUpTikTok.addTarget(self, action: #selector(action_TikTok), for: .touchDown)
        btn_SigUpTikTok.cornerRadius = 10
        btn_SigUpTikTok.mainColor = UIColor.darkBackGround.cgColor
        btn_SigUpTikTok.darkShadowColor = UIColor.black.cgColor
        btn_SigUpTikTok.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_SigUpTikTok.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "email"), font: .AvenirLTPRo_Regular(size: 18), title: "Log in with TikTok",titleColor: .white)
        
        btn_SigUpFacebook.type = .pushButton
        btn_SigUpFacebook.addTarget(self, action: #selector(action_Facebook), for: .touchDown)
        btn_SigUpFacebook.cornerRadius = 10
        btn_SigUpFacebook.mainColor = UIColor.darkBackGround.cgColor
        btn_SigUpFacebook.darkShadowColor = UIColor.black.cgColor
        btn_SigUpFacebook.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_SigUpFacebook.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "facebook_regis"), font: .AvenirLTPRo_Regular(size: 18), title: "Log in with Facebook",titleColor: .white)
        
        btn_SigUpInstagram.type = .pushButton
        btn_SigUpInstagram.addTarget(self, action: #selector(action_Instagram), for: .touchDown)
        btn_SigUpInstagram.cornerRadius = 10
        btn_SigUpInstagram.mainColor = UIColor.darkBackGround.cgColor
        btn_SigUpInstagram.darkShadowColor = UIColor.black.cgColor
        btn_SigUpInstagram.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_SigUpInstagram.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "instagram"), font: .AvenirLTPRo_Regular(size: 18), title: "Log in with Instagram",titleColor: .white)
        
        btn_SigUpSoundCloud.type = .pushButton
        btn_SigUpSoundCloud.addTarget(self, action: #selector(action_DropBox), for: .touchDown)
        btn_SigUpSoundCloud.cornerRadius = 10
        btn_SigUpSoundCloud.mainColor = UIColor.darkBackGround.cgColor
        btn_SigUpSoundCloud.darkShadowColor = UIColor.black.cgColor
        btn_SigUpSoundCloud.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_SigUpSoundCloud.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "soundcloud"), font: .AvenirLTPRo_Regular(size: 18), title: "Log in with DropBox",titleColor: .white)
        
        btn_SigUpAppleID.type = .pushButton
        btn_SigUpAppleID.addTarget(self, action: #selector(action_AppleID), for: .touchDown)
        btn_SigUpAppleID.cornerRadius = 10
        btn_SigUpAppleID.mainColor = UIColor.darkBackGround.cgColor
        btn_SigUpAppleID.darkShadowColor = UIColor.black.cgColor
        btn_SigUpAppleID.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_SigUpAppleID.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "apple"), font: .AvenirLTPRo_Regular(size: 18), title: "Log in with Apple ID",titleColor: .white)
    }
    @objc private func action_PhoneEmail() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "LogInEmail_PhoneVC") as? LogInEmail_PhoneVC else {
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
        viewModel = RegistrationViewModel(type: .SignIn(type: .Facebook))
        setUpVM(model: viewModel)
        FacebookIntegeration.basicInfoWithCompletionHandler(self) { [weak self](dataDictionary, error) in
            guard let self = self else {return}
            if dataDictionary != nil {
                //let fbEmail      = dataDictionary?["email"] as? String ?? ""
                let faceBookID   = dataDictionary?["id"] as? String ?? ""
                //let facebookName = dataDictionary?["name"] as? String ?? ""
                self.viewModel.socialID = faceBookID
                self.viewModel.signIn(type: .Facebook)
                self.viewModel.didFinishFetch = {
                    DispatchQueue.main.async {
                        self.navigationController?.dismiss(animated: true, completion: nil)
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
        viewModel = RegistrationViewModel(type: .SignIn(type: .AppleID))
        setUpVM(model: viewModel)
        AppleLogin.shared.setUpAppleSignIn {[weak self](userDetails, msg) in
            guard  let self = self else {return}
            self.viewModel.socialID = userDetails?.socialId ?? ""
            self.viewModel.signIn(type: .AppleID)
            self.viewModel.didFinishFetch = {[weak self] in
                DispatchQueue.main.async {
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func action_LogIn() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpSelectTypeVC") as? SignUpSelectTypeVC else {
            return
        }
        navigationController?.setViewControllers([vc], animated: true)
    }
}
extension logInSelectTypeVC: InstagramWebViewDelegate {
    func fetchedInstagram(userID: Int) {
        self.viewModel.socialID = "\(userID)"
        self.viewModel.signIn(type: .Instagram)
        self.viewModel.didFinishFetch = {
            DispatchQueue.main.async {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
