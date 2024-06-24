//
//  GotMatchUserVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 17/06/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class GotMatchUserVC: UIViewController {
    @IBOutlet weak var btn_StartChatting : SoftUIView!
    @IBOutlet weak var btn_Skip          : SoftUIView!
    @IBOutlet weak var lbl_ConnectedUser : UILabel!
    @IBOutlet weak var img_MyImage       : UIImageView!
    @IBOutlet weak var img_OtherUserImg  : UIImageView!
    var otherUserName = String()
    var otheruserID   = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidLayoutSubviews() {
        img_MyImage.layer.cornerRadius = img_MyImage.bounds.height/2
        img_MyImage.layer.masksToBounds = true
        img_OtherUserImg.layer.cornerRadius = img_OtherUserImg.bounds.height/2
        img_OtherUserImg.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    private func setUpViews() {
        btn_StartChatting.type = .pushButton
        btn_StartChatting.addTarget(self, action: #selector(action_StartChatting), for: .touchDown)
        btn_StartChatting.cornerRadius = btn_StartChatting.frame.height/2
        btn_StartChatting.mainColor = UIColor.skyBlue.cgColor
        btn_StartChatting.darkShadowColor = UIColor.black.cgColor
        btn_StartChatting.lightShadowColor = UIColor.darkGray.cgColor
        btn_StartChatting.borderWidth = 4
        btn_StartChatting.borderColor = UIColor.black.cgColor
        btn_StartChatting.setButtonTitle(font: .Avenir_Medium(size: 25), title: "Start Chatting",titleColor: .white)
        
        btn_Skip.type = .pushButton
        btn_Skip.addTarget(self, action: #selector(action_Skip), for: .touchDown)
        btn_Skip.cornerRadius = btn_Skip.frame.height/2
        btn_Skip.mainColor = UIColor.darkBackGround.cgColor
        btn_Skip.darkShadowColor = UIColor.black.cgColor
        btn_Skip.lightShadowColor = UIColor.darkGray.cgColor
        btn_Skip.borderWidth = 2
        btn_Skip.borderColor = UIColor.purple.cgColor
        btn_Skip.setButtonTitle(font: .Avenir_Medium(size: 25), title: "Skip",titleColor: .white)
    }
    @objc private func action_StartChatting() {
        let storyboard = UIStoryboard(name: "Chat", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.receiverID   = otherUserName
        vc.receiverName = "\(otheruserID)"
        vc.isFromMatch  = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func action_Skip() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
