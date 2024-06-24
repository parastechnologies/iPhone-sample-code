//
//  AccountSharePopUp.swift
//  Muselink
//
//  Created by HarishParas on 16/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class AccountSharePopUp: UIViewController {
    @IBOutlet weak var btn_Close             : SoftUIView!
    @IBOutlet weak var btn_CopyLink          : SoftUIView!
    @IBOutlet weak var btn_SMS               : SoftUIView!
    @IBOutlet weak var btn_Facebook          : SoftUIView!
    @IBOutlet weak var btn_FacebookMessanger : SoftUIView!
    @IBOutlet weak var btn_More              : SoftUIView!
    @IBOutlet weak var img_UserImage : SoftUIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    private func setUpViews() {
        img_UserImage.type            = .normal
        img_UserImage.cornerRadius    = img_UserImage.frame.height/2
        img_UserImage.mainColor = UIColor.darkBackGround.cgColor
        img_UserImage.darkShadowColor = UIColor.black.cgColor
        img_UserImage.lightShadowColor = UIColor.darkGray.cgColor
        img_UserImage.borderWidth     = 2
        img_UserImage.borderColor     = UIColor.appOrange.cgColor
        img_UserImage.isUserInteractionEnabled = false
        img_UserImage.setProfileImage(image: #imageLiteral(resourceName: "SampleUser"),border_Color: .appOrange,border_Width: 2)
        
        btn_Close.type = .pushButton
        btn_Close.addTarget(self, action: #selector(action_Close), for: .touchDown)
        btn_Close.cornerRadius = 10
        btn_Close.mainColor = UIColor.darkBackGround.cgColor
        btn_Close.darkShadowColor = UIColor.black.cgColor
        btn_Close.lightShadowColor = UIColor.darkGray.cgColor
        btn_Close.borderWidth = 2
        btn_Close.borderColor = UIColor.purple.cgColor
        btn_Close.setButtonTitle(font: .Avenir_Medium(size: 20), title: "Close",titleColor: .paleGray)
        
        btn_CopyLink.type = .pushButton
        btn_CopyLink.addTarget(self, action: #selector(action_Report), for: .touchDown)
        btn_CopyLink.cornerRadius = 10
        btn_CopyLink.mainColor = UIColor.darkBackGround.cgColor
        btn_CopyLink.darkShadowColor = UIColor.black.cgColor
        btn_CopyLink.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_CopyLink.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "report_user"), font: .AvenirLTPRo_Regular(size: 18), title: "Report",titleColor: .white)
        
        btn_SMS.type = .pushButton
        btn_SMS.addTarget(self, action: #selector(action_Block), for: .touchDown)
        btn_SMS.cornerRadius = 10
        btn_SMS.mainColor = UIColor.darkBackGround.cgColor
        btn_SMS.darkShadowColor = UIColor.black.cgColor
        btn_SMS.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_SMS.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "block_user"), font: .AvenirLTPRo_Regular(size: 18), title: "Block",titleColor: .white)
        
        btn_Facebook.type = .pushButton
        btn_Facebook.addTarget(self, action: #selector(action_RemoveMatch), for: .touchDown)
        btn_Facebook.cornerRadius = 10
        btn_Facebook.mainColor = UIColor.darkBackGround.cgColor
        btn_Facebook.darkShadowColor = UIColor.black.cgColor
        btn_Facebook.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_Facebook.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "remove_user"), font: .AvenirLTPRo_Regular(size: 18), title: "Remove Match",titleColor: .white)
        
        btn_FacebookMessanger.type = .pushButton
        btn_FacebookMessanger.addTarget(self, action: #selector(action_Block), for: .touchDown)
        btn_FacebookMessanger.cornerRadius = 10
        btn_FacebookMessanger.mainColor = UIColor.darkBackGround.cgColor
        btn_FacebookMessanger.darkShadowColor = UIColor.black.cgColor
        btn_FacebookMessanger.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_FacebookMessanger.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "block_user"), font: .AvenirLTPRo_Regular(size: 18), title: "Block",titleColor: .white)
        
        btn_More.type = .pushButton
        btn_More.addTarget(self, action: #selector(action_RemoveMatch), for: .touchDown)
        btn_More.cornerRadius = 10
        btn_More.mainColor = UIColor.darkBackGround.cgColor
        btn_More.darkShadowColor = UIColor.black.cgColor
        btn_More.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_More.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "remove_user"), font: .AvenirLTPRo_Regular(size: 18), title: "Remove Match",titleColor: .white)
        
    }
    @objc private func action_Close() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    @objc private func action_Report() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    @objc private func action_Block() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    @objc private func action_RemoveMatch() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}
