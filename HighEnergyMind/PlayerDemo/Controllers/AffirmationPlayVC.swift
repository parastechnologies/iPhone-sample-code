//
//  AffirmationPlayVC.swift
//  HighEnergyMind
//
//  Created by iOS TL on 11/03/24.
//

import UIKit
import IBAnimatable
import AVKit
import AVFoundation
import MediaPlayer

class AffirmationPlayVC: BaseClassVC, AVAudioPlayerDelegate {
    
    
    //MARK: - OUTLETS
    @IBOutlet weak var affColl                  : UICollectionView!
    @IBOutlet weak var slider                   : AnimatableSlider!
    @IBOutlet weak var favBtn                   : UIButton!
    @IBOutlet weak var lblcurrentText           : UILabel!
    @IBOutlet weak var lblOverallDuration       : UILabel!
    @IBOutlet weak var ButtonPlay               : UIButton!
    @IBOutlet weak var trackTitleLbl            : UILabel!
    @IBOutlet weak var trackImg                 : AnimatableImageView!
    @IBOutlet weak var loading                  : UIActivityIndicatorView!
    @IBOutlet weak var loopBtn                  : AnimatableButton!
    
    
    //MARK: - VARIABLES AND OBJECTS
    var selectedAffirmation             : LastTrack?
    var selectedAffirmationDetails      : [AffirmationDetailsData]?
    var selectedAffirmationDetailsCopy  : [AffirmationDetailsData]?
    var vm                              : HomeViewModel!
    var didTapBackBtn                   : ((LastTrack) -> ())?
    var player                          : AVPlayer?
    var playerItem                      : AVPlayerItem?
    var affPlayer                       : AVPlayer?
    var affPlayerItem                   : AVPlayerItem?
    var timeObserver                    : Any?
    var totalDuration                   = 0.0
    var isPlayBtnTap                    = false
    var isPause                         = true
    var interval                        : Int64 = 0
    var isLoop                          = false
//    var timer                           : Timer?
    var affTimer                        : Timer?
    var delayTimer                      : Timer?
    var affDelay                        = 5
    var remainingSecondsDuringDelay     = 0
    var selectedSpeakerIndex            = 0
    var selectedAffIndex                = 0 // index of the selectedAffirmation array which indicates the currently playing affirmation
    var currentTimeCount                = 0.0
    var observer                        : NSKeyValueObservation?
    var isLastAffPlayed                 = false
    var isDelayInProgress               = false
    var delayInProgress                 = 0
    var isLoopFromAffLength             = false
    var newAffLengthTimer               : Timer?
    var newAffLengthTimerCnt            = 0
    var newMusicLengthTimer             : Timer?
    var newMusicLengthTimerCnt          = 0
    var affLength                       = 0
    var musicLength                     = 0
    var affVolume                       : Float = 1.0
    var musicVolume                     : Float = 1.0
    var isSilentAff                     : Bool = false
    
    
    
    
    //MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = HomeViewModel(type: .markFav)
        setUpVM(model: vm)
        
        if affPlayer != nil {
            affPlayer?.pause()
            affPlayer = nil
        }
        if player != nil {
            player?.pause()
            player = nil
        }
        
        if selectedAffirmationDetails?.count ?? 0 > 0 {
            var speakerIndex = selectedAffirmationDetails?[0].audioFiles?.count ?? 0
            speakerIndex -= 1
            selectedSpeakerIndex = UserData.isSilentAff ? speakerIndex : 0
        } else {
            selectedSpeakerIndex = 0
        }
        
        slider.minimumValue = 0
        slider.maximumValue = Float(slider.frame.width)
        updateFavImg(isFav: selectedAffirmation?.isFavourite ?? 0)
        setupUI()
        slider.tintColor = UIColor(red: 0.93, green: 0.74, blue: 0.00, alpha: 1.00)
        slider.isUserInteractionEnabled = false
        
        
        ButtonPlay.alpha = 0.6
        ButtonPlay.isUserInteractionEnabled = false
        loading.startAnimating()
        setupMusicAndAudio()
        selectedAffirmationDetailsCopy = selectedAffirmationDetails
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//        affPlayer?.pause()
//        player?.pause()
//        affPlayer = nil
//        player = nil
        
        
        affPlayer?.pause()
        affPlayer = nil
        if player != nil{
            player?.pause()
            player = nil
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupMusicAndAudio() {
        DispatchQueue.main.async {
            if let urlStr = URL(string: self.selectedAffirmation?.backgroundTrackMusic ?? "") {
                self.addMusic(music: urlStr)
            }
            if self.selectedAffirmationDetails?.count ?? 0 > 0  && self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?.count ?? 0 > 0 {
                if let affUrlStr = URL(string: UserData.language.lowercased() == "english" ? self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affEnglish ?? "" : self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affGerman ?? "") {
                    
                    self.addAffirmationAudio(affMusic: affUrlStr)
                    self.calculateDuration()
                }
            }
        }
    }
    
    func setupUI() {
        trackTitleLbl.text = selectedAffirmation?.trackTitle ?? ""
        trackImg.showImage(imgURL: selectedAffirmation?.trackThumbnail ?? "")
    }
    
//    func updateUIAfterChangingMusic(track: BackgroundAudio) {
//        trackTitleLbl.text = track.backgroundTitle ?? ""
//        trackImg.showImage(imgURL: track.backgroundImg ?? "")
//    }
    
//    func initializeTimerForAffirmation() {
//        timer = Timer.scheduledTimer(timeInterval: Double(affDelay), target: self, selector: #selector(swipeColl), userInfo: nil, repeats: true)
//    }
//    
//    func invalidateTimerForAffirmation() {
//        timer?.invalidate()
//    }
    
    func updateFavImg(isFav: Int) {
        favBtn.setImage(UIImage(named: (self.selectedAffirmation?.isFavourite == 1) ? "heart_filled_with_bg_red" : "heart_whiteBg"), for: .normal)
    }
    
    //MARK: - IBACTIONS
    @objc func swipeColl() {
        let cellSize = CGSizeMake(self.affColl.frame.width, self.affColl.frame.height)
        let contentOffset = affColl.contentOffset
        affColl.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height), animated: true)
    }
    
    func swipeCollToFirstAff() {
        let cellSize = CGSizeMake(self.affColl.frame.width, self.affColl.frame.height)
        let contentOffset = affColl.contentOffset
        affColl.scrollRectToVisible(CGRectMake(0, contentOffset.y, cellSize.width, cellSize.height), animated: true)
    }
    
    @IBAction func shareTap(_ sender: UIButton) {
        let message = "Check this track"
        if let link = NSURL(string: "https://php.parastechnologies.in/highMindEnergy/api/v1/api/inviteLink/\(selectedAffirmation?.id ?? 0)")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            //                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    @IBAction func backTap(_ sender: UIButton) {
        didTapBackBtn?(selectedAffirmation ?? LastTrack())
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func audioBtnTap(_ sender: UIButton) {
//        let vc = presentVC(ViewControllers.AudioSettingsVC, storyboard: StoryBoardNames.storyBoardMain, presentationStyle: .overFullScreen) as! AudioSettingsVC
//        vc.isComeFrom = ViewControllers.AffirmationPlayVC
//        vc.player = player
//        vc.affPlayer = affPlayer
//        vc.didFinishSettingVol = { [weak self](affVolume) in
//            guard let self else {return}
//            self.affVolume = affVolume
//            self.affPlayer?.volume = affVolume
//        }
//        vc.didFinishSettingMusicVol = { [weak self](musicVolume) in
//            guard let self else {return}
//            self.musicVolume = musicVolume
//            self.player?.volume = musicVolume
//        }
    }
    
    @IBAction func voiceBtnTap(_ sender: UIButton) {
        let vc = presentVC(ViewControllers.VoiceSettingsVC, storyboard: StoryBoardNames.storyBoardMain, presentationStyle: .overFullScreen) as! VoiceSettingsVC
        if selectedAffirmationDetails?.count ?? 0 > 0 {
            vc.audioFiles = selectedAffirmationDetails?[0].audioFiles ?? []
//            vc.audioFiles = selectedAffirmationDetailsCopy?[0].audioFiles ?? []
        }
        vc.selectedSpeaderIndex = selectedSpeakerIndex
        vc.affDelay = self.affDelay
        vc.affLength = self.affLength
        vc.musicLength = self.musicLength
        vc.isSilentAff = self.isSilentAff
        
        vc.didFinishSettingData = { isSilentAff, selectedSpeakerIndex, affDelay, affLength, musicLength in
            
            // no changes done but user still tapped save btn
            if !isSilentAff && (self.selectedSpeakerIndex == selectedSpeakerIndex) && (self.affDelay == affDelay) && (affLength == 0) && (musicLength == 0) {
                
            } else {
                self.affDelay = affDelay
                self.isSilentAff = isSilentAff
                if isSilentAff {
                    self.selectedSpeakerIndex = self.selectedAffirmationDetails?[0].audioFiles?.count ?? 0 - 1
                }
                
//                if isSilentAff != self.isSilentAff && isSilentAff {
////                    self.isPause = true
////                    self.isPlayBtnTap = false
////                    self.playPauseHandling()
//                    self.selectedAffirmationDetails?.removeAll()
//                    self.selectedAffirmationDetails = [self.selectedAffirmationDetailsCopy?.last ?? AffirmationDetailsData()]
//                    
//                }
                
                if affLength != 0 {
                    self.affLength = affLength
                    self.loopBtn.tintColor = .white
                    self.loopBtn.isUserInteractionEnabled = false
                }
                if musicLength != 0 {
                    self.musicLength = musicLength
                    self.loopBtn.tintColor = AppColor.app053343
                    self.loopBtn.isUserInteractionEnabled = true
                }
                
                
                
                if self.selectedSpeakerIndex != selectedSpeakerIndex {
                    self.selectedSpeakerIndex = selectedSpeakerIndex
                    
                    if affLength != 0 || musicLength != 0 {
                        let newDuration = Double(max(affLength, musicLength))
                        
    //                    self.calculateDuration()
    //                    self.affTimer?.invalidate()
                        
                        self.calculateSeek()
                        
                        
                        self.isLoopFromAffLength = true
                        if self.currentTimeCount < Double(affLength) {
                            self.initialiseNewAffLengthTimer()
                        }
                        if self.currentTimeCount < Double(musicLength) {
                            self.initialiseNewMusicLengthTimer()
                        }
                        
                        
                        
                        
                        if newDuration > self.totalDuration || (newDuration < self.totalDuration && self.currentTimeCount < newDuration) {
                            
                        } else {
                            
                            self.totalDuration = 0.0
                            self.currentTimeCount = 0.0
                            self.setupMusicAndAudio()
                        }
                        self.totalDuration = newDuration
                        self.lblOverallDuration.text = self.stringFromTimeInterval(interval: self.totalDuration)
                        self.slider.maximumValue = Float(self.totalDuration)
                        
                    } else {
                        if self.selectedAffIndex == 0 {
                            self.totalDuration = 0.0
                            self.currentTimeCount = 0.0
                            self.setupMusicAndAudio()
                        } else {
                            self.totalDuration = 0.0
                            self.currentTimeCount = 0.0
                            self.calculateDuration()
                            self.affTimer?.invalidate()
                            self.calculateSeek()
                            self.affPlayer?.pause()
                            
                            print("Came here")
                            if let affUrlStr = URL(string: UserData.language.lowercased() == "english" ? self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affEnglish ?? "" : self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affGerman ?? "") {
                                self.setupNextAffAudio(affMusic: affUrlStr) {
                                    Indicator.shared.hide()
                                    if self.isPlayBtnTap { self.updateCurrentPlayerTime(affDelay: affDelay) }
                                    if self.isPlayBtnTap && !self.isDelayInProgress { self.affPlayer?.play() }
                                }
                            }
                        }
                    }
                    
                    
                } else {
                    if affLength != 0 || musicLength != 0 {
                        self.setTrackPlayerAfterCustomisation()
                    } else {
                        self.totalDuration = 0.0
                        self.currentTimeCount = 0.0
                        self.calculateDuration()
                        self.affTimer?.invalidate()
                        self.calculateSeek()
                        if self.isPlayBtnTap { self.updateCurrentPlayerTime(affDelay: affDelay) }
                    }
                }
            }
            
            
        }
    }
    
    func setTrackPlayerAfterCustomisation() {
        let newDuration = Double(max(affLength, musicLength))
        if newDuration > self.totalDuration || (newDuration < self.totalDuration && currentTimeCount < newDuration) {
            self.isLoopFromAffLength = true
            if self.currentTimeCount < Double(affLength) {
                self.initialiseNewAffLengthTimer()
            }
            if self.currentTimeCount < Double(musicLength) {
                self.initialiseNewMusicLengthTimer()
            }
        } else {
            self.selectedAffIndex = 0
            self.currentTimeCount = 0
            if let affUrlStr = URL(string: UserData.language.lowercased() == "english" ? self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affEnglish ?? "" : self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affGerman ?? "") {
                self.setupNextAffAudio(affMusic: affUrlStr) {
                    Indicator.shared.hide()
                    self.affPlayer?.play()
                }
            }
            if let urlStr = URL(string: self.selectedAffirmation?.backgroundTrackMusic ?? "") {
                self.addMusic(music: urlStr)
                self.player?.play()
            }
        }
        self.totalDuration = newDuration
        self.lblOverallDuration.text = self.stringFromTimeInterval(interval: self.totalDuration)
        self.slider.maximumValue = Float(self.totalDuration)
    }
    
    @IBAction func musicTap(_ sender: UIButton) {
//        let vc = presentVC(ViewControllers.MusicSettingsVC, storyboard: StoryBoardNames.storyBoardMain, presentationStyle: .overFullScreen) as! MusicSettingsVC
//        vc.isComeFrom = ViewControllers.AffirmationPlayVC
//        
//        vc.didSelectMusic = { bgTrack in
////            self.updateUIAfterChangingMusic(track: bgTrack)
//            if let urlStr = URL(string: bgTrack?.backgroundAudio ?? "") {
//                self.addMusic(music: urlStr)
//                self.isPlayBtnTap ? self.player?.play() : self.player?.pause()
//            }
//        }
//        
//        vc.didSelectPaidMusic = {
//            let vc = self.pushVC(ViewControllers.UnlockAllFeaturesVC, storyboard: StoryBoardNames.storyBoardMain) as! UnlockAllFeaturesVC
//            vc.isComeFrom = ViewControllers.AccountVC
//        }
//        
//        vc.didSelectSeeAll = { [weak self] musiccatId in
//            guard let self = self else { return }
//            let vc = self.pushVC(ViewControllers.SeeAllMusicVC, storyboard: StoryBoardNames.storyBoardMain) as! SeeAllMusicVC
//            vc.id = musiccatId
//            vc.isComeFrom = ViewControllers.AffirmationPlayVC
//            vc.didSelectMusic = { bgTrack in
////                self.updateUIAfterChangingMusic(track: bgTrack)
//                if let urlStr = URL(string: bgTrack.backgroundAudio ?? "") {
//                    self.addMusic(music: urlStr)
//                    self.isPlayBtnTap ? self.player?.play() : self.player?.pause()
//                }
//            }
//        }
    }
    
    @IBAction func favTap(_ sender: UIButton) {
        let isFav = selectedAffirmation?.isFavourite
        selectedAffirmation?.isFavourite = isFav == 0 ? 1 : 0
        vm.markFavApi(Id: self.selectedAffirmation?.id ?? 0, favourite: self.selectedAffirmation?.isFavourite ?? 0, type: "track")
        
        vm.didFinishFetch = { apiType in
            switch apiType {
            case .markFav:
                print("mark fav api success")
                sender.setImage(UIImage(named: (self.selectedAffirmation?.isFavourite == 1) ? "heart_filled_with_bg_red" : "heart_whiteBg"), for: .normal)
            default: return
            }
        }
    }
    
    @IBAction func loopTap(_ sender: UIButton) {
        isLoop = !isLoop
        sender.tintColor = isLoop ? UIColor.init(hexString: "#5B96A8") : UIColor.init(hexString: "#053343")
    }
    
    @IBAction func playBtnTap(_ sender: UIButton) {
        if player != nil {
            self.isPause.toggle()
            self.isPlayBtnTap.toggle()
            playPauseHandling()
            ButtonPlay.setImage(UIImage(named: isPlayBtnTap ? "playContinue" : "playBtn"), for: UIControl.State.normal)
        }
    }
    
    private func updateCurrentPlayerTime(affDelay: Int) {
        self.affTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.setCurrentPlayerTime), userInfo: nil, repeats: true)
    }
    
    private func calculateDuration() {
        for each in selectedAffirmationDetails ?? [] {
            totalDuration += Float64(UserData.language.lowercased() == "english" ? each.audioFiles?[selectedSpeakerIndex].affDurationEnglish ?? "0.0" : each.audioFiles?[selectedSpeakerIndex].affDurationGerman ?? "0.0") ?? 0.0
        }
        if selectedAffirmationDetails?.count ?? 0 > 1 {
            totalDuration += Double(((selectedAffirmationDetails?.count ?? 1) - 1)*affDelay)
        }
        totalDuration += 2
        lblOverallDuration.text = stringFromTimeInterval(interval: totalDuration)
        
        slider.maximumValue = Float(totalDuration)
        slider.isContinuous = true
    }
    
    private func calculateSeek() {
        var i = 0
        currentTimeCount = 0
        while i < selectedAffIndex {
            currentTimeCount += Float64(UserData.language.lowercased() == "english" ? selectedAffirmationDetails?[i].audioFiles?[selectedSpeakerIndex].affDurationEnglish ?? "0.0" : selectedAffirmationDetails?[i].audioFiles?[selectedSpeakerIndex].affDurationGerman ?? "0.0") ?? 0.0
            i += 1
        }
        if selectedAffirmationDetails?.count ?? 0 > 1 {
            currentTimeCount += Double((selectedAffIndex)*affDelay)
        }
        
        lblcurrentText.text = stringFromTimeInterval(interval: currentTimeCount)
        slider.value = Float(currentTimeCount)
    }
    
    @objc func setCurrentPlayerTime() {
        if self.affPlayer != nil{
            
//            if self.affPlayer!.currentItem?.status == .readyToPlay {
            
                
                self.currentTimeCount += 1
            self.lblcurrentText.text = self.stringFromTimeInterval(interval: currentTimeCount)
                self.slider.value = Float ( currentTimeCount )
//            } else {
//                print("not ready to play")
//            }
            
            
//            if self.affPlayer!.currentItem?.status == .readyToPlay {
//                if currentTimeCount < totalDuration {
//                    self.lblcurrentText.text = self.stringFromTimeInterval(interval: currentTimeCount)
//                    self.currentTimeCount += 1
//                    self.slider.value = Float ( currentTimeCount )
//                    checkIfAudioFinished()
//                } else if currentTimeCount >= totalDuration {
//                    self.lblcurrentText.text = self.stringFromTimeInterval(interval: currentTimeCount)
////                    self.currentTimeCount += 1
//                    self.slider.value = Float ( currentTimeCount )
//                    affFinishedPlaying(NSNotification(name: .AVPlayerItemDidPlayToEndTime, object: nil))
//                }
//            } else { print("not ready to play") }
        }
    }
    
    private func checkIfAudioFinished() {
        guard let affplayer = affPlayer else { return }
        
        let currentTime = affplayer.currentTime()
        guard let duration = affplayer.currentItem?.duration else { return }
        
        if currentTime == duration {
            print("almost end time of aff")
            affFinishedPlaying(NSNotification(name: .AVPlayerItemDidPlayToEndTime, object: nil))
        }
        
        // Check if the current time is close to the duration
//        if CMTimeCompare(currentTime, duration) >= 0 {
//            // Audio finished playing
//            print("almost end time of aff")
//            affFinishedPlaying(NSNotification(name: .AVPlayerItemDidPlayToEndTime, object: nil))
//        }
    }
    
    private func initialiseNewAffLengthTimer() {
        newAffLengthTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startNewAffLengthTimer), userInfo: nil, repeats: true)
    }
    
    private func initialiseNewMusicLengthTimer() {
        newMusicLengthTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startNewMusicLengthTimer), userInfo: nil, repeats: true)
    }
    
    
//    private func setAffPlayerVolume() {
//        affPlayer?.volume =
//    }
    
    @objc func startNewAffLengthTimer() {
        newAffLengthTimerCnt += 1
        if newAffLengthTimerCnt == affLength {
            
        }
        
        if affLength != 0 && affLength > musicLength && Int(currentTimeCount) >= affLength {
            
            affPlayer?.pause()
            
            if musicLength == 0 {
                player?.pause()
                self.player?.seek(to: .zero)
                self.slider.value = 0
            }
            
            self.invalidateDelayTimer()
            self.affPlayer?.seek(to: .zero)
            
            self.affTimer?.invalidate()
            
            self.isLastAffPlayed = false
            self.currentTimeCount = 0.0
            self.newAffLengthTimerCnt = 0
            self.newMusicLengthTimerCnt = 0
            self.selectedAffIndex = 0
            self.lblcurrentText.text = self.stringFromTimeInterval(interval: currentTimeCount)
            self.swipeCollToFirstAff()
            
            self.isPause = true
            self.isPlayBtnTap = false
            self.player?.seek(to: .zero)
            
            ButtonPlay.setImage(UIImage(named: "playBtn"), for: .normal)
            
            newAffLengthTimer?.invalidate()
        }
        
//        if totalDuration == Double(affLength) {
//            self.invalidateDelayTimer()
//            self.affPlayer?.seek(to: .zero)
//            self.player?.seek(to: .zero)
//            self.affTimer?.invalidate()
//            self.slider.value = 0
//            self.isLastAffPlayed = false
//            self.currentTimeCount = 0.0
//            self.newAffLengthTimerCnt = 0
//            self.newMusicLengthTimerCnt = 0
//            self.selectedAffIndex = 0
//            self.lblcurrentText.text = self.stringFromTimeInterval(interval: currentTimeCount)
//            self.swipeCollToFirstAff()
//            
//            self.isPause = false
//            self.isPlayBtnTap = true
//            self.player?.seek(to: .zero)
//            if let affUrlStr = URL(string: UserData.language.lowercased() == "english" ? self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affEnglish ?? "" : self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affGerman ?? "") {
//                self.addAffirmationAudio(affMusic: affUrlStr)
//            }
//            self.affPlayer?.play()
//            self.player?.play()
//            ButtonPlay.setImage(UIImage(named: "playContinue"), for: .normal)
//        }
    }
    
    
    @objc func startNewMusicLengthTimer() {
        newMusicLengthTimerCnt += 1
        if newMusicLengthTimerCnt == musicLength {
            
            
        }
        
        if musicLength != 0 && musicLength > affLength && Int(currentTimeCount) >= musicLength {
            
            player?.pause()
            affPlayer?.pause()
            
            self.invalidateDelayTimer()
            self.affPlayer?.seek(to: .zero)
            self.player?.seek(to: .zero)
            self.affTimer?.invalidate()
            self.slider.value = 0
            self.isLastAffPlayed = false
            self.currentTimeCount = 0.0
            self.newAffLengthTimerCnt = 0
            self.newMusicLengthTimerCnt = 0
            self.selectedAffIndex = 0
            self.lblcurrentText.text = self.stringFromTimeInterval(interval: currentTimeCount)
            self.swipeCollToFirstAff()
            
            self.isPause = true
            self.isPlayBtnTap = false
            self.player?.seek(to: .zero)
            
            ButtonPlay.setImage(UIImage(named: "playBtn"), for: .normal)
            
            newMusicLengthTimer?.invalidate()
        }
        
//        if totalDuration == Double(affLength) {
//            self.invalidateDelayTimer()
//            self.affPlayer?.seek(to: .zero)
//            self.player?.seek(to: .zero)
//            self.affTimer?.invalidate()
//            self.slider.value = 0
//            self.isLastAffPlayed = false
//            self.currentTimeCount = 0.0
//            self.newAffLengthTimerCnt = 0
//            self.newMusicLengthTimerCnt = 0
//            self.selectedAffIndex = 0
//            self.lblcurrentText.text = self.stringFromTimeInterval(interval: currentTimeCount)
//            self.swipeCollToFirstAff()
//            
//            self.isPause = false
//            self.isPlayBtnTap = true
//            self.player?.seek(to: .zero)
//            if let affUrlStr = URL(string: UserData.language.lowercased() == "english" ? self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affEnglish ?? "" : self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affGerman ?? "") {
//                self.addAffirmationAudio(affMusic: affUrlStr)
//            }
//            self.affPlayer?.play()
//            self.player?.play()
//            ButtonPlay.setImage(UIImage(named: "playContinue"), for: .normal)
//        }
    }
    
    private func addAffirmationAudio(affMusic: URL) {
        affPlayer = nil
        let affPlayerItem:AVPlayerItem = AVPlayerItem(url: affMusic)
        affPlayer = AVPlayer(playerItem: affPlayerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(self.affFinishedPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: affPlayerItem)
        affPlayer?.volume = affVolume
        setMPMediaProperty()
        
        let playbackLikelyToKeepUp = self.affPlayer?.currentItem?.isPlaybackLikelyToKeepUp
        
//        self.observer = affPlayerItem.observe(\.status, options:  [.new, .old], changeHandler: { (playerItem, change) in
//                if playerItem.status == .readyToPlay {
//                    self.loading.isHidden = true
//                    self.loading.stopAnimating()
//                    self.ButtonPlay.isUserInteractionEnabled = true
//                    self.ButtonPlay.isHidden = false
//                    self.ButtonPlay.alpha = 1
//                    self.updateCurrentPlayerTime(affDelay: self.affDelay)
//                }
//            })
        if self.affPlayer?.currentItem?.isPlaybackBufferFull ?? false {
            print("true")
        }
        if playbackLikelyToKeepUp == false{
            print("IsBuffering#####")
            self.loading.isHidden = false
            self.loading.startAnimating()
            self.ButtonPlay.isUserInteractionEnabled = false
            self.ButtonPlay.alpha = 0.6
            self.affTimer?.invalidate()
            
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                self.loading.isHidden = true
                self.loading.stopAnimating()
                self.ButtonPlay.isUserInteractionEnabled = true
                self.ButtonPlay.isHidden = false
                self.ButtonPlay.alpha = 1
                self.isPause = false
                self.isPlayBtnTap = true
                self.updateCurrentPlayerTime(affDelay: self.affDelay)
                self.player?.play()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if self.isPlayBtnTap {
                        self.affPlayer?.play()
                    }
                }
                self.ButtonPlay.setImage(UIImage(named: "playContinue"), for: .normal)
            }
        } else {
            //stop the activity indicator
            self.loading.isHidden = true
            self.ButtonPlay.isUserInteractionEnabled = true
            self.ButtonPlay.alpha = 1
            print("Buffering completed")
        }
    }
    
    private func addMusic(music:URL) {
        let playerItem:AVPlayerItem = AVPlayerItem(url: music)
        player = AVPlayer(playerItem: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        player?.volume = musicVolume
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        if hours == 0{
            return String(format: "%02d:%02d", minutes, seconds)
        }else{
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider){
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        affPlayer!.seek(to: targetTime)
        if affPlayer!.rate != 0
        {
            affPlayer?.play()
            player?.play()
        }
    }
    
    func setMPMediaProperty(){
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
        } catch {
            print("Error configuring audio session: \(error.localizedDescription)")
        }
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        
        commandCenter.playCommand.addTarget { [unowned self] event in
            if affPlayer?.rate == 0 && affPlayer != nil{
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
                self.isPause = false
                self.isPlayBtnTap = true
//                self.trackPlay()
//                self.affPlay()
                
                self.playPauseHandling()
                
                
                
                ButtonPlay.setImage(UIImage(named: "playContinue"), for: .normal)
            }
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if affPlayer != nil {
                self.isPause = true
                self.isPlayBtnTap = false
//                self.trackPause()
//                self.affPause()
//                self.affTimer?.invalidate()
//                self.invalidateDelayTimer()
                
                
                self.playPauseHandling()
                
                
                ButtonPlay.setImage(UIImage(named: "playBtn"), for: .normal)
            }
            return .success
        }
        
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = selectedAffirmation?.trackTitle ?? ""
        nowPlayingInfo[MPMediaItemPropertyArtist] = ""
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = ""
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = (affPlayer?.rate == 0) ? 1.0 : 0.0
        
        let url = URL(string: selectedAffirmation?.trackThumbnail ?? "")
        var trackImg : UIImage?
        if let url = url {
            Indicator.shared.show("")
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let imageData = data else { return }
                DispatchQueue.main.async {
                    trackImg = UIImage(data: imageData)
                    Indicator.shared.hide()
                    if let image = trackImg {
                        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                            return image
                        }
                    }
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                }
            }.resume()
        } else {
            Indicator.shared.hide()
            trackImg = UIImage(named: "playBtn")
            if let image = trackImg {
                nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
                }
            }
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }
    
    private func playPauseHandling() {
        isPlayBtnTap ? self.trackPlay() : self.trackPause()
        isPlayBtnTap && !isDelayInProgress ? currentTimeCount == 0 ? DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.affPlay() } : self.affPlay() : self.affPause()
        isPlayBtnTap ? updateCurrentPlayerTime(affDelay: affDelay) : affTimer?.invalidate()
//        isDelayInProgress && isPlayBtnTap ? initializeDelayTimer() : invalidateDelayTimer()
        if isDelayInProgress && isPlayBtnTap {
            initializeDelayTimer()
        } else {
            invalidateDelayTimer()
        }
        
//        if Double(newAffLengthTimerCnt) < currentTimeCount {
            isPlayBtnTap ? initialiseNewAffLengthTimer() : newAffLengthTimer?.invalidate()
//        }
//        if Double(newMusicLengthTimerCnt) < currentTimeCount {
            isPlayBtnTap ? initialiseNewAffLengthTimer() : newMusicLengthTimer?.invalidate()
//        }
        
        
        if !isPlayBtnTap {
            affTimer?.invalidate()
        }
    }
    
    private func trackPlay(){
        if player != nil{
            player?.play()
        }
    }
    private func trackPause(){
        player?.pause()
    }
    
    private func affPlay(){
        if affPlayer != nil{
            affPlayer?.play()
        }
    }
    private func affPause(){
        affPlayer?.pause()
    }
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        isPlayBtnTap ? self.player?.play() : self.player?.pause()
        if isLoop {
            self.player?.seek(to: .zero)
            self.player?.play()
        }
    }
    
    @objc func affFinishedPlaying( _ myNotification:NSNotification) {
        self.isPause = true
        self.affPlayer?.pause()
        print("finished playing affirmation")
        
        
        if selectedAffIndex <= selectedAffirmationDetails?.count ?? 1 - 1  {
            
            var index = selectedAffirmationDetails?.count ?? 1
            index -= 1
            if selectedAffIndex == index {
                isLastAffPlayed = true
            }
            
            if !isLastAffPlayed {
                self.selectedAffIndex += 1
                if let affUrlStr = URL(string: UserData.language.lowercased() == "english" ? self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affEnglish ?? "" : self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affGerman ?? "") {
                    
                    print("preparing next audio")
                    
                    self.setupNextAffAudio(affMusic: affUrlStr) {
                        Indicator.shared.hide()
                        
                        // initialize delay timer
                        self.initializeDelayTimer()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.affDelay)) {
//                            print("finished preparing audio")
//                            self.affPlayer?.play()
//                            self.swipeColl()
//                        }
                    }
                }
            } else {
                
                if isLoopFromAffLength {
//                    self.newAffLengthTimer?.invalidate()
//                    self.newMusicLengthTimer?.invalidate()
                    self.invalidateDelayTimer()
//                    self.affPlayer?.seek(to: .zero)
//                    self.player?.seek(to: .zero)
//                    self.affTimer?.invalidate()
                    self.isLastAffPlayed = false
                    self.selectedAffIndex = 0
//                    self.lblcurrentText.text = self.stringFromTimeInterval(interval: currentTimeCount)
                    self.swipeCollToFirstAff()
                    
                    self.isPause = false
                    self.isPlayBtnTap = true
//                    self.player?.seek(to: .zero)
                    if let affUrlStr = URL(string: UserData.language.lowercased() == "english" ? self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affEnglish ?? "" : self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affGerman ?? "") {
                        self.addAffirmationAudio(affMusic: affUrlStr)
                    }
                    self.affPlayer?.play()
                    self.player?.play()
                    ButtonPlay.setImage(UIImage(named: "playContinue"), for: .normal)
                } else {
                    self.invalidateDelayTimer()
                    self.affPlayer?.seek(to: .zero)
                    
                    self.affTimer?.invalidate()
                    self.slider.value = 0
                    self.isLastAffPlayed = false
                    self.currentTimeCount = 0.0
                    self.selectedAffIndex = 0
                    self.lblcurrentText.text = self.stringFromTimeInterval(interval: currentTimeCount)
                    self.swipeCollToFirstAff()
                    if isLoop {
                        self.isPause = false
                        self.isPlayBtnTap = true
//                        self.player?.seek(to: .zero)
                        if let affUrlStr = URL(string: UserData.language.lowercased() == "english" ? self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affEnglish ?? "" : self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affGerman ?? "") {
                            self.addAffirmationAudio(affMusic: affUrlStr)
                        }
                        self.affPlayer?.play()
                        self.player?.play()
                        ButtonPlay.setImage(UIImage(named: "playContinue"), for: .normal)
                    } else {
                        self.player?.seek(to: .zero)
                        self.isPause = true
                        self.isPlayBtnTap = false
                        self.affPlayer?.pause()
                        self.player?.pause()
                        if let affUrlStr = URL(string: UserData.language.lowercased() == "english" ? self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affEnglish ?? "" : self.selectedAffirmationDetails?[self.selectedAffIndex].audioFiles?[self.selectedSpeakerIndex].affGerman ?? "") {
                            self.setupNextAffAudio(affMusic: affUrlStr) {
                                Indicator.shared.hide()
                            }
                        }
                        ButtonPlay.setImage(UIImage(named: "playBtn"), for: .normal)
                    }
                }
            }
        }
    }
    
    private func initializeDelayTimer() {
        delayTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(playAfterDelay), userInfo: nil, repeats: true)
        
    }
    
    private func invalidateDelayTimer() {
        delayTimer?.invalidate()
    }
    
    @objc func playAfterDelay() {
        self.isDelayInProgress = true
        delayInProgress += 1
        if delayInProgress >= affDelay {
            isDelayInProgress = false
            print("playing aff after delay")
            affPlayer?.play()
            swipeColl()
            delayInProgress = 0
            invalidateDelayTimer()
        }
    }
    
    private func setupNextAffAudio(affMusic: URL, completion: @escaping () -> ()) {
        Indicator.shared.show("")
        affPlayer = nil
        let affPlayerItem:AVPlayerItem = AVPlayerItem(url: affMusic)
        affPlayer = AVPlayer(playerItem: affPlayerItem)
        affPlayer?.volume = affVolume
        NotificationCenter.default.addObserver(self, selector: #selector(self.affFinishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: affPlayerItem)
        completion()
//        setMPMediaProperty()
    }
}

//MARK: - COLLECTION VIEW METHODS
extension AffirmationPlayVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedAffirmationDetails?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.AffPlayCollCell, for: indexPath) as! AffOTDCollCell
        cell.configureAffPlay(data: UserData.language.lowercased() == "english" ? selectedAffirmationDetails?[indexPath.item].affirmationTextEnglish ?? "" : selectedAffirmationDetails?[indexPath.item].affirmationTextGerman ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

//MARK: - CUSTOM NOTIFICATION METHODS
extension AffirmationPlayVC {
    func createNotification() {
        guard let affPlayer = affPlayer, let trackPlayer = player else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Now Playing"
        content.body = "Current track: \(selectedAffirmation?.trackTitle ?? "Unknown")"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "audioNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["audioNotification"])
    }
}



