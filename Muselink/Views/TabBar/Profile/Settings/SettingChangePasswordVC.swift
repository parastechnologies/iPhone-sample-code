//
//  SettingChangePasswordVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 19/04/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SettingChangePasswordVC: BaseClassVC {
    @IBOutlet weak var btn_back                  : SoftUIView!
    @IBOutlet weak var view_Back                 : SoftUIView!
    @IBOutlet weak var view_Text_OldPassword     : SoftUIView!
    @IBOutlet weak var view_Text_NewPassword     : SoftUIView!
    @IBOutlet weak var view_text_ConfirmPassword : SoftUIView!
    @IBOutlet weak var btn_Submit          : SoftUIView!
    
    private var txt_OldPassword     : BindingTextField? {
        didSet {
            txt_OldPassword?.bind{[unowned self] in self.viewModel.oldPassword.value = $0 }
        }
    }
    private var txt_NewPassword     : BindingTextField?{
        didSet {
            txt_NewPassword?.bind{[unowned self] in self.viewModel.newPassword.value = $0 }
        }
    }
    private var txt_ConfirmPassword : BindingTextField?{
        didSet {
            txt_ConfirmPassword?.bind{[unowned self] in self.viewModel.confirmNewPassword.value = $0 }
        }
    }
    
    var viewModel : SettingsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM(model: viewModel)
        viewModel.selectedValidationType = .ChangePassword
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
        
        view_Back.type             = .normal
        view_Back.cornerRadius     = 10
        view_Back.mainColor        = UIColor.paleGray.cgColor
        view_Back.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
        view_Back.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        view_Back.borderColor      = UIColor.white.cgColor
        view_Back.borderWidth      = 1
        
        view_Text_OldPassword.type             = .normal
        view_Text_OldPassword.isSelected       = true
        view_Text_OldPassword.cornerRadius     = 10
        view_Text_OldPassword.mainColor        = UIColor.paleGray.cgColor
        view_Text_OldPassword.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
        view_Text_OldPassword.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        view_Text_OldPassword.borderColor      = UIColor.white.cgColor
        view_Text_OldPassword.borderWidth      = 2
        txt_OldPassword = view_Text_OldPassword.setBindingTextField(font: .Avenir_Medium(size: 18), placeholder: "Old Password",placeholderColor: .placeholder)
        txt_OldPassword?.isSecureTextEntry = true
        
        view_Text_NewPassword.type             = .normal
        view_Text_NewPassword.isSelected       = true
        view_Text_NewPassword.cornerRadius     = 10
        view_Text_NewPassword.mainColor        = UIColor.paleGray.cgColor
        view_Text_NewPassword.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
        view_Text_NewPassword.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        view_Text_NewPassword.borderColor      = UIColor.white.cgColor
        view_Text_NewPassword.borderWidth      = 2
        txt_NewPassword = view_Text_NewPassword.setBindingTextField(font: .Avenir_Medium(size: 18), placeholder: "New Password",placeholderColor: .placeholder)
        txt_NewPassword?.isSecureTextEntry = true
        
        view_text_ConfirmPassword.type             = .normal
        view_text_ConfirmPassword.isSelected       = true
        view_text_ConfirmPassword.cornerRadius     = 10
        view_text_ConfirmPassword.mainColor        = UIColor.paleGray.cgColor
        view_text_ConfirmPassword.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
        view_text_ConfirmPassword.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        view_text_ConfirmPassword.borderColor      = UIColor.white.cgColor
        view_text_ConfirmPassword.borderWidth      = 2
        txt_ConfirmPassword = view_text_ConfirmPassword.setBindingTextField(font: .Avenir_Medium(size: 18), placeholder: "Confirm New Password",placeholderColor: .placeholder)
        txt_ConfirmPassword?.isSecureTextEntry = true
        
        btn_Submit.type = .pushButton
        btn_Submit.addTarget(self, action: #selector(action_Submit), for: .touchDown)
        btn_Submit.cornerRadius = ((UIScreen.main.bounds.width-40)*29)/374
        btn_Submit.borderColor = UIColor.paleGray.cgColor
        btn_Submit.borderWidth = 5
        btn_Submit.mainColor   = UIColor.brightPurple.cgColor
        btn_Submit.setButtonTitle(font: .Avenir_Medium(size: 25), title: "Submit",titleColor: .white)
    }
    @objc private func action_Submit() {
        if viewModel.isValid {
            viewModel.changePassword()
            viewModel.didFinishChangePassword = {[weak self] in
                DispatchQueue.main.async {
                    self?.showSuccessMessages(message: "Password changes successfully.")
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        else {
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
        }
    }
}
