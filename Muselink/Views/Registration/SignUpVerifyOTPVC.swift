//
//  SignUpVerifyOTPVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 08/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SignUpVerifyOTPVC: BaseClassVC {
    @IBOutlet weak var btn_VerifyCode : SoftUIView!
    @IBOutlet weak var btn_back       : SoftUIView!
    @IBOutlet weak var otpView        : VPMOTPView!
    var viewModel : RegistrationViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        otpView.delegate = self
        otpView.shouldAllowIntermediateEditing = false
        otpView.initializeUI()
        setUpVM(model: viewModel)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    private func setUpViews() {
        btn_back.type = .pushButton
        btn_back.addTarget(self, action: #selector(action_Back), for: .touchDown)
        btn_back.cornerRadius = 10
        btn_back.mainColor = UIColor.darkBackGround.cgColor
        btn_back.darkShadowColor = UIColor.black.cgColor
        btn_back.lightShadowColor = UIColor.darkGray.cgColor
        btn_back.setButtonImage(image: #imageLiteral(resourceName: "icon_back"))
        
        btn_VerifyCode.type = .pushButton
        btn_VerifyCode.addTarget(self, action: #selector(action_VerifyCode), for: .touchDown)
        btn_VerifyCode.cornerRadius = btn_VerifyCode.frame.height/2
        btn_VerifyCode.mainColor = UIColor.darkBackGround.cgColor
        btn_VerifyCode.darkShadowColor = UIColor.black.cgColor
        btn_VerifyCode.lightShadowColor = UIColor.darkGray.cgColor
        btn_VerifyCode.borderWidth = 2
        btn_VerifyCode.borderColor = UIColor.purple.cgColor
        btn_VerifyCode.setButtonTitle(font: .Avenir_Medium(size: 20), title: "Verify Code",titleColor: .paleGray)
    }
    @objc private func action_VerifyCode() {
        viewModel.verifyCode()
        viewModel.didFinishFetch = {[unowned self] in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { [unowned self] in
                guard let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpSuccessVC") as? SignUpSuccessVC else {
                    return
                }
                
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
extension SignUpVerifyOTPVC: VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return hasEntered
    }
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    func enteredOTP(otpString: String) {
        print("OTPString: \(otpString)")
        viewModel.verificationCode = otpString
    }
}
