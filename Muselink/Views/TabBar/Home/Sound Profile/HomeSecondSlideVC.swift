//
//  HomeSecondSlideVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 08/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
import AVFoundation
import Accelerate
class HomeSecondSlideVC: UIViewController {
    private var playPauseImage = UIImageView(image: #imageLiteral(resourceName: "play_icon"))
    @IBOutlet weak var view_Back           : SoftUIView!
    @IBOutlet weak var btn_Description     : SoftUIView!
        
    private var shapeLayer = [CAShapeLayer]()
    private var audioHelper : AudioPlayerHelper!
    //private var animator: AnimatorFactory = AnimatorFactory()
    weak var parentVC : HomeTabVC?
    var viewmodel     : SoundProfileViewModel!
    var loopCount     = 0
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view_Back.cornerRadius = view_Back.frame.width/2
        setUpViews()
    }
    private func setUpViews() {
        view_Back.type = .toggleButton
        view_Back.addTarget(self, action: #selector(action_PlayPause), for: .touchDown)
        view_Back.cornerRadius = view_Back.frame.width/2
        view_Back.mainColor = UIColor.paleGray.cgColor
        view_Back.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        view_Back.borderWidth = 2
        view_Back.borderColor = UIColor.white.cgColor
        shapeLayer = view_Back.addInnerGradientViewWithImageAndStripe(frame: CGRect(x: 0, y: 0, width: view_Back.frame.width*0.422, height: view_Back.frame.width*0.422), cornerRadius: (view_Back.frame.width*0.422)/2, themeColor: [UIColor.white,UIColor(red: 194/255, green: 190/255, blue: 230/255, alpha: 1.0)],imageView: playPauseImage)
        btn_Description.type = .pushButton
        btn_Description.addTarget(self, action: #selector(action_Description), for: .touchDown)
        btn_Description.cornerRadius = 10
        btn_Description.mainColor = UIColor.paleGray.cgColor
        btn_Description.darkShadowColor = UIColor(white: 0, alpha: 0.35).cgColor
        btn_Description.lightShadowColor = UIColor.white.cgColor
        btn_Description.borderWidth = 1
        btn_Description.borderColor = UIColor.brightPurple.cgColor
        btn_Description.setButtonTitle(font: UIFont.AvenirLTPRo_Demi(size: 17.upperDynamic()), title: "Description",titleColor: .darkGray)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loopCount = 0
        UpdatePlayerStatus()
    }
    override func viewDidDisappear(_ animated: Bool) {
        if audioHelper == nil { return }
        audioHelper.stopAudioPlayer()
        audioHelper = nil
    }
    func UpdatePlayerStatus() {
        guard let audioURLStr = viewmodel.audioList[viewmodel.currentIndex].trimAudio,audioURLStr != "" else { return }
        if audioHelper != nil {
            audioHelper.stopAudioPlayer()
            audioHelper = nil
        }
        audioHelper = AudioPlayerHelper(song: NetworkManager.trimAudioBaseURL+audioURLStr)
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
       // animator.rotateRepeat(view: view_Back)
       // animator.propertyAnimator?.startAnimation()
        audioHelper.startPlayer()
        audioHelper.playerFinsh = { [weak self] in
            DispatchQueue.main.async {
                if self?.loopCount ?? 0 < 3 {
                    self?.loopCount += 1
                    self?.audioHelper.playAgain()
                }
                else {
                    self?.playPauseImage.image = #imageLiteral(resourceName: "play_icon")
                    self?.audioHelper.isPlaying = false
                   // self?.animator.propertyAnimator?.stopAnimation(true)
                    self?.audioHelper.stopAudioPlayer()
                    self?.view_Back.transform = .identity
                }
            }
        }
    }
    func stop_Player() {
        if audioHelper != nil {
            //animator.propertyAnimator?.stopAnimation(true)
            playPauseImage.image = #imageLiteral(resourceName: "play_icon")
            audioHelper.isPlaying = false
            audioHelper.stopAudioPlayer()
        }
    }
    @IBAction func action_PlayPause() {
        loopCount = 0
        if audioHelper == nil {
            UpdatePlayerStatus()
        }
        if audioHelper.isPlaying {
           // animator.propertyAnimator?.stopAnimation(true)
            playPauseImage.image = #imageLiteral(resourceName: "play_icon")
            audioHelper.isPlaying = false
            audioHelper.stopAudioPlayer()
        }
        else {
            playPauseImage.image = #imageLiteral(resourceName: "pause")
            audioHelper.isPlaying = true
            //animator.rotateRepeat(view: view_Back)
           // animator.propertyAnimator?.startAnimation()
            audioHelper.startPlayer()
        }
    }
    @objc private func action_Description() {
        viewmodel.fetchAudioDescriotion()
        viewmodel.didFinishFetch_Description = {
            DispatchQueue.main.asyncAfter(deadline: .now()) { [unowned self] in
                if audioHelper != nil {
                    audioHelper.stopAudioPlayer()
                    audioHelper = nil
                }
                let vc = storyboard?.instantiateViewController(withIdentifier: "SoundFileDescriptionDetailVC") as! SoundFileDescriptionDetailVC
                vc.callback_ViewDisappear = {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                        self.UpdatePlayerStatus()
                    }
                }
                vc.viewmodel = viewmodel
                parentVC?.tabBarController?.present(vc, animated: true, completion: nil)
            }
        }
    }
}
