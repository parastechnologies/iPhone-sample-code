//
//  TutorialsScreenThreeVC.swift
//  Muselink
//
//  Created by appsDev on 26/11/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
import IBAnimatable
class TutorialsScreenThreeVC: UIViewController {
    @IBOutlet weak var img_Graphic    : AnimatableImageView!
    @IBOutlet weak var img_1          : AnimatableImageView!
    @IBOutlet weak var img_2          : AnimatableImageView!
    @IBOutlet weak var img_3          : AnimatableImageView!
    @IBOutlet weak var img_4          : AnimatableImageView!
    @IBOutlet weak var img_5          : AnimatableImageView!
    @IBOutlet weak var img_6          : AnimatableImageView!
    @IBOutlet weak var img_7          : AnimatableImageView!
    weak var parentVC : TutorialsScreenContainerVC?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {[weak self] in
            guard let self = self else {return}
            self.img_1.isHidden = false
            self.img_1.animate(.pop(repeatCount: 1),duration: 1.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {[weak self] in
            guard let self = self else {return}
            self.img_2.isHidden = false
            self.img_2.animate(.pop(repeatCount: 1),duration: 1.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {[weak self] in
            guard let self = self else {return}
            self.img_3.isHidden = false
            self.img_3.animate(.pop(repeatCount: 1),duration: 1.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {[weak self] in
            guard let self = self else {return}
            self.img_4.isHidden = false
            self.img_4.animate(.pop(repeatCount: 1),duration: 1.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {[weak self] in
            guard let self = self else {return}
            self.img_5.isHidden = false
            self.img_5.animate(.pop(repeatCount: 1),duration: 1.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {[weak self] in
            guard let self = self else {return}
            self.img_6.isHidden = false
            self.img_6.animate(.pop(repeatCount: 1),duration: 1.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+3.5) {[weak self] in
            guard let self = self else {return}
            self.img_7.isHidden = false
            self.img_7.animate(.pop(repeatCount: 1),duration: 1.5)
        }
    }
}
