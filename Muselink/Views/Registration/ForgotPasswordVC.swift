//
//  ForgotPasswordVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 25/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseClassVC {
    @IBOutlet weak var btn_Continue           : SoftUIView!
    @IBOutlet weak var view_EmailBack         : SoftUIView!
    private var continueLabel : UILabel!
    private var isPhoneSignUp = true
    private var emailLabel    : BindingTextField! {
        didSet {emailLabel.bind{[unowned self] in self.viewModel.email.value = $0 }}
    }
    var viewModel : RegistrationViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RegistrationViewModel(type: .Forget)
        setUpVM(model: viewModel)
        DispatchQueue.main.async{[unowned self] in
            setUpViews()
        }
    }
    private func setUpViews() {
        view_EmailBack.type = .normal
        view_EmailBack.isSelected = true
        view_EmailBack.cornerRadius = view_EmailBack.frame.height/2
        view_EmailBack.mainColor = UIColor.darkBackGround.cgColor
        view_EmailBack.darkShadowColor = UIColor.black.cgColor
        view_EmailBack.lightShadowColor = UIColor.darkGray.cgColor
        emailLabel = view_EmailBack.setTextFieldithImageAndSpacer(img: #imageLiteral(resourceName: "mail_select"), font: .AvenirLTPRo_Regular(size: 18), placeholder: "Email", titleColor: .white)
        emailLabel.keyboardType = .emailAddress
        
        btn_Continue.type = .pushButton
        btn_Continue.addTarget(self, action: #selector(action_Continue), for: .touchDown)
        btn_Continue.cornerRadius = btn_Continue.frame.height/2
        btn_Continue.mainColor = UIColor.darkBackGround.cgColor
        btn_Continue.darkShadowColor = UIColor.black.cgColor
        btn_Continue.lightShadowColor = UIColor.darkGray.cgColor
        btn_Continue.borderWidth = 2
        btn_Continue.borderColor = UIColor.purple.cgColor
        continueLabel = btn_Continue.setButtonTitle(font: .Avenir_Medium(size: 20), title: "Continue",titleColor: .paleGray)
    }
    @objc private func action_Continue() {
        if viewModel.isValid {
            viewModel.forgetPassword()
            viewModel.didFinishFetch = {[unowned self] in
                DispatchQueue.main.async {
                    showSuccessMessages(message: "Successfully sent reset link.")
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                    navigationController?.popViewController(animated: true)
                })
            }
        }
        else {
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
        }
    }
}
