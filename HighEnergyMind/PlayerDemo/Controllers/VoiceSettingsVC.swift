//
//  VoiceSettingsVC.swift
//  HighEnergyMind
//
//  Created by iOS TL on 11/03/24.
//

import UIKit
import IBAnimatable

class VoiceSettingsVC: UIViewController {

    @IBOutlet weak var speakerColl          : UICollectionView!
    @IBOutlet weak var upperBtn             : UIButton!
    @IBOutlet weak var lowerBtn             : UIButton!
    @IBOutlet weak var spokenBgView         : AnimatableView!
    @IBOutlet weak var silentBgView         : UIView!
    @IBOutlet var bgView                    : UIView!
    @IBOutlet weak var affDelayLbl          : UILabel!
    @IBOutlet weak var affLengthLbl         : UILabel!
    @IBOutlet weak var musicLengthLbl       : UILabel!
    
    var affDelay                : Int = 5
    var didFinishSettingData    : ((Bool, Int, Int, Int, Int) -> ())? // -> isSilentAff, selectedSpeakerIndex, affDelay, affLength, musicLength
    var audioFiles              = [AudioFile]()
    var selectedSpeaderIndex    : Int = 0
    var isSilentAff             = false
    var affLength               : Int = 0
    var musicLength             : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speakerColl.register(UINib(nibName: CellIdentifiers.SpeakerCollCell, bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.SpeakerCollCell)
//        lowerBtn.setImage(UIImage(named: UserData.isSilentAff ? "blackBtnImage" : "circleBtn"), for: .normal)
//        upperBtn.setImage(UIImage(named: UserData.isSilentAff ? "circleBtn" : "blackBtnImage"), for: .normal)
        self.isSilentAff = UserData.isSilentAff
//        self.speakerColl.alpha = 0.7
//        self.speakerColl.isUserInteractionEnabled = false
//        self.speakerColl.reloadData()
        
        setupActionBlocks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Operations.shared.fadeInBg(bgView: bgView)
        setupUIAccToBtnSelected()
        setupUIAccToTrackSettings()
    }
    
    func updateTimeLabel(lbl: UILabel, length: Int) {
        // Convert length from seconds to minutes and seconds
        let seconds = length % 60
        let minutes = (length / 60)
        
        // Format and set the label text
        lbl.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    func setupUIAccToTrackSettings() {
        affDelayLbl.text = "\(affDelay)s"
        updateTimeLabel(lbl: affLengthLbl, length: affLength)
        updateTimeLabel(lbl: musicLengthLbl, length: musicLength)
    }
    
    func setupActionBlocks() {
        spokenBgView.actionBlock {
            self.isSilentAff = false
            self.upperBtn.setImage(UIImage(named: "blackBtnImage"), for: .normal)
            self.lowerBtn.setImage(UIImage(named: "circleBtn"), for: .normal)
            self.selectedSpeaderIndex = 0
            self.speakerColl.alpha = 1
            self.speakerColl.isUserInteractionEnabled = true
            self.speakerColl.reloadData()
        }
        
        silentBgView.actionBlock {
            self.isSilentAff = true
            self.lowerBtn.setImage(UIImage(named: "blackBtnImage"), for: .normal)
            self.upperBtn.setImage(UIImage(named: "circleBtn"), for: .normal)
            self.selectedSpeaderIndex = 0
            self.speakerColl.alpha = 0.7
            self.speakerColl.isUserInteractionEnabled = false
            self.speakerColl.reloadData()
        }
    }
    
    func setupUIAccToBtnSelected() {
        self.upperBtn.setImage(UIImage(named: isSilentAff ? "circleBtn" : "blackBtnImage"), for: .normal)
        self.lowerBtn.setImage(UIImage(named: isSilentAff ? "blackBtnImage" : "circleBtn"), for: .normal)
        
        if isSilentAff {
            self.selectedSpeaderIndex = 0
            self.speakerColl.alpha = 0.7
            self.speakerColl.isUserInteractionEnabled = false
            self.speakerColl.reloadData()
        } else {
            self.speakerColl.alpha = 1
            self.speakerColl.isUserInteractionEnabled = true
            self.speakerColl.reloadData()
        }
    }
    
    @IBAction func upperBtnTap(_ sender: UIButton) {
        sender.setImage(UIImage(named: "blackBtnImage"), for: .normal)
        lowerBtn.setImage(UIImage(named: "circleBtn"), for: .normal)
//        speakerColl.deselectItem(at: selectedIndex , animated: true)
        selectedSpeaderIndex = 0
        speakerColl.alpha = 0.7
        speakerColl.isUserInteractionEnabled = false
        speakerColl.reloadData()
    }
    @IBAction func lowerBtnTap(_ sender: UIButton) {
        sender.setImage(UIImage(named: "blackBtnImage"), for: .normal)
        upperBtn.setImage(UIImage(named: "circleBtn"), for: .normal)
        selectedSpeaderIndex = 0
        speakerColl.alpha = 1
        speakerColl.isUserInteractionEnabled = true
        speakerColl.reloadData()
    }
    @IBAction func bgTa(_ sender: UIButton) {
        Operations.shared.fadeOutBg(bgView: bgView, parentVC: self) {}
    }
    @IBAction func crossTap(_ sender: UIButton) {
        Operations.shared.fadeOutBg(bgView: bgView, parentVC: self) {}
    }
    @IBAction func saveTap(_ sender: UIButton) {
        Operations.shared.fadeOutBg(bgView: bgView, parentVC: self) {
            self.didFinishSettingData?(self.isSilentAff, self.isSilentAff ? self.audioFiles.count - 1 : self.selectedSpeaderIndex, self.affDelay, self.affLength, self.musicLength)
        }
    }
    @IBAction func affDelayMinus(_ sender: UIButton) {
        if affDelay != 1 {
            affDelay -= 1
        }
        affDelayLbl.text = "\(affDelay)s"
    }
    @IBAction func affDelayPlus(_ sender: UIButton) {
        if affDelay != 15 {
            affDelay += 1
        }
        affDelayLbl.text = "\(affDelay)s"
    }
    
    @IBAction func affLengthPlusTap(_ sender: UIButton) {
        affLength += 300
        updateTimeLabel(lbl: affLengthLbl, length: affLength)
    }
    
    @IBAction func affLengthMinusTap(_ sender: UIButton) {
        if affLength != 0 {
            affLength -= 300
            updateTimeLabel(lbl: affLengthLbl, length: affLength)
        }
    }
    
    @IBAction func musicLengthPlusTap(_ sender: UIButton) {
        musicLength += 300
        updateTimeLabel(lbl: musicLengthLbl, length: musicLength)
    }
    
    @IBAction func musicLengthMinusTap(_ sender: UIButton) {
        if musicLength != 0 {
            musicLength -= 300
            updateTimeLabel(lbl: musicLengthLbl, length: musicLength)
        }
    }
    
    func stringToDate(_ dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }
    
//    func updateTimeLabel(with date: Date = Date(), lbl: UILabel) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "h:mm a"
//        
//        // Format the date
//        let formattedDate = dateFormatter.string(from: date)
//        
//        // Update the label text
//        lbl.text = formattedDate.lowercased()
//    }
}

extension VoiceSettingsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if audioFiles.count > 1 {
            return audioFiles.count - 1
        } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.SpeakerCollCell, for: indexPath) as! SpeakerCollCell
        cell.configure(data: audioFiles[indexPath.row])
        
        if indexPath.row == selectedSpeaderIndex {
            cell.speakerImg.layer.borderColor = UIColor.black.cgColor
            cell.speakerImg.layer.borderWidth = 2
            cell.speakerName.textColor = AppColor.app053343
            cell.speakerName.font = AppFont.BrandonTextBold_14
        } else {
            cell.speakerImg.layer.borderColor = .none
            cell.speakerImg.layer.borderWidth = 0
            cell.speakerName.textColor = AppColor.app053343
            cell.speakerName.font = AppFont.BrandonTextRegular_14
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSpeaderIndex = indexPath.row
        collectionView.reloadData()
    }
}
