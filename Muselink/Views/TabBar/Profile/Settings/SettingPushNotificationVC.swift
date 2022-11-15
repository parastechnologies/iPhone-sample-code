//
//  SettingPushNotificationVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 14/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SettingPushNotificationVC: UIViewController {
    @IBOutlet weak var btn_back           : SoftUIView!
    @IBOutlet      var view_Back          : [SoftUIView]!
    @IBOutlet weak var view_Back_Admirer : SoftUIView!
    @IBOutlet weak var admirerSwitch     : CustomSwitch! {
        didSet {
            admirerSwitch.translatesAutoresizingMaskIntoConstraints = false
            admirerSwitch.addTarget(self, action: #selector(action_Switch_Admirer), for: .valueChanged)
            admirerSwitch.onTintColor = UIColor.paleGreen
            admirerSwitch.offTintColor = UIColor.paleGray
            admirerSwitch.areLabelsShown = true
            admirerSwitch.cornerRadius = 0.2
            admirerSwitch.thumbCornerRadius = 0.1
            admirerSwitch.thumbImage = #imageLiteral(resourceName: "toogle_btn")
            admirerSwitch.thumbTintColor = UIColor.clear
            admirerSwitch.animationDuration = 0.25
        }
    }
    @IBOutlet weak var view_Back_Match : SoftUIView!
    @IBOutlet weak var matchSwitch: CustomSwitch! {
        didSet {
            matchSwitch.translatesAutoresizingMaskIntoConstraints = false
            matchSwitch.addTarget(self, action: #selector(action_Switch_Match), for: .valueChanged)
            matchSwitch.onTintColor = UIColor.paleGreen
            matchSwitch.offTintColor = UIColor.paleGray
            matchSwitch.areLabelsShown = true
            matchSwitch.cornerRadius = 0.2
            matchSwitch.thumbCornerRadius = 0.1
            matchSwitch.thumbImage = #imageLiteral(resourceName: "toogle_btn")
            matchSwitch.thumbTintColor = UIColor.clear
            matchSwitch.animationDuration = 0.25
        }
    }
    @IBOutlet weak var view_Back_Message : SoftUIView!
    @IBOutlet weak var messageSwitch     : CustomSwitch! {
        didSet {
            messageSwitch.translatesAutoresizingMaskIntoConstraints = false
            messageSwitch.addTarget(self, action: #selector(action_Switch_Message), for: .valueChanged)
            messageSwitch.onTintColor = UIColor.paleGreen
            messageSwitch.offTintColor = UIColor.paleGray
            messageSwitch.areLabelsShown = true
            messageSwitch.cornerRadius = 0.2
            messageSwitch.thumbCornerRadius = 0.1
            messageSwitch.thumbImage = #imageLiteral(resourceName: "toogle_btn")
            messageSwitch.thumbTintColor = UIColor.clear
            messageSwitch.animationDuration = 0.25
        }
    }
    @IBOutlet weak var view_Back_Upload : SoftUIView!
    @IBOutlet weak var uploadSwitch: CustomSwitch! {
        didSet {
            uploadSwitch.translatesAutoresizingMaskIntoConstraints = false
            uploadSwitch.addTarget(self, action: #selector(action_Switch_Upload), for: .valueChanged)
            uploadSwitch.onTintColor = UIColor.paleGreen
            uploadSwitch.offTintColor = UIColor.paleGray
            uploadSwitch.areLabelsShown = true
            uploadSwitch.cornerRadius = 0.2
            uploadSwitch.thumbCornerRadius = 0.1
            uploadSwitch.thumbImage = #imageLiteral(resourceName: "toogle_btn")
            uploadSwitch.thumbTintColor = UIColor.clear
            uploadSwitch.animationDuration = 0.25
        }
    }
    var viewModel : SettingsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    private func setUpViews() {
        btn_back.type = .pushButton
        btn_back.addTarget(self, action: #selector(action_Back), for: .touchDown)
        btn_back.cornerRadius = 10
        btn_back.mainColor = UIColor.paleGray.cgColor
        btn_back.darkShadowColor = UIColor(white: 0, alpha: 0.20).cgColor
        btn_back.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        btn_back.borderWidth = 1
        btn_back.borderColor = UIColor.white.cgColor
        btn_back.setButtonImage(image: #imageLiteral(resourceName: "Back_black"))
        
        for view in view_Back {
            view.type             = .normal
            view.cornerRadius     = 10
            view.mainColor        = UIColor.paleGray.cgColor
            view.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
            view.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
            view.borderWidth = 1
            view.borderColor = UIColor.white.cgColor
        }
        
        view_Back_Admirer.type             = .normal
        view_Back_Admirer.mainColor        = UIColor.paleGreen.cgColor
        view_Back_Admirer.isSelected       = true
        view_Back_Admirer.cornerRadius     = 10
        view_Back_Admirer.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
        view_Back_Admirer.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        
        view_Back_Match.type             = .normal
        view_Back_Match.mainColor        = UIColor.paleGreen.cgColor
        view_Back_Match.isSelected       = true
        view_Back_Match.cornerRadius     = 10
        view_Back_Match.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
        view_Back_Match.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        
        view_Back_Message.type             = .normal
        view_Back_Message.mainColor        = UIColor.paleGreen.cgColor
        view_Back_Message.isSelected       = true
        view_Back_Message.cornerRadius     = 10
        view_Back_Message.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
        view_Back_Message.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        
        view_Back_Upload.type             = .normal
        view_Back_Upload.mainColor        = UIColor.paleGreen.cgColor
        view_Back_Upload.isSelected       = true
        view_Back_Upload.cornerRadius     = 10
        view_Back_Upload.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
        view_Back_Upload.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        
        if let detail = viewModel.settingDetails {
            if detail.newAdmirerNotificationStatus   ?? "0" == "1" {
                admirerSwitch.isOn = true
                view_Back_Admirer.mainColor = UIColor.paleGreen.cgColor
            }
            else {
                admirerSwitch.isOn = false
                view_Back_Admirer.mainColor = UIColor.paleGray.cgColor
            }
            
            if detail.newMessageNotificationStatus   ?? "0" == "1" {
                messageSwitch.isOn = true
                view_Back_Message.mainColor = UIColor.paleGreen.cgColor
            }
            else {
                messageSwitch.isOn = false
                view_Back_Message.mainColor = UIColor.paleGray.cgColor
            }
            
            if detail.newMatchNotificationStatus   ?? "0" == "1" {
                matchSwitch.isOn = true
                view_Back_Match.mainColor = UIColor.paleGreen.cgColor
            }
            else {
                matchSwitch.isOn = false
                view_Back_Match.mainColor = UIColor.paleGray.cgColor
            }
            
            if detail.newMatchFileNotificationStatus   ?? "0" == "1" {
                uploadSwitch.isOn = true
                view_Back_Upload.mainColor = UIColor.paleGreen.cgColor
            }
            else {
                uploadSwitch.isOn = false
                view_Back_Upload.mainColor = UIColor.paleGray.cgColor
            }
        }
    }
    @objc private func action_Back() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc private func action_Switch_Admirer() {
        if admirerSwitch.isOn {
            view_Back_Admirer.mainColor = UIColor.paleGreen.cgColor
        }
        else {
            view_Back_Admirer.mainColor = UIColor.paleGray.cgColor
        }
        viewModel.updateNotificationStatus(for: .newAdmirer, status: admirerSwitch.isOn)
    }
    @objc private func action_Switch_Message() {
        if messageSwitch.isOn {
            view_Back_Message.mainColor = UIColor.paleGreen.cgColor
        }
        else {
            view_Back_Message.mainColor = UIColor.paleGray.cgColor
        }
        viewModel.updateNotificationStatus(for: .newMessage, status: messageSwitch.isOn)
    }
    @objc private func action_Switch_Match() {
        if matchSwitch.isOn {
            view_Back_Match.mainColor = UIColor.paleGreen.cgColor
        }
        else {
            view_Back_Match.mainColor = UIColor.paleGray.cgColor
        }
        viewModel.updateNotificationStatus(for: .newMatch, status: matchSwitch.isOn)
    }
    @objc private func action_Switch_Upload() {
        if uploadSwitch.isOn {
            view_Back_Upload.mainColor = UIColor.paleGreen.cgColor
        }
        else {
            view_Back_Upload.mainColor = UIColor.paleGray.cgColor
        }
        viewModel.updateNotificationStatus(for: .uploadNewFile, status: uploadSwitch.isOn)
    }
}
