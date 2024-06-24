//
//  SoundFileMorePopUp.swift
//  Muselink
//
//  Created by iOS TL on 02/08/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SoundFileMorePopUp: UIViewController {
    @IBOutlet weak var btn_Close        : SoftUIView!
    @IBOutlet weak var btn_CopyLink     : SoftUIView!
    @IBOutlet weak var btn_shareTo      : SoftUIView!
    @IBOutlet weak var btn_Notification : SoftUIView!
    @IBOutlet weak var btn_Remove       : SoftUIView!
    @IBOutlet weak var view_Back        : SoftUIView!
    @IBOutlet weak var lbl_Title        : UILabel!
    private        var shapeLayer       = [CAShapeLayer]()
    private        var animator         : AnimatorFactory = AnimatorFactory()
    private        var timer2           : Timer!
    private        var playPauseImage   = UIImageView(image: #imageLiteral(resourceName: "pause"))
    var callback_Remove                 : ((Int)->())?
    var callback_CopyLink               : ((Int)->())?
    var callback_ShareTo                : ((Int)->())?
    var callback_NotificationChange     : ((Int)->())?
    var audioIndex                      = 0
    var selectedAudio                   : AudioModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        shapeLayer = view_Back.addInnerGradientViewWithImageAndStripe(frame: CGRect(x: 0, y: 0, width: view_Back.frame.width*0.422, height: view_Back.frame.width*0.422), cornerRadius: (view_Back.frame.width*0.422)/2, themeColor: [UIColor.semiDarkBackGround,UIColor.black],imageView: playPauseImage,lowePoint: 35,upperPoint: 70)
        timer2 = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true, block: { [weak self] (tmr) in
            guard let self = self else {return}
            self.shapeLayer.randomElement()?.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
            self.shapeLayer.randomElement()?.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
            self.shapeLayer.randomElement()?.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
            self.shapeLayer.randomElement()?.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
            self.shapeLayer.randomElement()?.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
            self.shapeLayer.randomElement()?.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
            self.shapeLayer.randomElement()?.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
            self.shapeLayer.randomElement()?.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
            self.shapeLayer.randomElement()?.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
            self.shapeLayer.randomElement()?.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
            self.shapeLayer.randomElement()?.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
            self.shapeLayer.randomElement()?.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
            self.shapeLayer.randomElement()?.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
            self.shapeLayer.randomElement()?.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
            self.shapeLayer.randomElement()?.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
        })
    }
    private func setUpViews() {
        view_Back.type = .toggleButton
        view_Back.cornerRadius = view_Back.frame.width/2
        view_Back.mainColor = UIColor.darkBackGround.cgColor
        view_Back.darkShadowColor = UIColor.black.cgColor
        view_Back.lightShadowColor = UIColor.darkGray.cgColor
        view_Back.isUserInteractionEnabled = false
        
        btn_Close.type = .pushButton
        btn_Close.addTarget(self, action: #selector(action_Close), for: .touchDown)
        btn_Close.cornerRadius = 10
        btn_Close.mainColor = UIColor.darkBackGround.cgColor
        btn_Close.darkShadowColor = UIColor.black.cgColor
        btn_Close.lightShadowColor = UIColor.darkGray.cgColor
        btn_Close.borderWidth = 2
        btn_Close.borderColor = UIColor.purple.cgColor
        btn_Close.setButtonTitle(font: .Avenir_Medium(size: 20), title: "Close",titleColor: .paleGray)
        
        btn_CopyLink.type = .pushButton
        btn_CopyLink.addTarget(self, action: #selector(action_CopyLink), for: .touchDown)
        btn_CopyLink.cornerRadius = 10
        btn_CopyLink.mainColor = UIColor.darkBackGround.cgColor
        btn_CopyLink.darkShadowColor = UIColor.black.cgColor
        btn_CopyLink.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_CopyLink.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "report_user"), font: .AvenirLTPRo_Regular(size: 18), title: "Copy Link",titleColor: .white)
        
        btn_shareTo.type = .pushButton
        btn_shareTo.addTarget(self, action: #selector(action_ShareTo), for: .touchDown)
        btn_shareTo.cornerRadius = 10
        btn_shareTo.mainColor = UIColor.darkBackGround.cgColor
        btn_shareTo.darkShadowColor = UIColor.black.cgColor
        btn_shareTo.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_shareTo.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "block_user"), font: .AvenirLTPRo_Regular(size: 18), title: "Share to..",titleColor: .white)
        
        btn_Notification.type = .pushButton
        btn_Notification.addTarget(self, action: #selector(action_Notificationt), for: .touchDown)
        btn_Notification.cornerRadius = 10
        btn_Notification.mainColor = UIColor.darkBackGround.cgColor
        btn_Notification.darkShadowColor = UIColor.black.cgColor
        btn_Notification.lightShadowColor = UIColor.semiDarkShadow.cgColor
        if let audio = selectedAudio {
            if audio.notificationStatus ?? "" == "1" {
                btn_Notification.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "remove_user"), font: .AvenirLTPRo_Regular(size: 18), title: "Notification OFF",titleColor: .white)
            }
            else {
                btn_Notification.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "remove_user"), font: .AvenirLTPRo_Regular(size: 18), title: "Notification ON",titleColor: .white)
            }
        }
        
        
        btn_Remove.type = .pushButton
        btn_Remove.addTarget(self, action: #selector(action_Remove), for: .touchDown)
        btn_Remove.cornerRadius = 10
        btn_Remove.mainColor = UIColor.darkBackGround.cgColor
        btn_Remove.darkShadowColor = UIColor.black.cgColor
        btn_Remove.lightShadowColor = UIColor.semiDarkShadow.cgColor
        btn_Remove.setButtonTitlewithImageAndSpacer(img: #imageLiteral(resourceName: "remove_user"), font: .AvenirLTPRo_Regular(size: 18), title: "Remove",titleColor: .white)
        
    }
    @objc private func action_Close() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    @objc private func action_CopyLink() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            callback_CopyLink?(audioIndex)
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    @objc private func action_ShareTo() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            callback_ShareTo?(audioIndex)
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    @objc private func action_Notificationt() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            callback_NotificationChange?(audioIndex)
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    @objc private func action_Remove() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            callback_Remove?(audioIndex)
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}
