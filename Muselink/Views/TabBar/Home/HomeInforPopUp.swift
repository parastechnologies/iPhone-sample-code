//
//  HomeInforPopUp.swift
//  Muselink
//
//  Created by HarishParas on 16/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class HomeInforPopUp: UIViewController {
    @IBOutlet weak var btn_Report  : SoftUIView!
    @IBOutlet weak var btn_Comment : SoftUIView!
    @IBOutlet weak var btn_ShareTo : SoftUIView!
    var callback_Comment :(()->())?
    var callback_Report  :(()->())?
    var callback_Share   :(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {[unowned self] in
            view.backgroundColor = .init(white: 0, alpha: 0.2)
        }
    }
    private func setUpViews() {
        btn_Report.type = .pushButton
        btn_Report.addTarget(self, action: #selector(action_Report), for: .touchDown)
        btn_Report.cornerRadius = 10
        btn_Report.mainColor = UIColor.paleGray.cgColor
        btn_Report.darkShadowColor  = UIColor(white: 0, alpha: 0.25).cgColor
        btn_Report.borderWidth = 1
        btn_Report.borderColor = UIColor.appRed.cgColor
        btn_Report.setButtonTitle(font: .Avenir_Medium(size: 25), title: "Report")
        
        btn_Comment.type = .pushButton
        btn_Comment.addTarget(self, action: #selector(action_Comment), for: .touchDown)
        btn_Comment.cornerRadius = 10
        btn_Comment.mainColor = UIColor.paleGray.cgColor
        btn_Comment.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        btn_Comment.borderWidth = 1
        btn_Comment.borderColor = UIColor.darkBackGround.cgColor
        btn_Comment.setButtonTitle(font: .Avenir_Medium(size: 25), title: "Comment")
        
        btn_ShareTo.type = .pushButton
        btn_ShareTo.addTarget(self, action: #selector(action_ShareTo), for: .touchDown)
        btn_ShareTo.cornerRadius = ((UIScreen.main.bounds.width-40)*29)/374
        btn_ShareTo.borderColor = UIColor.paleGray.cgColor
        btn_ShareTo.borderWidth = 5
        btn_ShareTo.mainColor   = UIColor.brightPurple.cgColor
        btn_ShareTo.setButtonTitle(font: .Avenir_Medium(size: 25), title: "Share To",titleColor: .white)
    }
    @objc private func action_Report() {
        view.backgroundColor = .clear
        callback_Report?()
        dismiss(animated: true, completion: nil)
    }
    @objc private func action_Comment() {
        view.backgroundColor = .clear
        callback_Comment?()
        dismiss(animated: true, completion: nil)
    }
    @objc private func action_ShareTo() {
        view.backgroundColor = .clear
        callback_Share?()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func action_Close() {
        view.backgroundColor = .clear
        dismiss(animated: true, completion: nil)
    }
}
extension HomeInforPopUp: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
