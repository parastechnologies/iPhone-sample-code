//
//  UploadCompleteVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 29/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
import Social
class UploadCompleteVC: UIViewController {
    @IBOutlet weak var view_Back     : SoftUIView!
    @IBOutlet weak var view_LinkBack : SoftUIView!
    @IBOutlet weak var btn_Copy      : SoftUIView!
    @IBOutlet weak var btn_Skip      : SoftUIView!
    private var shapeLayer = [CAShapeLayer]()
    private var audioHelper : AudioPlayerHelper!
    private var animator: AnimatorFactory = AnimatorFactory()
    private var timer2 : Timer!
    private var playPauseImage = UIImageView(image: #imageLiteral(resourceName: "pause"))
    var viewModel : UploadSoundViewModel!
    var isZero        = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    private func setUpViews() {        
        view_Back.type = .toggleButton
        view_Back.addTarget(self, action: #selector(action_PlayPause), for: .touchDown)
        view_Back.cornerRadius = view_Back.frame.width/2
        view_Back.mainColor = UIColor.darkBackGround.cgColor
        view_Back.darkShadowColor = UIColor.black.cgColor
        view_Back.lightShadowColor = UIColor.darkGray.cgColor
        shapeLayer = view_Back.addInnerGradientViewWithImageAndStripe(frame: CGRect(x: 0, y: 0, width: view_Back.frame.width*0.422, height: view_Back.frame.width*0.422), cornerRadius: (view_Back.frame.width*0.422)/2, themeColor: [UIColor.semiDarkBackGround,UIColor.black],imageView: playPauseImage)
        
//        timer2 = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true, block: { [weak self] (tmr) in
//            guard let self = self else {return}
//            if self.audioHelper == nil || !self.audioHelper.isPlaying {
//                return
//            }
//            self.animator.newValue = 1 + Double(self.audioHelper.loudnessValue/10)
//            if self.isZero {
//                self.isZero = false
//                self.shapeLayer = self.shapeLayer.map { shap in
//                    shap.strokeEnd = CGFloat(0.0)
//                    return shap
//                }
//            }
//            else {
//                self.isZero = true
//                let conut = self.audioHelper.frequencyUpdate.count
//                let multIndex = Float(Float(conut)/Float(120))
//                for lay in self.shapeLayer.enumerated() {
//                    let index = Float(lay.offset) * multIndex > Float(conut) ? (Float(lay.offset)*multIndex)-Float(conut) : Float(lay.offset)*multIndex
//                    if Int(index) < self.audioHelper.frequencyUpdate.count {
//                        lay.element.strokeEnd = CGFloat(self.audioHelper.frequencyUpdate[Int(index)])
//                    }
//                    else {
//                        lay.element.strokeEnd = CGFloat(self.audioHelper.frequencyUpdate.last ?? 0)
//                    }
//                }
//            }
//        })
        view_LinkBack.type = .normal
        view_LinkBack.cornerRadius = view_LinkBack.frame.height/2
        view_LinkBack.isSelected = true
        view_LinkBack.mainColor = UIColor.darkBackGround.cgColor
        view_LinkBack.darkShadowColor = UIColor.black.cgColor
        view_LinkBack.lightShadowColor = UIColor.darkGray.cgColor
        view_LinkBack.setButtonTitle(font: .AvenirLTPRo_Regular(size: 16), title: "https://www.museboxapp.com/uploads", titleColor: .paleGrayText)
        
        btn_Copy.type = .normal
        btn_Copy.cornerRadius = btn_Copy.frame.height/2
        btn_Copy.mainColor = UIColor.darkBackGround.cgColor
        btn_Copy.darkShadowColor = UIColor.black.cgColor
        btn_Copy.lightShadowColor = UIColor.darkGray.cgColor
        btn_Copy.setButtonTitle(font: .AvenirLTPRo_Regular(size: 13), title: "Copy", titleColor: .white)
        
        btn_Skip.type = .pushButton
        btn_Skip.addTarget(self, action: #selector(action_Skip), for: .touchDown)
        btn_Skip.cornerRadius = btn_Skip.frame.height/2
        btn_Skip.mainColor = UIColor.darkBackGround.cgColor
        btn_Skip.darkShadowColor = UIColor.black.cgColor
        btn_Skip.lightShadowColor = UIColor.darkGray.cgColor
        btn_Skip.borderWidth = 2
        btn_Skip.borderColor = UIColor.purple.cgColor
        btn_Skip.setButtonTitle(font: .Avenir_Medium(size: 20), title: "Skip",titleColor: .paleGray)
    }
    @objc private func action_Skip() {
        navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UpdatePlayerStatus()
    }
    override func viewDidDisappear(_ animated: Bool) {
        if audioHelper != nil {
            audioHelper.stopAudioPlayer()
            audioHelper = nil
        }
    }
    private func UpdatePlayerStatus() {
        guard let audURL = viewModel.uploadAudio?.trimAudio else {
            return
        }
        audioHelper = AudioPlayerHelper(song: NetworkManager.trimAudioBaseURL+audURL)
        audioHelper.updateSpectrum = {[weak self] in
            guard let self = self, let audioHelp =  self.audioHelper else {return}
            print(audioHelp.frequencyUpdate)
            let multiplier = Int(audioHelp.frequencyUpdate.count/120)
            for lay in self.shapeLayer.enumerated() {
                if lay.offset > 60 {
                    let index = lay.offset*multiplier+4
                    if Int(index) < audioHelp.frequencyUpdate.count {
                        lay.element.setAnimatedStroke(value: CGFloat(audioHelp.frequencyUpdate[Int(index)]) * 4)
                    }
                    else {
                        lay.element.setAnimatedStroke(value: CGFloat(audioHelp.frequencyUpdate.last ?? 0) * 4)
                    }
                }
                else {
                    let index = (lay.offset)*5+4
                    if Int(index) < audioHelp.bassFrequencyUpdate.count {
                        lay.element.setAnimatedStroke(value: CGFloat(audioHelp.bassFrequencyUpdate[Int(index)]))
                    }
                    else {
                        lay.element.setAnimatedStroke(value: CGFloat(audioHelp.bassFrequencyUpdate.last ?? 0))
                    }
                }
                
            }
        }
        playPauseImage.image = #imageLiteral(resourceName: "pause")
        audioHelper.isPlaying = true
        animator.rotateRepeat(view: view_Back)
        animator.propertyAnimator?.startAnimation()
        audioHelper.startPlayer()
        audioHelper.playerFinsh = { [weak self] in
            DispatchQueue.main.async {
                self?.playPauseImage.image = #imageLiteral(resourceName: "play_icon")
                self?.audioHelper.isPlaying = false
                self?.animator.propertyAnimator?.stopAnimation(true)
                self?.audioHelper.stopAudioPlayer()
                self?.view_Back.transform = .identity
                self?.timer2.invalidate()
            }
        }
    }
    @IBAction func action_PlayPause() {
        
        if audioHelper == nil {
            UpdatePlayerStatus()
        }
        if audioHelper.isPlaying {
            animator.propertyAnimator?.stopAnimation(true)
            playPauseImage.image = #imageLiteral(resourceName: "play_icon")
            audioHelper.isPlaying = false
            audioHelper.stopAudioPlayer()
        }
        else {
            playPauseImage.image = #imageLiteral(resourceName: "pause")
            audioHelper.isPlaying = true
            animator.rotateRepeat(view: view_Back)
            animator.propertyAnimator?.startAnimation()
            audioHelper.startPlayer()
        }
    }
    @IBAction func action_Instagram() {
        guard let urlStr = viewModel.uploadAudio?.recordingVideo, let url = URL(string: NetworkManager.recordVideoBaseURL + urlStr) else {
            return
        }
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            vc.setInitialText("Look at this great Audio!")
            vc.add(UIImage(named: "splashLogo"))
            vc.add(url)
            present(vc, animated: true)
        }
    }
    @IBAction func action_TikTok() {
        guard let urlStr = viewModel.uploadAudio?.recordingVideo, let url = URL(string: NetworkManager.recordVideoBaseURL + urlStr) else {
            return
        }
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            vc.setInitialText("Look at this great Audio!")
            vc.add(UIImage(named: "splashLogo"))
            vc.add(url)
            present(vc, animated: true)
        }
    }
    @IBAction func action_Triller() {
        guard let urlStr = viewModel.uploadAudio?.recordingVideo, let url = URL(string: NetworkManager.recordVideoBaseURL + urlStr) else {
            return
        }
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            vc.setInitialText("Look at this great Audio!")
            vc.add(UIImage(named: "splashLogo"))
            vc.add(url)
            present(vc, animated: true)
        }
    }
    @IBAction func action_Other() {
        var items = [URL]()
        if let urlStr = viewModel.uploadAudio?.recordingVideo, let url = URL(string: NetworkManager.recordVideoBaseURL + urlStr) {
            items = [url]
        }
        else {
            items = [URL(string: "https://www.muselink.app")!]
        }
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        tabBarController?.present(ac, animated: true)
    }
}
