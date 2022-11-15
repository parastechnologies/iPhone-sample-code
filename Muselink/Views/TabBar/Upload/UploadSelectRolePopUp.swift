//
//  UploadSelectRolePopUp.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 28/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit

class UploadSelectRolePopUp: UIViewController {
    @IBOutlet weak var btn_Next   : SoftUIView!
    @IBOutlet var btn_Roles       : [SoftUIView]!
    var roles = [RoleModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    private func setUpViews() {
        view.backgroundColor = .init(white: 0, alpha: 0.85)
        
        btn_Next.type = .pushButton
        btn_Next.addTarget(self, action: #selector(action_Next), for: .touchDown)
        btn_Next.cornerRadius = ((UIScreen.main.bounds.width-40)*29)/374
        btn_Next.borderColor = UIColor.paleGray.cgColor
        btn_Next.borderWidth = 5
        btn_Next.mainColor   = UIColor.brightPurple.cgColor
        btn_Next.setButtonTitle(font: .Avenir_Medium(size: 25), title: "Next",titleColor: .white)
        
        for btn in btn_Roles {
            btn.type = .pushButton
            btn.addTarget(self, action: #selector(action_BtnSelection(_:)), for: .touchDown)
            btn.cornerRadius = 10
            btn.mainColor = UIColor.paleGray.cgColor
            btn.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
            switch btn.tag {
            case 1:
                btn.setButtonTitle(font: .AvenirLTPRo_Bold(size: 12), title: "Instrumentalist")
            case 2:
                btn.setButtonTitle(font: .AvenirLTPRo_Bold(size: 12), title: "Producer")
            case 3:
                btn.setButtonTitle(font: .AvenirLTPRo_Bold(size: 12), title: "Vocalist")
            case 4:
                btn.setButtonTitle(font: .AvenirLTPRo_Bold(size: 12), title: "Songwriter")
            case 5:
                btn.setButtonTitle(font: .AvenirLTPRo_Bold(size: 12), title: "Label/ A&R")
            case 6:
                btn.setButtonTitle(font: .AvenirLTPRo_Bold(size: 12), title: "Top liner")
            case 7:
                btn.setButtonTitle(font: .AvenirLTPRo_Bold(size: 12), title: "Manager")
            case 8:
                btn.setButtonTitle(font: .AvenirLTPRo_Bold(size: 12), title: "Sound engineer")
            case 9:
                btn.setButtonTitle(font: .AvenirLTPRo_Bold(size: 12), title: "Master engineer")
            default:
                print("Not in Range")
            }
        }
    }
    @objc private func action_BtnSelection(_ sender:SoftUIView) {
        
    }
    @objc private func action_Next() {
        
    }
    @IBAction func action_Close() {
        view.backgroundColor = .clear
        dismiss(animated: true, completion:nil)
    }
}
