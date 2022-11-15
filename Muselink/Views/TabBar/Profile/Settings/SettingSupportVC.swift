//
//  SettingSupportVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 12/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SettingSupportVC: UIViewController {
    @IBOutlet weak var btn_back    : SoftUIView!
    @IBOutlet weak var view_Back_1 : SoftUIView!
    @IBOutlet weak var view_Back_2 : SoftUIView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        view_Back_1.type = .pushButton
        view_Back_1.addTarget(self, action: #selector(action_ReportAProblem), for: .touchDown)
        view_Back_1.cornerRadius = 10
        view_Back_1.mainColor = UIColor.paleGray.cgColor
        view_Back_1.darkShadowColor = UIColor(white: 0, alpha: 0.20).cgColor
        view_Back_1.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        view_Back_1.borderWidth = 1
        view_Back_1.borderColor = UIColor.white.cgColor
        
        view_Back_2.type = .pushButton
        view_Back_2.addTarget(self, action: #selector(action_SubmitAIdea), for: .touchDown)
        view_Back_2.cornerRadius = 10
        view_Back_2.mainColor = UIColor.paleGray.cgColor
        view_Back_2.darkShadowColor = UIColor(white: 0, alpha: 0.20).cgColor
        view_Back_2.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        view_Back_1.borderWidth = 1
        view_Back_1.borderColor = UIColor.white.cgColor

        
    }
    @objc private func action_Back() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {[unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc private func action_ReportAProblem() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {[unowned self] in
            let vc = storyboard?.instantiateViewController(withIdentifier: "ReportAProblemVC") as! ReportAProblemVC
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc private func action_SubmitAIdea() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            let vc = storyboard?.instantiateViewController(withIdentifier: "SubmitAIdeaVC") as! SubmitAIdeaVC
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
