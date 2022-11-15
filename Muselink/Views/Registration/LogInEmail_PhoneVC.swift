//
//  LogInEmail_PhoneVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 25/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class LogInEmail_PhoneVC: BaseClassVC {
    @IBOutlet weak var btn_Continue           : SoftUIView!
    @IBOutlet weak var view_SegmentBack       : SoftUIView!
    @IBOutlet weak var view_SegmentBack_inner : SoftUIView!
    @IBOutlet weak var view_EmailBack         : SoftUIView!
    @IBOutlet weak var view_PasswordBack      : SoftUIView!
    @IBOutlet weak var view_PhoneBack         : SoftUIView!
    @IBOutlet weak var btn_PhoneCode          : SoftUIView!
    @IBOutlet weak var view_EmailSignUpBack   : UIView!
    @IBOutlet weak var view_PhoneSignUpBack   : UIView!
    private var emailLabel    : BindingTextField! {
        didSet {emailLabel.bind{[unowned self] in self.viewModel.email.value = $0 }}
    }
    private var passwordLabel : BindingTextField!{
        didSet {passwordLabel.bind{[unowned self] in self.viewModel.password.value = $0 }}
    }
    private var phoneLabel    : BindingTextField!{
        didSet {phoneLabel.bind{[unowned self] in self.viewModel.phone.value = $0 }}
    }
    private var continueLabel  : UILabel!
    private var phoneCodeLabel : UILabel!
    private var isPhoneSignUp = true
    var viewModel : RegistrationViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RegistrationViewModel(type: .SignIn(type: .Phone))
        DispatchQueue.main.async{[unowned self] in
            setUpViews()
        }
    }
    private func setUpViews() {
        view_SegmentBack.type = .normal
        view_SegmentBack.cornerRadius = view_SegmentBack.frame.height/2
        view_SegmentBack.mainColor = UIColor.darkBackGround.cgColor
        view_SegmentBack.darkShadowColor = UIColor.black.cgColor
        view_SegmentBack.lightShadowColor = UIColor.darkGray.cgColor

        view_SegmentBack_inner.type = .normal
        view_SegmentBack_inner.isSelected = true
        view_SegmentBack_inner.cornerRadius = view_SegmentBack.frame.height/2
        view_SegmentBack_inner.mainColor = UIColor.darkBackGround.cgColor
        view_SegmentBack_inner.darkShadowColor = UIColor.black.cgColor
        view_SegmentBack_inner.lightShadowColor = UIColor.darkGray.cgColor

        
        view_EmailBack.type = .normal
        view_EmailBack.isSelected = true
        view_EmailBack.cornerRadius = view_EmailBack.frame.height/2
        view_EmailBack.mainColor = UIColor.darkBackGround.cgColor
        view_EmailBack.darkShadowColor = UIColor.black.cgColor
        view_EmailBack.lightShadowColor = UIColor.darkGray.cgColor
        emailLabel = view_EmailBack.setTextFieldithImageAndSpacer(img: #imageLiteral(resourceName: "mail_select"), font: .AvenirLTPRo_Regular(size: 18), placeholder: "Email", titleColor: .white)
        emailLabel.keyboardType = .emailAddress
        
        view_PasswordBack.type = .normal
        view_PasswordBack.isSelected = true
        view_PasswordBack.cornerRadius = view_PasswordBack.frame.height/2
        view_PasswordBack.mainColor = UIColor.darkBackGround.cgColor
        view_PasswordBack.darkShadowColor = UIColor.black.cgColor
        view_PasswordBack.lightShadowColor = UIColor.darkGray.cgColor
        passwordLabel = view_PasswordBack.setTextFieldithImageAndSpacer(img: #imageLiteral(resourceName: "lock_select"), font: .AvenirLTPRo_Regular(size: 18), placeholder: "Password", titleColor: .white)
        passwordLabel.isSecureTextEntry = true
        
        view_PhoneBack.type = .normal
        view_PhoneBack.isSelected = true
        view_PhoneBack.cornerRadius = view_PhoneBack.frame.height/2
        view_PhoneBack.mainColor = UIColor.darkBackGround.cgColor
        view_PhoneBack.darkShadowColor = UIColor.black.cgColor
        view_PhoneBack.lightShadowColor = UIColor.darkGray.cgColor
        phoneLabel = view_PhoneBack.setTextFieldithSpacer(font: .AvenirLTPRo_Regular(size: 18), placeholder: "Phone", titleColor: .white)
        phoneLabel.keyboardType = .phonePad
        
        btn_PhoneCode.type = .pushButton
        btn_PhoneCode.cornerRadius = btn_PhoneCode.frame.height/2
        btn_PhoneCode.mainColor = UIColor.darkBackGround.cgColor
        btn_PhoneCode.darkShadowColor = UIColor.black.cgColor
        btn_PhoneCode.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_PhoneCode.borderWidth = 1
        btn_PhoneCode.borderColor = UIColor.black.cgColor
        phoneCodeLabel = btn_PhoneCode.setButtonTitle(font: .Avenir_Medium(size: 18), title: "+91", titleColor: .white)
        btn_PhoneCode.addTarget(self, action: #selector(action_CountryCodePicker), for: .touchDown)
        
        
        btn_Continue.type = .pushButton
        btn_Continue.addTarget(self, action: #selector(action_Continue), for: .touchDown)
        btn_Continue.cornerRadius = btn_Continue.frame.height/2
        btn_Continue.mainColor        = UIColor.darkBackGround.cgColor
        btn_Continue.darkShadowColor  = UIColor.black.cgColor
        btn_Continue.lightShadowColor = UIColor.darkGray.cgColor
        btn_Continue.borderWidth      = 2
        btn_Continue.borderColor      = UIColor.purple.cgColor
        continueLabel = btn_Continue.setButtonTitle(font: .Avenir_Medium(size: 20), title: "Continue",titleColor: .paleGray)
        
        if isPhoneSignUp {
            view_EmailSignUpBack.isHidden = true
            view_PhoneSignUpBack.isHidden = false
            continueLabel.text = "Send Code"
        }
        else {
            view_EmailSignUpBack.isHidden = false
            view_PhoneSignUpBack.isHidden = true
            continueLabel.text = "Continue"
        }
    }
    @IBAction private func action_ForgetPassword() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func action_Continue() {
        setUpVM(model: viewModel)
        if isPhoneSignUp {
            if viewModel.isValid {
                viewModel.signIn(type: .Phone)
                viewModel.didFinishFetch = {[unowned self] in
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
                        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpVerifyOTPVC") as? SignUpVerifyOTPVC else {
                            return
                        }
                        vc.viewModel = viewModel
                        navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            else {
                showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
            }
        }
        else {
            if viewModel.isValid {
                viewModel.signIn(type: .Email)
                viewModel.didFinishFetch = {[unowned self] in
                    DispatchQueue.main.async {
                        navigationController?.dismiss(animated: true, completion: nil)
                    }
                }
            }
            else {
                showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
            }
        }
    }
    @IBAction func action_Email_Phone_Segment(_ sender: CustomSegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
           isPhoneSignUp                  = true
            continueLabel.text            = "Send Code"
            view_EmailSignUpBack.isHidden = true
            view_PhoneSignUpBack.isHidden = false
            viewModel = RegistrationViewModel(type: .SignIn(type: .Phone))
        }
        else {
            isPhoneSignUp                 = false
            continueLabel.text            = "Continue"
            view_EmailSignUpBack.isHidden = false
            view_PhoneSignUpBack.isHidden = true
            viewModel = RegistrationViewModel(type: .SignIn(type: .Email))
        }
    }
    @objc private func action_CountryCodePicker(){
        guard let  listVC = self.storyboard?.instantiateViewController(withIdentifier: "CountryListTable") as? CountryListTable else { return }
        listVC.countryID = {[weak self] (countryName,code) in
            guard  let self = self else {
                return
            }
            self.phoneCodeLabel.text = code
            self.viewModel.phoneCode.value = code
        }
        self.present(listVC, animated: true, completion: nil)
    }
}
