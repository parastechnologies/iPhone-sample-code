//
//  UploadMusicVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 28/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
import AVFoundation
class UploadMusicVC: BaseClassVC {
    @IBOutlet weak var audioVisualizationView       : AudioVisualizationView!
    @IBOutlet weak var audioVisualizationScrollView : UIScrollView!
    @IBOutlet weak var audioVisual_LeadingConst     : NSLayoutConstraint!
    @IBOutlet weak var audioVisual_TrailingConst    : NSLayoutConstraint!
    @IBOutlet weak var audioVisual_WidthConst       : NSLayoutConstraint!
    @IBOutlet weak var btn_back                     : SoftUIView!
    @IBOutlet weak var btn_Pause                    : SoftUIView!
    @IBOutlet weak var btn_Replay                   : SoftUIView!
    @IBOutlet weak var btn_Next                     : SoftUIView!
    @IBOutlet var btn_Roles                         : [SoftUIView]! {
        didSet {
            for btn in btn_Roles {
                btn.isHidden = true
            }
        }
    }
    var viewModel                                   : UploadSoundViewModel! {
        didSet { if let song                        = selectedURL { viewModel.audioLink = song } }
    }
    private let rangeSlider                         = RangeSlider(frame: CGRect.zero)
    private var playPauseImage                      : UIImageView!
    var selectedURL                                 : URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioSession()
        rangeSlider.delegate = self
        viewModel            = UploadSoundViewModel()
        view.addSubview(rangeSlider)
        viewModel.fetchRoles()
        viewModel.didFinishFetch = { [unowned self] in
            DispatchQueue.main.async {
                setRoleButton()
            }
        }
        viewModel.didFinishExtract = { [unowned self] in
            DispatchQueue.main.async {
                viewModel.isPlayingAudio = true
                playPauseImage.image = #imageLiteral(resourceName: "icon_pause")
                btn_Pause.isSelected     = true
            }
        }
        if AppSettings.uploadTutsCount <= 3 {
            DispatchQueue.main.asyncAfter(deadline: .now()) { [unowned self] in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadMusicTutsVC") as! UploadMusicTutsVC
                vc.modalPresentationStyle = .custom
                vc.modalTransitionStyle   = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [unowned self] in
            setMeters()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
        setRoleButton()
    }
    func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, policy: .default, options: [.allowBluetoothA2DP,.defaultToSpeaker])
            try session.setActive(true)
        } catch {
            print(error.localizedDescription)
        }
    }
    private func setMeters() {
        audioVisual_WidthConst.constant    = CGFloat(viewModel.duration) * 2.6
        audioVisualizationView.play(from: viewModel.audioLink)
        audioVisual_LeadingConst.constant  = self.view.bounds.width/2
        audioVisual_TrailingConst.constant = self.view.bounds.width/2 - (3*15)
        rangeSlider.frame    = CGRect(x: 0, y: audioVisualizationScrollView.frame.origin.y-20, width: audioVisualizationScrollView.frame.width, height: audioVisualizationScrollView.frame.height+40)
        rangeSlider.insertSubview(audioVisualizationScrollView, at: 0)
        
        audioVisualizationView.selected_LowerValue = (audioVisualizationScrollView.contentOffset.x)
        audioVisualizationView.selected_UpperValue = ((CGFloat(rangeSlider.upperValue) - 0.5) * self.view.bounds.width) + (audioVisualizationScrollView.contentOffset.x)
        audioVisualizationView.play(from: viewModel.audioLink)
        viewModel.lowerRange = Double(audioVisualizationView.selected_LowerValue / 2.6)/viewModel.duration
        viewModel.upperRange = Double((viewModel.lowerRange*viewModel.duration)+Double(Double(Double(rangeSlider.upperValue) - 0.5)*100.0))/viewModel.duration
    }
    private func setUpViews() {
        btn_back.type = .pushButton
        btn_back.addTarget(self, action: #selector(action_Back), for: .touchDown)
        btn_back.cornerRadius = 10
        btn_back.mainColor = UIColor.darkBackGround.cgColor
        btn_back.darkShadowColor = UIColor.black.cgColor
        btn_back.lightShadowColor = UIColor.darkGray.cgColor
        btn_back.setButtonImage(image: #imageLiteral(resourceName: "icon_back"))
        
        btn_Pause.type = .toggleButton
        btn_Pause.addTarget(self, action: #selector(action_PlayPause), for: .touchDown)
        btn_Pause.cornerRadius = 10
        btn_Pause.mainColor = UIColor.darkBackGround.cgColor
        btn_Pause.darkShadowColor = UIColor.black.cgColor
        btn_Pause.lightShadowColor = UIColor.darkGray.cgColor
        playPauseImage = btn_Pause.setButtonImage(image: #imageLiteral(resourceName: "play_icon_white"))
        
        btn_Replay.type = .pushButton
        btn_Replay.addTarget(self, action: #selector(action_Replay), for: .touchDown)
        btn_Replay.cornerRadius = 10
        btn_Replay.mainColor = UIColor.darkBackGround.cgColor
        btn_Replay.darkShadowColor = UIColor.black.cgColor
        btn_Replay.lightShadowColor = UIColor.darkGray.cgColor
        btn_Replay.setButtonImage(image: #imageLiteral(resourceName: "Icon_refresh"))
        
        btn_Next.type = .pushButton
        btn_Next.addTarget(self, action: #selector(action_Next), for: .touchDown)
        btn_Next.cornerRadius = ((UIScreen.main.bounds.width-40)*29)/374
        btn_Next.borderColor = UIColor.paleGray.cgColor
        btn_Next.borderWidth = 5
        btn_Next.mainColor   = UIColor.brightPurple.cgColor
        btn_Next.setButtonTitle(font: .Avenir_Medium(size: 25), title: "Next",titleColor: .white)
    }
    private func setRoleButton() {
        for btn in btn_Roles {
            btn.isHidden = false
            btn.type = .toggleButton
            btn.addTarget(self, action: #selector(action_BtnSelection(_:)), for: .touchDown)
            btn.cornerRadius = 10
            btn.mainColor = UIColor.paleGray.cgColor
            btn.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
            if btn.tag == 6 && viewModel.rolesArray.count >= btn.tag {
                btn.setButtonTitle(font: .AvenirLTPRo_Bold(size: 13), title: "More")
                btn.borderWidth = 2
                btn.borderColor   = UIColor.black.cgColor
            }
            else if viewModel.rolesArray.count >= btn.tag {
                btn.setButtonTitle(font: .AvenirLTPRo_Bold(size: 13), title: viewModel.rolesArray[btn.tag-1].roleName ?? "")
                btn.borderWidth = 1
                btn.borderColor   = UIColor.brightPurple.cgColor
            }
            else {
                btn.isHidden = true
            }
        }
    }
    @objc private func action_PlayPause() {
        if viewModel.isPlayingAudio {
            viewModel.isPlayingAudio = false
            playPauseImage.image = #imageLiteral(resourceName: "play_icon_white")
        }
        else {
            viewModel.isPlayingAudio = true
            playPauseImage.image = #imageLiteral(resourceName: "icon_pause")
        }
    }
    @objc private func action_Replay() {
        viewModel.isPlayingAudio = false
        playPauseImage.image = #imageLiteral(resourceName: "play_icon_white")
        btn_Pause.isSelected = false
    }
    @objc private func action_BtnSelection(_ sender:SoftUIView) {
        if sender.tag == 6 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "UploadSelectRolePopUp") as! UploadSelectRolePopUp
            vc.modalPresentationStyle = .custom
            vc.modalTransitionStyle   = .crossDissolve
            present(vc, animated: true, completion: nil)
        }
        else {
            if let index = viewModel.selectedRoles.firstIndex(of: viewModel.rolesArray[sender.tag-1]) {
                viewModel.selectedRoles.remove(at: index)
                btn_Roles[sender.tag-1].isSelected = false
            }
            else {
                viewModel.selectedRoles.append(viewModel.rolesArray[sender.tag-1])
                btn_Roles[sender.tag-1].isSelected = true
            }
        }
    }
    @objc private func action_Next() {
        if viewModel.selectedRoles.isEmpty {
            showErrorMessages(message: "Please select minimum one Role")
            return
        }
        performSegue(withIdentifier: "uploadMusicGoal", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UploadMusicGoalVC {
            vc.viewModel = self.viewModel
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if viewModel.isPlayingAudio {
            viewModel.isPlayingAudio = false
            playPauseImage.image = #imageLiteral(resourceName: "play_icon_white")
        }
    }
}
extension UploadMusicVC : RangeSliderDelegate, UIScrollViewDelegate {
    func startTracking() {
        viewModel.isPlayingAudio = false
        playPauseImage.image     = #imageLiteral(resourceName: "play_icon_white")
        btn_Pause.isSelected     = false
    }
    func update() {
        audioVisualizationView.selected_LowerValue = (audioVisualizationScrollView.contentOffset.x)
        audioVisualizationView.selected_UpperValue = ((CGFloat(rangeSlider.upperValue) - 0.5) * self.view.bounds.width) + (audioVisualizationScrollView.contentOffset.x)
        audioVisualizationView.play(from: viewModel.audioLink)
        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
        viewModel.lowerRange     = Double(audioVisualizationView.selected_LowerValue / 2.6)/viewModel.duration
        viewModel.upperRange     = Double((viewModel.lowerRange*viewModel.duration)+Double(Double(Double(rangeSlider.upperValue) - 0.5)*100.0))/viewModel.duration
        viewModel.isPlayingAudio = false
        playPauseImage.image     = #imageLiteral(resourceName: "play_icon_white")
        btn_Pause.isSelected     = false
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        audioVisualizationView.selected_LowerValue = scrollView.contentOffset.x
        audioVisualizationView.selected_UpperValue = ((CGFloat(rangeSlider.upperValue) - 0.5) * self.view.bounds.width) + (scrollView.contentOffset.x)
        audioVisualizationView.play(from: viewModel.audioLink)
        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
        viewModel.lowerRange     = Double(audioVisualizationView.selected_LowerValue / 2.6)/viewModel.duration
        viewModel.upperRange     = Double((viewModel.lowerRange*viewModel.duration)+Double(Double(Double(rangeSlider.upperValue) - 0.5)*100.0))/viewModel.duration
        viewModel.isPlayingAudio = false
        playPauseImage.image     = #imageLiteral(resourceName: "play_icon_white")
        btn_Pause.isSelected     = false
    }
}
