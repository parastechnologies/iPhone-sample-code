//
//  SettingTermOfUseVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 19/04/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import WebKit
class SettingTermOfUseVC: BaseClassVC {
    @IBOutlet weak var btn_back : SoftUIView!
    @IBOutlet weak var webView  : WKWebView!{
        didSet {
            webView!.isOpaque = false
            webView!.backgroundColor = UIColor.clear
            webView!.scrollView.backgroundColor = UIColor.clear
        }
    }
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
        webView.loadHTML(file: "t&c")
    }
}
