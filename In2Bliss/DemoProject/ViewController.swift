//  ViewController.swift
//  DemoProject
//  Created by iOS Team on 18/06/24.

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: BaseClassVC, AVAudioPlayerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblOverallDuration   : UILabel!
    @IBOutlet weak var lblcurrentText       : UILabel!
    @IBOutlet weak var playbackSlider       : UISlider!
    @IBOutlet weak var loadingView          : UIActivityIndicatorView!
    @IBOutlet weak var ButtonPlay           : UIButton!
    @IBOutlet weak var img_background       : UIImageView!
    @IBOutlet weak var btn_favourite        : UIButton!
    @IBOutlet weak var btn_loop             : UIButton!
    @IBOutlet weak var btn_forward          : UIButton!
    @IBOutlet weak var btn_backWard         : UIButton!
    
    //MARK: - Properties
    var player1:AVPlayer?
    var player:AVPlayer?
    var timeObserver:Any?
    var isLoop = false
    var status = 0
    var interval:Int64 = 0
    var isIntro = true
    var leftSecond : Float64 = 0.0
    var isAffirmationLenGreat = true
    var totalDuration = 0.0
    var totalSeconds = 0.0
    var isPause  = true
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showProgressHUD()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addMusic(music: URL(string: "https://in2bliss.com.au/storage/app/public/uploads/music/1709522256_9HVHWVfw6YfB3pO9K1niv6SxzBAvR2cHkwNd2zia.mp3")!)
        hideProgressHUD()
    }
    
    // MARK: - Remove Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Functions
    private func addMusic(music:URL) {
        let playerItem:AVPlayerItem = AVPlayerItem(url: music)
        player = AVPlayer(playerItem: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        // Add playback slider
        playbackSlider.minimumValue = 0
        
        playbackSlider.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
        
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        lblOverallDuration.text = self.stringFromTimeInterval(interval: seconds)
        
        let duration1 : CMTime = playerItem.currentTime()
        let seconds1 : Float64 = CMTimeGetSeconds(duration1)
        lblcurrentText.text = self.stringFromTimeInterval(interval: seconds1)
        
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = true
        playbackSlider.tintColor = UIColor(red: 0.93, green: 0.74, blue: 0.00, alpha: 1.00)
        setMPMediaProperty()
        timeObserver = player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player != nil{
                if self.player!.currentItem?.status == .readyToPlay {
                    let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                    self.playbackSlider.value = Float ( time );
                    self.interval =  Int64(time)
                    self.lblcurrentText.text = self.stringFromTimeInterval(interval: time)
                }
                
                let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
                if playbackLikelyToKeepUp == false{
                    self.ButtonPlay.isHidden = true
                    self.loadingView.isHidden = false
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        self.hideProgressHUD()
                        self.ButtonPlay.isHidden = false
                        self.loadingView.isHidden = true
                    }
                } else {
                    self.hideProgressHUD()
                    self.ButtonPlay.isHidden = false
                    self.loadingView.isHidden = true
                }
            }
        }
    }
    
    func setMPMediaProperty() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
        } catch {
            print("Error configuring audio session: \(error.localizedDescription)")
        }
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Play command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if player?.rate == 0{
                self.play()
            }
            return .success
        }
        
        // Pause command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if  player?.rate != 0{
                self.pause()
            }
            return .success
        }
        var nowPlayingInfo = [String: Any]()
        
        // Set the title, artist, album, and artwork (if available)
        nowPlayingInfo[MPMediaItemPropertyTitle] = ""
        nowPlayingInfo[MPMediaItemPropertyArtist] = ""
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = ""
        
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = (player?.rate == 0) ? 1.0 : 0.0
        if let image = UIImage(named: "AppIcon") { //Here I would like to add image from API
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    // MARK: - IBACTIONS
    @IBAction func loopAction(_ sender: UIButton) {
        isLoop = !isLoop
        sender.tintColor = isLoop ? UIColor.init(hexString: "#418ff6") : .white
    }
    
    @IBAction func ButtonGoToBackSec(_ sender: Any) {
        if player == nil { return }
        if totalDuration < 10.0{
            player?.pause()
            player?.seek(to: .zero)
        }else{
            let playerCurrenTime = CMTimeGetSeconds(player!.currentTime())
            var newTime = playerCurrenTime - 10.0
            if newTime < 0 { newTime = 0 }
            player?.pause()
            let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            player?.seek(to: selectedTime)
        }
        if !(self.isPause){
            player?.play()
        }
        
    }
    
    
    @IBAction func ButtonPlay(_ sender: Any) {
        if !isIntro && player == nil{
        }
        else{
            if player?.rate == 0{
                if player != nil{
                    self.isPause = false
                    self.play()
                    self.ButtonPlay.isHidden = true
                    self.loadingView.isHidden = false
                    ButtonPlay.setImage(UIImage(named: "stopMusic"), for: UIControl.State.normal)
                }
            } else {
                self.isPause = true
                self.pause()
                ButtonPlay.setImage(UIImage(named: "playMusic"), for: UIControl.State.normal)
            }
        }
    }
    
    @IBAction func ButtonForwardSec(_ sender: Any) {
        if player == nil { return }
        guard let duration  = player!.currentItem?.duration else {
            return
        }
        let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
        let newTime = playerCurrentTime + 10.0
        
        if newTime < (CMTimeGetSeconds(duration)) {
            let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            player!.seek(to: time2, toleranceBefore: .zero, toleranceAfter: .zero)
            if player1 != nil {
                player1!.seek(to: time2, toleranceBefore: .zero, toleranceAfter: .zero)
            }
        }else{
            player!.seek(to: CMTime.init(seconds:totalDuration, preferredTimescale: 1000))
            if player1 != nil {
                player1!.seek(to: CMTime.init(seconds:totalDuration, preferredTimescale: 1000))
            }
        }
        player?.pause()
        if player1 != nil {
            player1?.pause()
        }
        
        if !(self.isPause){
            player?.play()
            if player1 != nil {
                player1?.play()
            }
        }
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider) {
        let seconds: Int64 = Int64(playbackSlider.value)
        let targetTime: CMTime = CMTimeMake(value: seconds, timescale: 1)
        player?.seek(to: targetTime)
        player1?.seek(to: targetTime)
        
        if player?.rate != 0 {
            player?.play()
            player1?.play()
        }
    }
    
    @objc func finishedPlaying( _ myNotification: NSNotification) {
        status = 1
        if isLoop{
            self.player?.seek(to: CMTime.zero)
            ButtonPlay.setImage(UIImage(named: "stopMusic"), for: UIControl.State.normal)
            self.isPause = false
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                self.play()
                self.player1?.play()
                self.player?.play()
            }
            
        } else {
            self.player?.seek(to: CMTime.zero)
            if player1 != nil{
                player1?.pause()
                self.player1?.seek(to: CMTime.zero)
            }
            self.isPause = true
            ButtonPlay.setImage(UIImage(named: "playMusic"), for: UIControl.State.normal)  ///===
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
        }
    }
    
    private func play(){
        if player != nil{
            player?.play()
            if player1 != nil{
                player1?.play()
            }
        }
    }
    
    private func pause(){
        player?.pause()
        if player1 != nil{
            player1?.pause()
        }
    }
}
