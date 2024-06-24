//
//  UploadToServerVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 29/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit

class UploadToServerVC: BaseClassVC {
    @IBOutlet weak var btn_Continue   : SoftUIView!
    @IBOutlet weak var view_Last      : SoftUIView!
    @IBOutlet weak var view_Middle    : SoftUIView!
    @IBOutlet weak var view_First     : SoftUIView!
    @IBOutlet weak var view_Recording : UIView!
    @IBOutlet weak var lbl_Uploading  : UILabel!
    @IBOutlet weak var lbl_DailyTips  : UILabel!
    private var lbl_Percent           : UILabel!
    private var shapeLayer            = [CAShapeLayer]()
    private var timer                 : Timer?
    var viewModel                     : UploadSoundViewModel!
    
    
    @IBOutlet weak var view_Back : SoftUIView!
    private var recShapeLayer       = [CAShapeLayer]()
    private var recTimer            : Timer?
    private var audioHelper      : AudioPlayerHelper!
    //private var animator         : AnimatorFactory = AnimatorFactory()
    private var isZero           = false
    private var playPauseImage   = UIImageView(image: #imageLiteral(resourceName: "play_icon"))
    private let flipBook         = FlipBook()
    var audioURLStr              = String()
    var didRecordingComplete     : ((URL)->())?
    var didRecordingFailure      : ((String)->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_Uploading.text = "Genrating Preview..."
        audioURLStr = viewModel.shortAudioLink.absoluteString
        didRecordingComplete = { [weak self] videoURL in
            print("Mixing complete ***************************")
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.viewModel.videoURL = videoURL
                self.lbl_Uploading.text = "Uploading..."
                self.lbl_Percent.text = "0%"
                for index in self.shapeLayer {
                    index.isHidden = true
                }
                self.viewModel.upload()
            }
        }
        didRecordingFailure = { [weak self] error in
            print("Mixing Failed ***************************")
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.lbl_Uploading.text = "Uploading..."
                self.lbl_Percent.text = "0%"
                for index in self.shapeLayer {
                    index.isHidden = true
                }
                self.viewModel.upload()
            }
        }
        viewModel.didFinishFetch = {[weak self] in
            self?.showSuccessMessages(message: "File Uploaded successfully")
        }
        viewModel.didUpdateProgress = {[weak self] progress in
            guard let self = self else {return}
            self.lbl_Percent.text = "\(Int(progress*100))%"
            for index in 0...Int(progress*120) {
                if self.shapeLayer.count > index {
                    self.shapeLayer[index].isHidden  = false
                    self.shapeLayer[index].strokeEnd = 1
                }
            }
            if progress == 1 {
                self.lbl_Uploading.text = "Upload Completed"
                self.btn_Continue.isUserInteractionEnabled = true
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
        recordingSetUpViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        UpdatePlayerStatus()
    }
    private func setUpViews() {
        view_Last.type = .normal
        view_Last.cornerRadius = view_Last.frame.height/2
        view_Last.isSelected = true
        view_Last.mainColor = UIColor.darkBackGround.cgColor
        view_Last.darkShadowColor = UIColor.black.cgColor
        view_Last.lightShadowColor = UIColor.darkGray.cgColor
        
        view_Middle.type = .normal
        view_Middle.cornerRadius = view_Middle.frame.height/2
        view_Middle.mainColor = UIColor.darkBackGround.cgColor
        view_Middle.darkShadowColor = UIColor.black.cgColor
        view_Middle.lightShadowColor = UIColor.darkGray.cgColor
        
        view_First.type = .normal
        view_First.cornerRadius = view_First.frame.height/2
        view_First.mainColor = UIColor.black.cgColor
        view_First.darkShadowColor = UIColor.black.cgColor
        view_First.lightShadowColor = UIColor.darkGray.cgColor
        lbl_Percent = view_First.setButtonTitle(font: .Avenir_Medium(size: 40), title: "0%", titleColor: .white)
        
        btn_Continue.type = .pushButton
        btn_Continue.addTarget(self, action: #selector(action_Continue), for: .touchDown)
        btn_Continue.cornerRadius = btn_Continue.frame.height/2
        btn_Continue.mainColor = UIColor.darkBackGround.cgColor
        btn_Continue.darkShadowColor = UIColor.black.cgColor
        btn_Continue.lightShadowColor = UIColor.darkGray.cgColor
        btn_Continue.borderWidth = 2
        btn_Continue.borderColor = UIColor.purple.cgColor
        btn_Continue.setButtonTitle(font: .Avenir_Medium(size: 20), title: "Continue",titleColor: .paleGray)
        btn_Continue.isUserInteractionEnabled = false
        
        shapeLayer = view_Last.addInnerGradientViewWithProgress()
        
        lbl_DailyTips.text = viewModel.dailyTips?.name ?? "Remember to share your content across other platforms"
    }
    @objc private func action_Continue() {
        if timer == nil {
            performSegue(withIdentifier: "uploadComplete", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UploadCompleteVC {
            vc.viewModel = viewModel
        }
    }
}
extension UploadToServerVC {
    private func recordingSetUpViews() {
        view_Back.type = .toggleButton
        view_Back.cornerRadius = view_Back.frame.width/2
        view_Back.mainColor = UIColor.paleGray.cgColor
        view_Back.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        view_Back.borderWidth = 2
        view_Back.borderColor = UIColor.white.cgColor
        recShapeLayer = view_Back.addInnerGradientViewWithImageAndStripe(frame: CGRect(x: 0, y: 0, width: view_Back.frame.width*0.42, height: view_Back.frame.width*0.42), cornerRadius: (view_Back.frame.width*0.42)/2, themeColor: [UIColor.white,UIColor(red: 194/255, green: 190/255, blue: 230/255, alpha: 1.0)],imageView: playPauseImage,upperPoint: 100)
        recTimer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true, block: { [weak self] (tmr) in
            guard let self = self else {return}
            if self.audioHelper == nil || !self.audioHelper.isPlaying {
                return
            }
            if self.audioHelper != nil {
                if self.audioHelper.duration == 0 || self.audioHelper.currentTime < 0{
                    return
                }
                let progress = CGFloat(self.audioHelper.currentTime)/CGFloat(self.audioHelper.duration)
                self.lbl_Percent.text = "\(Int(progress*100))%"
                for index in 0...Int(progress*120) {
                    if self.shapeLayer.count > index {
                        self.shapeLayer[index].isHidden  = false
                        self.shapeLayer[index].strokeEnd = 1
                    }
                }
            }
        })
        RunLoop.current.add(recTimer!, forMode: .common)
    }
    func UpdatePlayerStatus() {
        if audioHelper != nil {
            audioHelper.stopAudioPlayer()
            audioHelper = nil
        }
        audioHelper = AudioPlayerHelper(song: audioURLStr,isLocal: true)
        playPauseImage.image = #imageLiteral(resourceName: "pause")
        audioHelper.isPlaying = true
        //animator.rotateRepeat(view: view_Back)
        //animator.propertyAnimator?.startAnimation()
        audioHelper.playerFinsh = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.audioHelper.setupAudioSession()
                self.playPauseImage.image = #imageLiteral(resourceName: "play_icon")
                self.audioHelper.isPlaying = false
               // self.animator.propertyAnimator?.stopAnimation(true)
                self.view_Back.transform = .identity
                self.recTimer?.invalidate()
                if self.audioHelper == nil {
                    return
                }
                self.audioHelper.stopAudioPlayer()
                self.audioHelper = nil
                self.flipBook.stop()
            }
        }
        flipBook.startRecording(self.view_Recording) { [weak self] result in
            // Switch on result
            switch result {
            case .success(let asset):
                // Switch on the asset that's returned
                switch asset {
                case .video(let url):
                    print(url)
                    guard let self = self else {
                        return
                    }
                    self.flipBook.mergeFilesWithUrl(videoUrl: url, audioUrl: URL(string: self.audioURLStr)!) { result in
                        switch result {

                        case .success(let mixVideo):
                            print(mixVideo.outputURL ?? "")
                            if let outURL = mixVideo.outputURL {
                                self.didRecordingComplete?(outURL)
                            }
                        case .failure(let error):
                            print("Error usdh s")
                            self.didRecordingFailure?(error.localizedDescription)
                        }
                    }
                    break
                    // Do something with the video
                // We expect a video so do nothing for .livePhoto and .gif
                case .livePhoto, .gif:
                    break
                }
            case .failure(let error):
                // Handle error in recording
                print(error)
                self?.didRecordingFailure?(error.localizedDescription)
            }
        }
    }
}
