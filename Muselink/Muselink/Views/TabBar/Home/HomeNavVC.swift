//
//  HomeNavVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 11/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class HomeNavVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !AppSettings.isSoundProfile {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "HomeProfileTabVC") else {
                return
            }
            setViewControllers([vc], animated: false)
        }
    }
}
