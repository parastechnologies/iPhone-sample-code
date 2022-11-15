//
//  SettingAccountVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 12/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
protocol SettingAccountDelegate : class {
    func refreshScreen()
}
class SettingAccountVC: UIViewController {
    enum SendDirectmessage {
        case Everyone
        case PremiumUser
        case PreviouslyMatched
    }
    @IBOutlet weak var btn_back           : SoftUIView!
    @IBOutlet      var view_Back          : [SoftUIView]!
    @IBOutlet      var view_Dot           : [SoftUIView]!
    @IBOutlet weak var view_Back_HideShow : SoftUIView!
    @IBOutlet weak var view_Text_Username : SoftUIView!
    @IBOutlet weak var view_Text_Email    : SoftUIView!
    @IBOutlet weak var view_text_PhoneNo  : SoftUIView!
    @IBOutlet weak var hideShowSwitch     : CustomSwitch! {
        didSet {
            hideShowSwitch.translatesAutoresizingMaskIntoConstraints = false
            hideShowSwitch.addTarget(self, action: #selector(action_Switch_HideShow), for: .valueChanged)
            hideShowSwitch.onTintColor = UIColor.paleGreen
            hideShowSwitch.offTintColor = UIColor.paleGray
            hideShowSwitch.areLabelsShown = true
            hideShowSwitch.cornerRadius = 0.2
            hideShowSwitch.thumbCornerRadius = 0.1
            hideShowSwitch.thumbImage = #imageLiteral(resourceName: "toogle_btn")
            hideShowSwitch.thumbTintColor = UIColor.clear
            hideShowSwitch.animationDuration = 0.25
        }
    }
    @IBOutlet weak var view_Back_YesNo : SoftUIView!
    @IBOutlet weak var yesNoSwitch: CustomSwitch! {
        didSet {
            yesNoSwitch.translatesAutoresizingMaskIntoConstraints = false
            yesNoSwitch.addTarget(self, action: #selector(action_Switch_YesNo), for: .valueChanged)
            yesNoSwitch.onTintColor = UIColor.paleGreen
            yesNoSwitch.offTintColor = UIColor.paleGray
            yesNoSwitch.areLabelsShown = true
            yesNoSwitch.cornerRadius = 0.2
            yesNoSwitch.thumbCornerRadius = 0.1
            yesNoSwitch.thumbImage = #imageLiteral(resourceName: "toogle_btn")
            yesNoSwitch.thumbTintColor = UIColor.clear
            yesNoSwitch.animationDuration = 0.25
        }
    }
    private lazy var dot_selected : UIView = {
        let view = UIView(frame: CGRect(x: ((view_Dot.first?.frame.width ?? 12)/2  - 5.5), y: ((view_Dot.first?.frame.height ?? 12)/2 - 5.5), width: 11, height: 11))
        view.backgroundColor = UIColor.brightPurple
        view.layer.cornerRadius = 5.5
        view.clipsToBounds = true
        return view
    }()
    private var txt_UserName : UITextField?
    private var txt_PhoneNo  : UITextField?
    private var txt_Email    : UITextField?
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
        for view in view_Dot {
            view.addTarget(self, action: #selector(action_Dot(_:)), for: .touchDown)
            view.type             = .pushButton
            view.cornerRadius     = 15
            view.mainColor        = UIColor.paleGray.cgColor
            view.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
            view.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
            view.borderColor      = UIColor.white.cgColor
            view.borderWidth      = 2
        }
        view_Dot.first?.borderColor = UIColor.brightPurple.cgColor
        view_Dot.first?.addSubview(dot_selected)
        
        view_Text_Username.type             = .normal
        view_Text_Username.isSelected       = true
        view_Text_Username.cornerRadius     = 10
        view_Text_Username.mainColor        = UIColor.paleGray.cgColor
        view_Text_Username.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
        view_Text_Username.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        view_Text_Username.borderColor      = UIColor.white.cgColor
        view_Text_Username.borderWidth      = 2
        txt_UserName = view_Text_Username.setTextField(font: .Avenir_Medium(size: 18), placeholder: "Username",placeholderColor: .placeholder)
        txt_UserName?.addTarget(self, action: #selector(action_ChangeUsername), for: .allEvents)
        
        view_Text_Email.type             = .normal
        view_Text_Email.isSelected       = true
        view_Text_Email.cornerRadius     = 10
        view_Text_Email.mainColor        = UIColor.paleGray.cgColor
        view_Text_Email.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
        view_Text_Email.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        view_Text_Email.borderColor      = UIColor.white.cgColor
        view_Text_Email.borderWidth      = 2
        txt_Email = view_Text_Email.setTextField(font: .Avenir_Medium(size: 18), placeholder: "Email",placeholderColor: .placeholder)
        txt_Email?.addTarget(self, action: #selector(action_ChangeEmail), for: .allEvents)
        
        view_text_PhoneNo.type             = .normal
        view_text_PhoneNo.isSelected       = true
        view_text_PhoneNo.cornerRadius     = 10
        view_text_PhoneNo.mainColor        = UIColor.paleGray.cgColor
        view_text_PhoneNo.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
        view_text_PhoneNo.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        view_text_PhoneNo.borderColor      = UIColor.white.cgColor
        view_text_PhoneNo.borderWidth      = 2
        txt_PhoneNo = view_text_PhoneNo.setTextField(font: .Avenir_Medium(size: 18), placeholder: "Phone No.",placeholderColor: .placeholder)
        txt_PhoneNo?.addTarget(self, action: #selector(action_ChangePhoneNumber), for: .allEvents)
        
        view_Back_HideShow.type             = .normal
        view_Back_HideShow.mainColor        = UIColor.paleGreen.cgColor
        view_Back_HideShow.isSelected       = true
        view_Back_HideShow.cornerRadius     = 10
        view_Back_HideShow.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
        view_Back_HideShow.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        view_Back_HideShow.borderColor      = UIColor.white.cgColor
        view_Back_HideShow.borderWidth      = 2
        
        view_Back_YesNo.type             = .normal
        view_Back_YesNo.mainColor        = UIColor.paleGreen.cgColor
        view_Back_YesNo.isSelected       = true
        view_Back_YesNo.cornerRadius     = 10
        view_Back_YesNo.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
        view_Back_YesNo.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        view_Back_YesNo.borderColor      = UIColor.white.cgColor
        view_Back_YesNo.borderWidth      = 2
        
        if let detail = viewModel.settingDetails {
            txt_UserName?.text  = detail.userName
            txt_Email?.text     = detail.email
            txt_PhoneNo?.text   = detail.phone
            
            if detail.accountStatus   ?? "0" == "1" {
                hideShowSwitch.isOn = true
                view_Back_HideShow.mainColor = UIColor.paleGreen.cgColor
            }
            else {
                hideShowSwitch.isOn = false
                view_Back_HideShow.mainColor = UIColor.paleGray.cgColor
            }
            
            if detail.soundFileStatus   ?? "0" == "1" {
                yesNoSwitch.isOn = true
                view_Back_YesNo.mainColor = UIColor.paleGreen.cgColor
            }
            else {
                yesNoSwitch.isOn = false
                view_Back_YesNo.mainColor = UIColor.paleGray.cgColor
            }
            
            if let directMsgStatus = Int(detail.directMessageStatus ?? "0") {
                for view in view_Dot.enumerated() {
                    if view.element.tag == directMsgStatus+1 {
                        view.element.borderColor = UIColor.brightPurple.cgColor
                        view.element.addSubview(dot_selected)
                    }
                    else {
                        view.element.borderColor = UIColor.white.cgColor
                    }
                }
            }
        }
    }
    
    @objc private func action_Back() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func action_ChangeUsername() {
        view.endEditing(true)
        let VC = storyboard?.instantiateViewController(withIdentifier: "ChangeUsernameNav") as? UINavigationController
        if let initVC = VC?.viewControllers.first as? SettingAccountChangeUserNamePopUp {
            initVC.viewModel = viewModel
            initVC.delegate  = self
        }
        VC?.modalPresentationStyle = .custom
        VC?.transitioningDelegate = self
        navigationController?.present(VC!, animated: true, completion: nil)
    }
    
    @objc private func action_ChangeEmail() {
        view.endEditing(true)
        let VC = storyboard?.instantiateViewController(withIdentifier: "ChangeEmailNav") as? UINavigationController
        if let initVC = VC?.viewControllers.first as? SettingAccountChangeEmailPopUp {
            initVC.viewModel = viewModel
            initVC.delegate  = self
        }
        VC?.modalPresentationStyle = .custom
        VC?.transitioningDelegate = self
        navigationController?.present(VC!, animated: true, completion: nil)
    }
    
    @objc private func action_ChangePhoneNumber() {
        view.endEditing(true)
        let VC = storyboard?.instantiateViewController(withIdentifier: "EhangePhoneNumberNav") as? UINavigationController
        if let initVC = VC?.viewControllers.first as? SettingAccountChangePhoneNumPopUp {
            initVC.viewModel = viewModel
            initVC.delegate  = self
        }
        VC?.modalPresentationStyle = .custom
        VC?.transitioningDelegate = self
        navigationController?.present(VC!, animated: true, completion: nil)
    }
    @objc private func action_Switch_HideShow() {
        if hideShowSwitch.isOn {
            view_Back_HideShow.mainColor = UIColor.paleGreen.cgColor
        }
        else {
            view_Back_HideShow.mainColor = UIColor.paleGray.cgColor
        }
        viewModel.updateAccountPermissionStatus(for: .explorer, status: hideShowSwitch.isOn ? "1" : "0")
    }
    
    @objc private func action_Switch_YesNo() {
        if yesNoSwitch.isOn {
            view_Back_YesNo.mainColor = UIColor.paleGreen.cgColor
        }
        else {
            view_Back_YesNo.mainColor = UIColor.paleGray.cgColor
        }
        viewModel.updateAccountPermissionStatus(for: .share, status: yesNoSwitch.isOn ? "1" : "0")
    }
    
    @objc private func action_Dot(_ sender:SoftUIView) {
        for view in view_Dot.enumerated() {
            if view.element.tag == sender.tag {
                view.element.borderColor = UIColor.brightPurple.cgColor
                view.element.addSubview(dot_selected)
            }
            else {
                view.element.borderColor = UIColor.white.cgColor
            }
        }
        viewModel.updateAccountPermissionStatus(for: .directMessage, status: "\(sender.tag-1)")
    }
    
    @IBAction func action_Blocklist() {
        performSegue(withIdentifier: "blockedList", sender: self)
    }
    
    @IBAction func action_ShareAccount() {
        let VC = storyboard?.instantiateViewController(withIdentifier: "AccountShareNavVC") as? UINavigationController
        VC?.modalPresentationStyle = .custom
        VC?.transitioningDelegate = self
        navigationController?.present(VC!, animated: true, completion: nil)
    }
    
    @IBAction func action_ChangePassword() {
        performSegue(withIdentifier: "changePassword", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "blockedList" {
            guard let vc = segue.destination as? SettingBlockListVC else {
                return
            }
            vc.viewModel = viewModel
        }
        else if segue.identifier == "changePassword" {
            guard let vc = segue.destination as? SettingChangePasswordVC else {
                return
            }
            vc.viewModel = viewModel
        }
    }
}
extension SettingAccountVC: SettingAccountDelegate {
    func refreshScreen() {
        if let detail = viewModel.settingDetails {
            txt_UserName?.text  = detail.userName
            txt_Email?.text     = detail.email
            txt_PhoneNo?.text   = detail.phone
        }
    }
}
extension SettingAccountVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
