//
//  SelectExplorerVC.swift
//  Muselink
//
//  Created by appsDev on 02/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
import IBAnimatable
class SelectExplorerVC: UIViewController {
    @IBOutlet weak var btn_SoundProfile:AnimatableButton!{
        didSet {btn_SoundProfile.setBackgroundImage(#imageLiteral(resourceName: "sound_BackImage_Highlighted"), for: .highlighted)}
    }
    @IBOutlet weak var btn_UserProfile:AnimatableButton!{
        didSet {btn_UserProfile.setBackgroundImage(#imageLiteral(resourceName: "profile_BackImage_Highlighted"), for: .highlighted)}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        btn_SoundProfile.isHidden = false
        btn_SoundProfile.animate(.pop(repeatCount: 1))
        btn_UserProfile.isHidden = false
        btn_UserProfile.animate(.pop(repeatCount: 1))
    }
    @IBAction func action_SoundProfile() {
        AppSettings.isSoundProfile = true
        performSegue(withIdentifier: "HomeTabbar", sender: self)
    }
    @IBAction func action_UserProfile() {
        AppSettings.isSoundProfile = false
        performSegue(withIdentifier: "HomeTabbar", sender: self)
    }
}
