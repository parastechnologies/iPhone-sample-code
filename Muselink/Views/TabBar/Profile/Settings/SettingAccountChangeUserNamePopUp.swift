//
//  SettingAccountChangeUserNamePopUp.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 23/04/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SettingAccountChangeUserNamePopUp: BaseClassVC {
    @IBOutlet weak var btn_Update        : SoftUIView!
    @IBOutlet weak var view_UsernameBack : SoftUIView!
    private var usernameLabel            : BindingTextField!{
        didSet {
            usernameLabel?.bind{[unowned self] in self.viewModel.userName.value = $0 }
        }
    }
    var viewModel                        : SettingsViewModel!
    weak var delegate                    : SettingAccountDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM(model: viewModel)
        viewModel.selectedValidationType = .Username
        DispatchQueue.main.async{[unowned self] in
            setUpViews()
        }
    }
    private func setUpViews() {
        view_UsernameBack.type = .normal
        view_UsernameBack.isSelected = true
        view_UsernameBack.cornerRadius = view_UsernameBack.frame.height/2
        view_UsernameBack.mainColor = UIColor.darkBackGround.cgColor
        view_UsernameBack.darkShadowColor = UIColor.black.cgColor
        view_UsernameBack.lightShadowColor = UIColor.darkGray.cgColor
        usernameLabel = view_UsernameBack.setTextFieldithImageAndSpacer(img: #imageLiteral(resourceName: "mail_select"), font: .AvenirLTPRo_Regular(size: 18), placeholder: "Username", titleColor: .white)
        
        btn_Update.type = .pushButton
        btn_Update.addTarget(self, action: #selector(action_Continue), for: .touchDown)
        btn_Update.cornerRadius = btn_Update.frame.height/2
        btn_Update.mainColor = UIColor.darkBackGround.cgColor
        btn_Update.darkShadowColor = UIColor.black.cgColor
        btn_Update.lightShadowColor = UIColor.darkGray.cgColor
        btn_Update.borderWidth = 2
        btn_Update.borderColor = UIColor.purple.cgColor
        btn_Update.setButtonTitle(font: .Avenir_Medium(size: 20), title: "Update",titleColor: .paleGray)
    }
    @objc private func action_Continue() {
        if viewModel.isValid {
            viewModel.changeUserName()
            viewModel.didFinishChangeusername = {[weak self] in
                DispatchQueue.main.async {
                    self?.showSuccessMessages(message: "Username changes successfully.")
                    self?.delegate?.refreshScreen()
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        }
        else {
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
        }
    }
}
