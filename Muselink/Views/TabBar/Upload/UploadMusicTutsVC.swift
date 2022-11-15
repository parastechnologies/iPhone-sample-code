//
//  UploadMusicTutsVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 28/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
import IBAnimatable
class UploadMusicTutsVC: UIViewController {
    @IBOutlet weak var btn_Ok      : SoftUIView!
    @IBOutlet weak var lbl_Title_1 : AnimatableLabel!
    @IBOutlet weak var lbl_Desc_1  : AnimatableLabel!
    @IBOutlet weak var lbl_Title_2 : AnimatableLabel!
    @IBOutlet weak var lbl_Desc_2  : AnimatableLabel!
    @IBOutlet weak var img_first   : AnimatableImageView!
    @IBOutlet weak var img_Second  : AnimatableImageView!
    var isStepTwo = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if isStepTwo {
            AppSettings.uploadTutsCount += 1
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    private func setUpViews() {
        btn_Ok.type = .pushButton
        btn_Ok.addTarget(self, action: #selector(action_Ok), for: .touchDown)
        btn_Ok.cornerRadius = 10
        btn_Ok.mainColor = UIColor.darkBackGround.cgColor
        btn_Ok.darkShadowColor = UIColor.black.cgColor
        btn_Ok.lightShadowColor = UIColor.darkGray.cgColor
        btn_Ok.borderWidth = 2
        btn_Ok.borderColor = UIColor.purple.cgColor
        btn_Ok.setButtonTitle(font: .Avenir_Medium(size: 20), title: "OK",titleColor: .paleGray)
        if isStepTwo {
            img_first.image  = #imageLiteral(resourceName: "step_shape3")
            lbl_Title_1.text = "Project Description"
            lbl_Desc_1.text  = "Describe the sound file\nyou can use #hastag and @location"
            img_Second.image = #imageLiteral(resourceName: "step_shape4")
            lbl_Title_2.text = "Project Goals"
            lbl_Desc_2.text  = "What goals do you have\nfor this sound file?"
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {[unowned self] in
            img_first.isHidden = false
            img_first.animate(.pop(repeatCount: 1))
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {[unowned self] in
            lbl_Title_1.isHidden = false
            lbl_Desc_1.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {[unowned self] in
            img_Second.isHidden = false
            img_Second.animate(.pop(repeatCount: 1))
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {[unowned self] in
            lbl_Title_2.isHidden = false
            lbl_Desc_2.isHidden = false
            btn_Ok.isHidden = false
            btn_Ok.transform = .init(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.5) {
                btn_Ok.transform = .identity
            }
        }
    }
    @objc private func action_Ok() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {[unowned self] in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
