//
//  TutorialsScreenOneVC.swift
//  Muselink
//
//  Created by appsDev on 26/11/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
import IBAnimatable
class TutorialsScreenOneVC: UIViewController {
    @IBOutlet weak var img_telescope  : AnimatableImageView!
    @IBOutlet weak var img_msgIcon    : AnimatableImageView!
    @IBOutlet weak var img_bulbIcon   : AnimatableImageView!
    @IBOutlet weak var img_musicIcon  : AnimatableImageView!
    @IBOutlet weak var img_Star1      : AnimatableImageView!
    @IBOutlet weak var img_Star2      : AnimatableImageView!
    @IBOutlet weak var img_halfCircle : AnimatableImageView!
    weak var parentVC : TutorialsScreenContainerVC?
    override func viewDidLoad() {
        super.viewDidLoad()
        parentVC?.tuts1AnimationEnd = {[weak self] in
            guard let self = self else {return}
            UIView.animate(withDuration: 0.5) {
                self.img_halfCircle.transform = .init(translationX: 34, y: 20)
            }
        }
    }
}
