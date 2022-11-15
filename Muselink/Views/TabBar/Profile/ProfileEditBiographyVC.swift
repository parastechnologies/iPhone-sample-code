//
//  ProfileEditBiographyVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 01/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class ProfileEditBiographyVC: BaseClassVC {
    @IBOutlet weak var btn_back            : SoftUIView!
    @IBOutlet weak var View_Description    : SoftUIView!
    @IBOutlet weak var txtView_Description : SoftUIView!
    @IBOutlet weak var btn_Submit          : SoftUIView!
    @IBOutlet weak var lbl_WordLength      : UILabel!
    
    private        var desctext            : UITextView! {
        didSet {
            desctext.delegate = self
            desctext.text = "Enter Biography"
            desctext.textColor = UIColor.lightGray
        }
    }
    var viewModel : ProfileViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM(model: viewModel)
        viewModel.screenType = .editBiography
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
        
        View_Description.type = .normal
        View_Description.cornerRadius = 10
        View_Description.mainColor = UIColor.paleGray.cgColor
        View_Description.isUserInteractionEnabled = true
        
        txtView_Description.type             = .normal
        txtView_Description.isSelected       = true
        txtView_Description.cornerRadius     = 10
        txtView_Description.mainColor        = UIColor.paleGray.cgColor
        txtView_Description.borderWidth      = 2
        txtView_Description.borderColor      = UIColor.white.cgColor
        txtView_Description.isUserInteractionEnabled = true
        desctext = txtView_Description.setTextView(font: .AvenirLTPRo_Regular(size: 16), textColor: .darkBackGround)
        desctext.text = viewModel.aboutMeData?.biography ?? "Enter Biography"
        lbl_WordLength.text = "\((viewModel.aboutMeData?.biography ?? "").count)/500"
        
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
            viewModel.updateBiagraphy()
            viewModel.didFinishBiographyUpdate = {[weak self] in
                DispatchQueue.main.async {
                    self?.showSuccessMessages(message: "Biography changes successfully.")
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        else {
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
        }
    }
}
extension ProfileEditBiographyVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .darkBackGround
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Biography"
            textView.textColor = UIColor.lightGray
        }
        else {
            viewModel.biography = textView.text
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count > 500 {
            return false
        }
        lbl_WordLength.text = "\(textView.text.count)/500"
        return true
    }
}
