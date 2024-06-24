//
//  SoundDescInfoPopUp.swift
//  Muselink
//
//  Created by iOS TL on 09/07/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import IBAnimatable
class SoundDescInfoPopUp: UIViewController {
    enum PopUpType {
        case MileStone
        case Interest
        case SoundPro
    }
    @IBOutlet weak var lbl_InfoDetail : AnimatableLabel!
    @IBOutlet weak var btn_Ok         : SoftUIView!
    var selectedPopUpType = PopUpType.MileStone
    override func viewDidLoad() {
        super.viewDidLoad()
        switch selectedPopUpType {
        case .MileStone:
            lbl_InfoDetail.text = "Milestones are set by users for a successful collaboration"
        case .Interest:
            lbl_InfoDetail.text = "Project roles is a list that describes users contribution roles for this sound file"
        case .SoundPro:
            lbl_InfoDetail.text = "With Premium subscription you gain access to full sound files, and not just higlights of 5-15 seconds"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    private func setUpViews() {
        btn_Ok.type = .pushButton
        btn_Ok.addTarget(self, action: #selector(action_Ok), for: .touchDown)
        btn_Ok.cornerRadius = 10
        btn_Ok.mainColor = UIColor.darkBackGround.cgColor
        btn_Ok.darkShadowColor = UIColor.black.cgColor
        btn_Ok.lightShadowColor = UIColor.darkGray.cgColor
        btn_Ok.borderWidth = 2
        btn_Ok.borderColor = UIColor.purple.cgColor
        btn_Ok.setButtonTitle(font: .Avenir_Medium(size: 20), title: "OK",titleColor: .paleGray)

    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {[unowned self] in
            lbl_InfoDetail.isHidden = false
            lbl_InfoDetail.animate(.pop(repeatCount: 1))
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {[unowned self] in
            btn_Ok.isHidden = false
            btn_Ok.transform = .init(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.5) {
                btn_Ok.transform = .identity
            }
        }
    }
    @objc private func action_Ok() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {[unowned self] in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
