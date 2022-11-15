//
//  SettingAccountChangePhoneNumPopUp.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 23/04/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SettingAccountChangePhoneNumPopUp: BaseClassVC {
    @IBOutlet weak var btn_Update        : SoftUIView!
    @IBOutlet weak var view_PhoneNumBack : SoftUIView!
    @IBOutlet weak var btn_PhoneCode     : SoftUIView!
    private var phoneLabel               : BindingTextField!{
        didSet {
            phoneLabel?.bind{[unowned self] in self.viewModel.phoneNumber.value = $0 }
        }
    }
    weak var delegate                    : SettingAccountDelegate?
    private var phoneCodeLabel           : UILabel!
    var viewModel : SettingsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM(model: viewModel)
        viewModel.selectedValidationType = .PhoneNumber
        DispatchQueue.main.async{[unowned self] in
            setUpViews()
        }
    }
    private func setUpViews() {
        view_PhoneNumBack.type = .normal
        view_PhoneNumBack.isSelected = true
        view_PhoneNumBack.cornerRadius = view_PhoneNumBack.frame.height/2
        view_PhoneNumBack.mainColor = UIColor.darkBackGround.cgColor
        view_PhoneNumBack.darkShadowColor = UIColor.black.cgColor
        view_PhoneNumBack.lightShadowColor = UIColor.darkGray.cgColor
        phoneLabel = view_PhoneNumBack.setTextFieldithSpacer(font: .AvenirLTPRo_Regular(size: 18), placeholder: "Phone No.", titleColor: .white)
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
            viewModel.changePhoneNumber()
            viewModel.didFinishChangePhoneNo = {[weak self] in
                DispatchQueue.main.async {
                    self?.showSuccessMessages(message: "Phone number changes successfully.")
                    self?.delegate?.refreshScreen()
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        }
        else {
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
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
