//
//  TutorialsScreenTwoVC.swift
//  Muselink
//
//  Created by appsDev on 26/11/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
import IBAnimatable
class TutorialsScreenTwoVC: UIViewController {
    @IBOutlet weak var img_Circle   : AnimatableImageView!
    @IBOutlet weak var img_arrow1   : AnimatableImageView!
    @IBOutlet weak var img_arrow2   : AnimatableImageView!
    @IBOutlet weak var img_arrow3   : AnimatableImageView!
    @IBOutlet weak var img_arrow4   : AnimatableImageView!
    @IBOutlet weak var lbl_Heading  : AnimatableLabel!
    weak var parentVC : TutorialsScreenContainerVC?
    override func viewDidLoad() {
        super.viewDidLoad()
        img_Circle.transform = .init(translationX: -view.frame.width/2, y: 50)
    }
    override func viewDidAppear(_ animated: Bool) {
        lbl_Heading.animate(.pop(repeatCount: 1),duration: 1.5)
        img_Circle.isHidden = false
        UIView.animate(withDuration: 1) {[unowned self] in
            self.img_Circle.transform = .identity
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {[weak self] in
            guard let self = self else {return}
            self.img_arrow1.isHidden = false
            self.img_arrow1.animate(.pop(repeatCount: 1),duration: 1.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {[weak self] in
            guard let self = self else {return}
            self.img_arrow2.isHidden = false
            self.img_arrow2.animate(.pop(repeatCount: 1),duration: 1.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {[weak self] in
            guard let self = self else {return}
            self.img_arrow3.isHidden = false
            self.img_arrow3.animate(.pop(repeatCount: 1),duration: 1.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {[weak self] in
            guard let self = self else {return}
            self.img_arrow4.isHidden = false
            self.img_arrow4.animate(.pop(repeatCount: 1),duration: 1.5)
        }
    }
}
