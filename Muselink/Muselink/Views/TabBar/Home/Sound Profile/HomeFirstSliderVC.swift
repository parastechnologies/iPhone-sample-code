//
//  HomeFirstSliderVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 08/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
class HomeFirstSliderVC: UIViewController {
    var playPauseImage = UIImageView(image: #imageLiteral(resourceName: "play_icon"))
    @IBOutlet weak var view_Back           : SoftUIView!
    @IBOutlet weak var progressBar         : MTCircularSlider!
    @IBOutlet weak var lbl_CurrentSeekTime : UILabel!
    @IBOutlet weak var lbl_TotalSeekTime   : UILabel!
    private var audioHelper : ProAudioPlayerHelper!
    var progressCounter : Float = 0
    var progressValue   = Float()
    var animator        : AnimatorFactory = AnimatorFactory()
    weak var parentVC   : HomeTabVC?
    var viewmodel       : SoundProfileViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view_Back.cornerRadius = view_Back.frame.width/2
    }
    private func setUpViews() {
        view_Back.type = .pushButton
        view_Back.cornerRadius = view_Back.frame.width/2
        view_Back.mainColor = UIColor.paleGray.cgColor
        view_Back.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        view_Back.borderWidth = 2
        view_Back.borderColor = UIColor.white.cgColor
        view_Back.addInnerGradientViewWithImage(frame: CGRect(x: 0, y: 0, width: view_Back.frame.width*0.422, height: view_Back.frame.width*0.422), cornerRadius: (view_Back.frame.width*0.422)/2, themeColor: [UIColor.white,UIColor(red: 194/255, green: 190/255, blue: 230/255, alpha: 1.0)],imageView: playPauseImage)
        view_Back.isUserInteractionEnabled = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpViews()
        progressBar.value = 0
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if audioHelper != nil {
            audioHelper.stopAudioPlayer()
            audioHelper = nil
        }
    }
    func reloadView() {
        animator.propertyAnimator?.stopAnimation(true)
        playPauseImage.image = #imageLiteral(resourceName: "play_icon")
        if audioHelper != nil {
            audioHelper.isPlaying = false
            audioHelper.stopAudioPlayer()
            audioHelper = nil
        }
    }
    func stop_Player() {
        if audioHelper != nil,audioHelper.isPlaying {
            audioHelper.isPlaying = false
            audioHelper.stopAudioPlayer()
            audioHelper = nil
        }
    }
    @IBAction func onSlideChange(_ sender: MTCircularSlider) {
        print(sender.value)
        if audioHelper == nil { return }
        if CGFloat(audioHelper.duration) != 0 {
            audioHelper.seekTo(time: TimeInterval(CGFloat(sender.value)*CGFloat(audioHelper.duration)))
        }
        lbl_CurrentSeekTime.text = TimeInterval(sender.value).toMMSS()
        lbl_TotalSeekTime.text = audioHelper.duration.toMMSS()
        if sender.value == 0 {
            animator.propertyAnimator?.stopAnimation(true)
            playPauseImage.image = #imageLiteral(resourceName: "play_icon")
            audioHelper.isPlaying = false
            audioHelper.stopAudioPlayer()
        }
    }
    @IBAction func action_PlayPause() {
        if AppSettings.hasLogin {
            if AppSettings.hasSubscription {
                if audioHelper == nil {
                    guard let audioURLStr = viewmodel.audioList[viewmodel.currentIndex].fullAudio,audioURLStr != "" else {
                        return
                    }
                    if audioHelper != nil {
                        audioHelper.stopAudioPlayer()
                        audioHelper = nil
                    }
                    audioHelper = ProAudioPlayerHelper(song: NetworkManager.fullAudioBaseURL+audioURLStr, isShortAudio: false)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {[weak self] in
                        if self?.audioHelper == nil {return}
                        self?.lbl_TotalSeekTime.text = self?.audioHelper.duration.toMMSS()
                        self?.progressBar.maxWinds = CGFloat(self?.audioHelper.duration ?? 0)
                    }
                }
                if audioHelper.isPlaying {
                    animator.propertyAnimator?.stopAnimation(true)
                    playPauseImage.image = #imageLiteral(resourceName: "play_icon")
                    audioHelper.isPlaying = false
                    audioHelper.stopAudioPlayer()
                }
                else {
                    animator.rotateRepeat(view: view_Back)
                    animator.propertyAnimator?.startAnimation()
                    playPauseImage.image = #imageLiteral(resourceName: "pause")
                    audioHelper.isPlaying = true
                }
                audioHelper.updateSlider = {[weak self] value in
                    if self?.audioHelper == nil { return }
                    if CGFloat(self?.audioHelper.duration ?? 0) != 0 {
                        self?.progressBar.value = CGFloat(value)/CGFloat(self?.audioHelper.duration ?? 0)
                    }
                    self?.lbl_CurrentSeekTime.text = value.toMMSS()
                    self?.lbl_TotalSeekTime.text = self?.audioHelper.duration.toMMSS()
                    
                }
                audioHelper.isPlayerFinished = { [weak self] value in
                    if value {
                        self?.animator.propertyAnimator?.stopAnimation(true)
                        self?.playPauseImage.image = #imageLiteral(resourceName: "play_icon")
                        self?.audioHelper.isPlaying = false
                        self?.audioHelper.stopAudioPlayer()
                    }
                }
            }
            else {
                let storyBoard = UIStoryboard(name: "Premium", bundle: .main)
                guard let VC = storyBoard.instantiateInitialViewController() else {return}
                VC.modalPresentationStyle = .custom
                VC.transitioningDelegate = tabBarController
                present(VC, animated: true, completion: nil)
            }
        }
        else {
            let storyBoard = UIStoryboard(name: "Registration", bundle: .main)
            let VC = storyBoard.instantiateViewController(withIdentifier: "RegistrationNavVC")
            VC.modalPresentationStyle = .custom
            VC.transitioningDelegate = parentVC?.tabBarController
            parentVC?.tabBarController?.present(VC, animated: true, completion: nil)
        }
    }
    @IBAction private func action_info(_ sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SoundDescInfoPopUp") as! SoundDescInfoPopUp
        vc.selectedPopUpType = .SoundPro
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle   = .crossDissolve
        parentVC?.tabBarController?.present(vc, animated: true, completion: nil)
    }
}
