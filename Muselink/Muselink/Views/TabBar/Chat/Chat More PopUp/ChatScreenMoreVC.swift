//
//  ChatScreenMoreVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 27/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class ChatScreenMoreVC: UIViewController {
    @IBOutlet weak var btn_Close       : SoftUIView!
    @IBOutlet weak var btn_Report      : SoftUIView!
    @IBOutlet weak var btn_Block       : SoftUIView!
    @IBOutlet weak var btn_RemoveMatch : SoftUIView!
    @IBOutlet weak var img_UserImage   : SoftUIView!
    var callback_Report      :(()->())?
    var callback_Block       :(()->())?
    var callback_RemoveMatch :(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        img_UserImage.cornerRadius    = img_UserImage.frame.height/2
        img_UserImage.setProfileImage(image: #imageLiteral(resourceName: "SampleUser"),border_Color: .appOrange,border_Width: 2)
        img_UserImage.layoutIfNeeded()
    }
    private func setUpViews() {
        img_UserImage.type            = .normal
        img_UserImage.mainColor = UIColor.darkBackGround.cgColor
        img_UserImage.darkShadowColor = UIColor.black.cgColor
        img_UserImage.cornerRadius    = img_UserImage.frame.height/2
        img_UserImage.lightShadowColor = UIColor.darkGray.cgColor
        img_UserImage.isUserInteractionEnabled = false
        
        btn_Close.type = .pushButton
        btn_Close.addTarget(self, action: #selector(action_Close), for: .touchDown)
        btn_Close.cornerRadius = 10
        btn_Close.mainColor = UIColor.darkBackGround.cgColor
        btn_Close.darkShadowColor = UIColor.black.cgColor
        btn_Close.lightShadowColor = UIColor.darkGray.cgColor
        btn_Close.borderWidth = 2
        btn_Close.borderColor = UIColor.purple.cgColor
        btn_Close.setButtonTitle(font: .Avenir_Medium(size: 20), title: "Close",titleColor: .paleGray)
        
        btn_Report.type = .pushButton
        btn_Report.addTarget(self, action: #selector(action_Report), for: .touchDown)
        btn_Report.cornerRadius = 10
        btn_Report.mainColor = UIColor.darkBackGround.cgColor
        btn_Report.darkShadowColor = UIColor.black.cgColor
        btn_Report.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_Report.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "report_user"), font: .AvenirLTPRo_Regular(size: 18), title: "Report",titleColor: .white)
        
        btn_Block.type = .pushButton
        btn_Block.addTarget(self, action: #selector(action_Block), for: .touchDown)
        btn_Block.cornerRadius = 10
        btn_Block.mainColor = UIColor.darkBackGround.cgColor
        btn_Block.darkShadowColor = UIColor.black.cgColor
        btn_Block.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_Block.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "block_user"), font: .AvenirLTPRo_Regular(size: 18), title: "Block",titleColor: .white)
        
        btn_RemoveMatch.type = .pushButton
        btn_RemoveMatch.addTarget(self, action: #selector(action_RemoveMatch), for: .touchDown)
        btn_RemoveMatch.cornerRadius = 10
        btn_RemoveMatch.mainColor = UIColor.darkBackGround.cgColor
        btn_RemoveMatch.darkShadowColor = UIColor.black.cgColor
        btn_RemoveMatch.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_RemoveMatch.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "remove_user"), font: .AvenirLTPRo_Regular(size: 18), title: "Remove Match",titleColor: .white)
        
    }
    @objc private func action_Close() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    @objc private func action_Report() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            self.callback_Report?()
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    @objc private func action_Block() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            self.callback_Block?()
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    @objc private func action_RemoveMatch() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            self.callback_RemoveMatch?()
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}
