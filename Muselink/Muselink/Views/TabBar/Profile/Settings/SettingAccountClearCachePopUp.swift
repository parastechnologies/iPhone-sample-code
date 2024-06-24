//
//  SettingAccountClearCachePopUp.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 05/05/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SettingAccountClearCachePopUp: UIViewController {
    @IBOutlet weak var view_Back    : SoftUIView!
    @IBOutlet weak var btn_Continue : SoftUIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async{[unowned self] in
            setUpViews()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.35) {[unowned self] in
            view.backgroundColor = .init(white: 0, alpha: 0.6)
        }
    }
    private func setUpViews() {
        view_Back.type = .normal
        view_Back.cornerRadius = 16
        view_Back.mainColor = UIColor.darkBackGround.cgColor
        view_Back.darkShadowColor = UIColor.black.cgColor
        view_Back.lightShadowColor = UIColor.darkGray.cgColor
        view_Back.borderWidth = 1
        view_Back.borderColor = UIColor.black.cgColor
        
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
        view.backgroundColor = .clear
        dismiss(animated: true, completion: nil)
    }
    @IBAction func action_Cancel() {
        view.backgroundColor = .clear
        dismiss(animated: true, completion: nil)
    }
}
