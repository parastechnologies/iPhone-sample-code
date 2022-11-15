//
//  SongDetailSoundWithProgressVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 25/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SongDetailSoundWithProgressVC: UIViewController {
    private var playPauseImage = UIImageView(image: #imageLiteral(resourceName: "pause"))
    @IBOutlet weak var view_Back           : SoftUIView!
    private var timer: Timer?
    private var progressCounter:Float = 0
    private var progressValue = Float()
    private var isSoundFile = true
    private var shapeLayer = [CAShapeLayer]()
    //private var animator: AnimatorFactory = AnimatorFactory()
    private var audioHelper : AudioPlayerHelper!
    weak var parentVC   : SongDetailContainerVC?
    var viewmodel       : SongPopUpViewModel!
    var isZero          = false
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
        view_Back.cornerRadius = view_Back.frame.width/2
        view_Back.mainColor = UIColor.darkBackGround.cgColor
        view_Back.darkShadowColor = UIColor.black.cgColor
        view_Back.lightShadowColor = UIColor.semiDarkShadow.cgColor
        view_Back.borderWidth = 2
        view_Back.borderColor = UIColor.black.cgColor
        shapeLayer = view_Back.addInnerGradientViewWithImageAndStripe(frame: CGRect(x: 0, y: 0, width: view_Back.frame.width*0.422, height: view_Back.frame.width*0.422), cornerRadius: (view_Back.frame.width*0.422)/2, themeColor: [UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1.0),UIColor.black],imageView: playPauseImage)
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UpdatePlayerStatus()
    }
    func UpdatePlayerStatus() {
        guard let audioURLStr = viewmodel.selectedAudio?.trimAudio,audioURLStr != "" else {
            return
        }
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
        //animator.rotateRepeat(view: view_Back)
        //animator.propertyAnimator?.startAnimation()
        audioHelper.startPlayer()
        audioHelper.playerFinsh = { [weak self] in
            DispatchQueue.main.async {
                self?.playPauseImage.image = #imageLiteral(resourceName: "play_icon")
                self?.audioHelper.isPlaying = false
                //self?.animator.propertyAnimator?.stopAnimation(true)
                self?.audioHelper.stopAudioPlayer()
                self?.view_Back.transform = .identity
            }
        }
    }
    func stop_Player() {
        if audioHelper != nil {
            audioHelper.stopAudioPlayer()
            //animator.propertyAnimator?.stopAnimation(true)
            playPauseImage.image = #imageLiteral(resourceName: "play_icon")
            audioHelper.isPlaying = false
            audioHelper.stopAudioPlayer()
            timer?.invalidate()
        }
    }
    @IBAction func action_PlayPause() {
        if audioHelper == nil {
            UpdatePlayerStatus()
        }
        if audioHelper.isPlaying {
            //animator.propertyAnimator?.stopAnimation(true)
            playPauseImage.image = #imageLiteral(resourceName: "play_icon")
            audioHelper.isPlaying = false
            audioHelper.stopAudioPlayer()
        }
        else {
            playPauseImage.image = #imageLiteral(resourceName: "pause")
            audioHelper.isPlaying = true
            //animator.rotateRepeat(view: view_Back)
            //animator.propertyAnimator?.startAnimation()
            audioHelper.startPlayer()
        }
    }
}
