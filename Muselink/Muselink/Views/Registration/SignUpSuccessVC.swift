//
//  SignUpSuccessVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 08/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SignUpSuccessVC: BaseClassVC {
    @IBOutlet weak var btn_Continue : SoftUIView!
    @IBOutlet weak var lbl_Description : UILabel!
    var viewModel : RegistrationViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    private func setUpViews() {
        btn_Continue.type = .pushButton
        btn_Continue.addTarget(self, action: #selector(action_Continue), for: .touchDown)
        btn_Continue.cornerRadius = btn_Continue.frame.height/2
        btn_Continue.mainColor = UIColor.darkBackGround.cgColor
        btn_Continue.darkShadowColor = UIColor.black.cgColor
        btn_Continue.lightShadowColor = UIColor.darkGray.cgColor
        btn_Continue.borderWidth = 2
        btn_Continue.borderColor = UIColor.purple.cgColor
        btn_Continue.setButtonTitle(font: .Avenir_Medium(size: 20), title: "Continue",titleColor: .paleGray)
    }
    @objc private func action_Continue() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}
