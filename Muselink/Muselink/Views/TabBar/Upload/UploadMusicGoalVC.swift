//
//  UploadMusicGoalVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 28/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit

class UploadMusicGoalVC: BaseClassVC  {
    @IBOutlet weak var btn_back            : SoftUIView!
    @IBOutlet weak var btn_Upload          : SoftUIView!
    @IBOutlet weak var View_Description    : SoftUIView!
    @IBOutlet weak var txtView_Description : SoftUIView!
    @IBOutlet weak var view_Back           : UIView!
    @IBOutlet weak var lbl_Description     : UILabel!
    @IBOutlet weak var lbl_WordLength      : UILabel!
    @IBOutlet weak var lbl_BackgroudColor  : UILabel!
    @IBOutlet var btn_Roles                : [UIButton]! {
        didSet {
            for btn in btn_Roles { btn.isHidden = true }
        }
    }
    @IBOutlet var btn_Color                : [SoftUIView]!
    private var desctext : UITextView! {
        didSet {
            desctext.delegate = self
            desctext.text = "Enter Description"
            desctext.textColor = UIColor.lightGray
        }
    }
    var viewModel : UploadSoundViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchGoals()
        viewModel.didFinishFetch = {[unowned self] in
            DispatchQueue.main.async {
                setGoalButton()
            }
        }
        if AppSettings.uploadTutsCount <= 3 {
            DispatchQueue.main.asyncAfter(deadline: .now()) {[unowned self] in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadMusicTutsVC") as! UploadMusicTutsVC
                vc.isStepTwo = true
                vc.modalPresentationStyle = .custom
                vc.modalTransitionStyle   = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        desctext = txtView_Description.setTextView(font: .AvenirLTPRo_Regular(size: 16), textColor: .white)
        desctext.isEditable = true
        desctext.text = "Enter Description"
    }
    private func setUpViews() {
        btn_back.type = .pushButton
        btn_back.addTarget(self, action: #selector(action_Back), for: .touchDown)
        btn_back.cornerRadius = 10
        btn_back.mainColor = UIColor.darkBackGround.cgColor
        btn_back.darkShadowColor = UIColor.black.cgColor
        btn_back.lightShadowColor = UIColor.darkGray.cgColor
        btn_back.setButtonImage(image: #imageLiteral(resourceName: "icon_back"))
        
        btn_Upload.type = .pushButton
        btn_Upload.addTarget(self, action: #selector(action_Upload), for: .touchDown)
        btn_Upload.cornerRadius = ((UIScreen.main.bounds.width-40)*29)/374
        btn_Upload.borderColor = UIColor.paleGray.cgColor
        btn_Upload.borderWidth = 5
        btn_Upload.mainColor   = UIColor.brightPurple.cgColor
        btn_Upload.setButtonTitle(font: .Avenir_Medium(size: 25), title: "Upload",titleColor: .white)
        
        View_Description.type = .normal
        View_Description.cornerRadius = 10
        View_Description.mainColor = UIColor.darkBackGround.cgColor
        View_Description.darkShadowColor = UIColor(white: 0, alpha: 0.8).cgColor
        View_Description.lightShadowColor = UIColor.darkGray.cgColor
        View_Description.isUserInteractionEnabled = true
        
        txtView_Description.type             = .normal
        txtView_Description.isSelected       = true
        txtView_Description.cornerRadius     = 10
        txtView_Description.mainColor        = UIColor.darkBackGround.cgColor
        txtView_Description.darkShadowColor  = UIColor(white: 0, alpha: 0.8).cgColor
        txtView_Description.lightShadowColor = UIColor.black.cgColor
        txtView_Description.borderWidth      = 1
        txtView_Description.borderColor      = UIColor.lightGray.cgColor
        txtView_Description.isUserInteractionEnabled = true
        
        for btn in btn_Color {
            btn.type = .toggleButton
            btn.addTarget(self, action: #selector(action_ColorSelection(_:)), for: .touchDown)
            btn.cornerRadius = btn.bounds.width/2
            btn.borderColor  = UIColor.darkBackGround.cgColor
            btn.borderWidth  = 5
            btn.darkShadowColor = UIColor.black.cgColor
            btn.lightShadowColor = UIColor.darkGray.cgColor
            switch btn.tag {
            case 1:
                btn.mainColor = UIColor.skyBlue.cgColor
            case 2:
                btn.mainColor = UIColor.redPink.cgColor
            case 3:
                btn.mainColor = UIColor.darkBackGround.cgColor
                btn.isSelected = true
            case 4:
                btn.mainColor = UIColor.white.cgColor
            default:
                print("Not in Range")
            }
        }
    }
    private func setGoalButton() {
        for btn in btn_Roles {
            if btn.tag == 4 && viewModel.goalsArray.count >= btn.tag {
                btn.isHidden = false
                break
            }
            else if viewModel.goalsArray.count >= btn.tag {
                btn.setTitle(viewModel.goalsArray[btn.tag-1].goalName, for: .normal)
                btn.setBackgroundImage(#imageLiteral(resourceName: "interests_shape_select"), for: .highlighted)
                btn.isHidden = false
            }
            else {
                btn.isHidden = true
            }
        }
    }
    @IBAction private func action_BtnSelection(_ sender:UIButton) {
        if sender.tag == 4 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "UploadSelectGoalPopUp") as! UploadSelectGoalPopUp
            vc.modalPresentationStyle = .custom
            vc.modalTransitionStyle   = .crossDissolve
            vc.roles = viewModel.goalsArray
            vc.didSelectRole = { [weak self] role in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    if let index = self.viewModel.selectedGoals.firstIndex(of: self.viewModel.goalsArray[sender.tag-1]) {
                        self.viewModel.selectedGoals.remove(at: index)
                        self.btn_Roles[sender.tag-1].setBackgroundImage(#imageLiteral(resourceName: "interests_shape"), for: .normal)
                    }
                    else {
                        self.viewModel.selectedGoals.append(self.viewModel.goalsArray[sender.tag-1])
                        self.btn_Roles[sender.tag-1].setBackgroundImage(#imageLiteral(resourceName: "interests_shape_select"), for: .normal)
                    }
                }
            }
            present(vc, animated: true, completion: nil)
        }
        else {
            if let index = viewModel.selectedGoals.firstIndex(of: viewModel.goalsArray[sender.tag-1]) {
                viewModel.selectedGoals.remove(at: index)
                btn_Roles[sender.tag-1].setBackgroundImage(#imageLiteral(resourceName: "interests_shape"), for: .normal)
            }
            else {
                viewModel.selectedGoals.append(viewModel.goalsArray[sender.tag-1])
                btn_Roles[sender.tag-1].setBackgroundImage(#imageLiteral(resourceName: "interests_shape_select"), for: .normal)
            }
        }
    }
    @objc private func action_ColorSelection(_ sender:SoftUIView) {
        switch sender.tag {
        case 1:
            view_Back.backgroundColor = .skyBlue
            
            View_Description.mainColor = UIColor.skyBlue.cgColor
            View_Description.darkShadowColor = UIColor.gray.cgColor
            View_Description.lightShadowColor = UIColor.paleGray.cgColor
            
            txtView_Description.mainColor        = UIColor.skyBlue.cgColor
            txtView_Description.darkShadowColor  = UIColor.lightGray.cgColor
            txtView_Description.lightShadowColor = UIColor.lightGray.cgColor
            
            for btn in btn_Color {
                btn.borderColor  = UIColor.skyBlue.cgColor
                btn.darkShadowColor = UIColor.gray.cgColor
                btn.lightShadowColor = UIColor.paleGray.cgColor
                if btn.tag == sender.tag {
                    btn.isSelected = true
                }
                else {
                    btn.isSelected = false
                }
            }
            lbl_Description.textColor    = .black
            lbl_WordLength.textColor     = .darkGray
            lbl_BackgroudColor.textColor = .black
            //desctext.textColor           = .darkBackGround
            
            btn_back.darkShadowColor = UIColor.gray.cgColor
            btn_back.lightShadowColor = UIColor.lightGray.cgColor
            
        case 2:
            view_Back.backgroundColor = .redPink
            
            View_Description.mainColor = UIColor.redPink.cgColor
            View_Description.darkShadowColor = UIColor.gray.cgColor
            View_Description.lightShadowColor = UIColor.paleGray.cgColor
            
            txtView_Description.mainColor        = UIColor.redPink.cgColor
            txtView_Description.darkShadowColor  = UIColor.lightGray.cgColor
            txtView_Description.lightShadowColor = UIColor.lightGray.cgColor
            
            for btn in btn_Color {
                btn.borderColor  = UIColor.redPink.cgColor
                btn.darkShadowColor = UIColor.gray.cgColor
                btn.lightShadowColor = UIColor.paleGray.cgColor
                if btn.tag == sender.tag {
                    btn.isSelected = true
                }
                else {
                    btn.isSelected = false
                }
            }
            lbl_Description.textColor    = .black
            lbl_WordLength.textColor     = .darkGray
            lbl_BackgroudColor.textColor = .black
           // desctext.textColor           = .darkBackGround
            
            btn_back.darkShadowColor = UIColor.gray.cgColor
            btn_back.lightShadowColor = UIColor.lightGray.cgColor
        case 3:
            view_Back.backgroundColor = .darkBackGround
            
            View_Description.mainColor = UIColor.darkBackGround.cgColor
            View_Description.darkShadowColor = UIColor(white: 0, alpha: 0.8).cgColor
            View_Description.lightShadowColor = UIColor.darkGray.cgColor
            
            txtView_Description.mainColor        = UIColor.darkBackGround.cgColor
            txtView_Description.darkShadowColor  = UIColor(white: 0, alpha: 0.8).cgColor
            txtView_Description.lightShadowColor = UIColor.black.cgColor
            txtView_Description.borderColor      = UIColor.white.cgColor
            
            for btn in btn_Color {
                btn.borderColor  = UIColor.darkBackGround.cgColor
                btn.darkShadowColor = UIColor.black.cgColor
                btn.lightShadowColor = UIColor.darkGray.cgColor
                if btn.tag == sender.tag {
                    btn.isSelected = true
                }
                else {
                    btn.isSelected = false
                }
            }
            lbl_Description.textColor    = .white
            lbl_WordLength.textColor     = .lightGray
            lbl_BackgroudColor.textColor = .white
            //desctext.textColor           = .white
            
            btn_back.darkShadowColor = UIColor.black.cgColor
            btn_back.lightShadowColor = UIColor.darkGray.cgColor
        case 4:
            view_Back.backgroundColor = .white
            
            View_Description.mainColor = UIColor.white.cgColor
            View_Description.darkShadowColor = UIColor.gray.cgColor
            View_Description.lightShadowColor = UIColor.paleGray.cgColor
            
            txtView_Description.mainColor        = UIColor.white.cgColor
            txtView_Description.darkShadowColor  = UIColor.paleGray.cgColor
            txtView_Description.lightShadowColor = UIColor.paleGray.cgColor
            
            for btn in btn_Color {
                btn.borderColor  = UIColor.white.cgColor
                btn.darkShadowColor = UIColor.gray.cgColor
                btn.lightShadowColor = UIColor.paleGray.cgColor
                if btn.tag == sender.tag {
                    btn.isSelected = true
                }
                else {
                    btn.isSelected = false
                }
            }
            lbl_Description.textColor    = .black
            lbl_WordLength.textColor     = .darkGray
            lbl_BackgroudColor.textColor = .black
            //desctext.textColor           = .darkBackGround
            
            btn_back.darkShadowColor = UIColor.gray.cgColor
            btn_back.lightShadowColor = UIColor.lightGray.cgColor
        default:
            print("Not in range")
        }
        
    }
    @objc func action_Upload() {
        if viewModel.descriptiontxt.isEmpty {
            showErrorMessages(message: "Please write some description")
            return
        }
        if viewModel.selectedGoals.isEmpty {
            showErrorMessages(message: "Please select any goal")
            return
        }
        performSegue(withIdentifier: "uploadToServer", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UploadToServerVC {
            vc.viewModel = self.viewModel
        }
    }
}
extension UploadMusicGoalVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Description"
            textView.textColor = UIColor.lightGray
        }
        else {
            viewModel.descriptiontxt = textView.text
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count > 140 {
            return false
        }
        lbl_WordLength.text = "\(textView.text.count)/140"
        viewModel.locationArr = textView.resolveLocationTags()
        return true
    }
}
