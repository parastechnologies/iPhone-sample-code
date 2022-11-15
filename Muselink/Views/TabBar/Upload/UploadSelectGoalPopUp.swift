//
//  UploadSelectGoalPopUp.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 28/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
class UploadSelectGoalPopUp: UIViewController {
    @IBOutlet weak var btn_Next : SoftUIView!
    @IBOutlet var btn_Goals     : [UIButton]!
    var didSelectRole : ((GoalModel)->())?
    var roles = [GoalModel]()
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
        btn_Next.cornerRadius = ((UIScreen.main.bounds.width-40)*29)/374
        btn_Next.borderColor = UIColor.paleGray.cgColor
        btn_Next.borderWidth = 5
        btn_Next.mainColor   = UIColor.brightPurple.cgColor
        btn_Next.setButtonTitle(font: .Avenir_Medium(size: 25), title: "Upload",titleColor: .white)
        
        for btn in btn_Goals {
            if roles.count >= 3+btn.tag {
                btn.setTitle(roles[2 + btn.tag].goalName, for: .normal)
            }
            else {
                btn.isHidden = true
            }
        }
    }
    @IBAction private func action_BtnSelection(_ sender:UIButton) {
        view.backgroundColor = .clear
        didSelectRole?(roles[2 + sender.tag])
        dismiss(animated: true, completion:nil)
    }
    @IBAction func action_Close() {
        view.backgroundColor = .clear
        dismiss(animated: true, completion:nil)
    }
}
