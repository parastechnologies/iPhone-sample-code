//
//  ReportPopUpVC.swift
//  Muselink
//
//  Created by iOS TL on 03/08/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class ReportPopUpVC: BaseClassVC {
    @IBOutlet weak var View_Description    : SoftUIView!
    @IBOutlet weak var txtView_Description : SoftUIView!
    @IBOutlet weak var btn_Submit          : SoftUIView!
    private var desctext : UITextView!{
        didSet {
            desctext.delegate = self
            desctext.text = "Note ✍️"
            desctext.textColor = UIColor.lightGray
        }
    }
    var selectedAudio : AudioModel?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    private func setUpViews() {
        View_Description.type = .normal
        View_Description.cornerRadius = 10
        View_Description.mainColor = UIColor.darkBackGround.cgColor
        View_Description.darkShadowColor = UIColor.black.cgColor
        View_Description.lightShadowColor = UIColor.darkGray.cgColor
        View_Description.isUserInteractionEnabled = true
        View_Description.borderWidth = 1
        View_Description.borderColor = UIColor.black.cgColor
        
        txtView_Description.type             = .normal
        txtView_Description.isSelected       = true
        txtView_Description.cornerRadius     = 10
        txtView_Description.mainColor        = UIColor.darkBackGround.cgColor
        txtView_Description.darkShadowColor = UIColor.black.cgColor
        txtView_Description.lightShadowColor = UIColor.darkGray.cgColor
        txtView_Description.borderWidth      = 2
        txtView_Description.borderColor      = UIColor.black.cgColor
        txtView_Description.isUserInteractionEnabled = true
        desctext = txtView_Description.setTextView(font: .AvenirLTPRo_Regular(size: 16), textColor: .white)
        desctext.isEditable = true
        desctext.text = "Note ✍️"
        
        btn_Submit.type = .pushButton
        btn_Submit.addTarget(self, action: #selector(action_Submit), for: .touchDown)
        btn_Submit.cornerRadius = ((UIScreen.main.bounds.width-40)*29)/374
        btn_Submit.borderColor = UIColor.brightPurple.cgColor
        btn_Submit.darkShadowColor = UIColor.black.cgColor
        btn_Submit.lightShadowColor = UIColor.darkGray.cgColor
        btn_Submit.borderWidth = 2
        btn_Submit.mainColor   = UIColor.darkBackGround.cgColor
        btn_Submit.setButtonTitle(font: .Avenir_Medium(size: 25), title: "Submit",titleColor: .white)
    }
    @objc private func action_Submit() {
        if desctext.text! == "Note ✍️" || desctext.text! == "" {
            showErrorMessages(message: "Write something in the message")
            return
        }
        guard let audio = selectedAudio else {
            showErrorMessages(message: "Something went wrong. Please try again.")
            return
        }
        showProgressHUD()
        let model = NetworkManager.sharedInstance
        model.sendReport(audioID: audio.audioID ?? "0", reportText: desctext.text!) {[weak self] res in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.hideProgressHUD()
            }
            switch res {
            case .success(_):
                DispatchQueue.main.async {
                    self.showSuccessMessages(message: "Message sent successfully.")
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    print(desc)
                    DispatchQueue.main.async {
                        self.showErrorMessages(message: desc)
                    }
                }
                print(err.localizedDescription)
            }
        }
    }
}
extension ReportPopUpVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Note ✍️"
            textView.textColor = UIColor.lightGray
        }
    }
}
