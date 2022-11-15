//
//  UploadTabVC.swift
//  Muselink
//
//  Created by appsDev on 04/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
import IBAnimatable
import MediaPlayer
import MobileCoreServices

class UploadTabVC: BaseClassVC {
    @IBOutlet weak var img_Arrow      : AnimatableImageView!
    @IBOutlet weak var btn_Camera     : SoftUIView!{
        didSet {
            btn_Camera.type = .pushButton
            btn_Camera.addTarget(self, action: #selector(action_Camera), for: .touchDown)
            btn_Camera.cornerRadius = 10
            btn_Camera.mainColor = UIColor.paleGray.cgColor
            btn_Camera.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
            btn_Camera.borderWidth = 2
            btn_Camera.borderColor = UIColor.white.cgColor
            btn_Camera.setButtonImage(image: #imageLiteral(resourceName: "camera"))
        }
    }
    @IBOutlet weak var btn_SoundCloud : SoftUIView!{
        didSet {
            btn_SoundCloud.type = .pushButton
            btn_SoundCloud.addTarget(self, action: #selector(action_SoundCloud), for: .touchDown)
            btn_SoundCloud.cornerRadius = 10
            btn_SoundCloud.mainColor = UIColor.paleGray.cgColor
            btn_SoundCloud.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
            btn_SoundCloud.borderWidth = 2
            btn_SoundCloud.borderColor = UIColor.white.cgColor
            btn_SoundCloud.setButtonImage(image: #imageLiteral(resourceName: "soundcloud"))
        }
    }
    @IBOutlet weak var btn_Library    : SoftUIView!{
        didSet {
            btn_Library.type = .pushButton
            btn_Library.addTarget(self, action: #selector(action_Library), for: .touchDown)
            btn_Library.cornerRadius = 10
            btn_Library.mainColor = UIColor.paleGray.cgColor
            btn_Library.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
            btn_Library.borderWidth = 2
            btn_Library.borderColor = UIColor.white.cgColor
            btn_Library.setButtonImage(image: #imageLiteral(resourceName: "library"))
        }
    }
    @IBOutlet weak var btn_Navigate   : SoftUIView!{
        didSet {
            btn_Navigate.type = .pushButton
            btn_Navigate.addTarget(self, action: #selector(action_Navigate), for: .touchDown)
            btn_Navigate.cornerRadius = 10
            btn_Navigate.mainColor = UIColor.paleGray.cgColor
            btn_Navigate.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
            btn_Navigate.borderWidth = 2
            btn_Navigate.borderColor = UIColor.white.cgColor
            btn_Navigate.setButtonImage(image: #imageLiteral(resourceName: "navigation"))
        }
    }
    private var viewModel : UploadSoundViewModel!
    private var selectedMusicURL = Bundle.main.url(forResource: "music", withExtension: "mp3")
    var documentURL = { () -> URL in
        let documentURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentURL
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UploadSoundViewModel()
        setUpVM(model: viewModel)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.checkUploadCount()
        showAnimation()
    }
    private func showAnimation() {
        img_Arrow.animate(.compound(animations: [.moveBy(x: -8, y: 8),.moveBy(x: -8, y: -8),.moveBy(x: 8, y: -8),.moveBy(x: 8, y: 8)], run: .sequential),duration: 1).completion {[weak self] in
            self?.showAnimation()
        }
    }
    @objc private func action_Camera() {
        if AppSettings.hasSubscription {
            if viewModel.uploadCount < 12 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "RecorderViewController") as! RecorderViewController
                vc.delegate = self
                let nav = RecordingPopUpNavigationC(rootViewController: vc)
                nav.isNavigationBarHidden = true
                nav.modalPresentationStyle = .custom
                nav.transitioningDelegate = self
                present(nav, animated: true, completion: nil)
            }
            else {
                showErrorMessages(message: "You've reached your daily limit.")
            }
        }
        else {
            if viewModel.uploadCount < 6 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "RecorderViewController") as! RecorderViewController
                vc.delegate = self
                let nav = RecordingPopUpNavigationC(rootViewController: vc)
                nav.isNavigationBarHidden = true
                nav.modalPresentationStyle = .custom
                nav.transitioningDelegate = self
                present(nav, animated: true, completion: nil)
            }
            else {
                let storyBoard = UIStoryboard(name: "Premium", bundle: .main)
                guard let VC = storyBoard.instantiateInitialViewController() else {return}
                VC.modalPresentationStyle = .custom
                VC.transitioningDelegate = tabBarController
                tabBarController?.present(VC, animated: true, completion: nil)
            }
        }
    }
    @objc private func action_SoundCloud() {
        if AppSettings.hasSubscription {
            if viewModel.uploadCount < 12 {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
                    self.performSegue(withIdentifier: "uploadMusic", sender: self)
                }
            }
            else {
                showErrorMessages(message: "You've reached your daily limit.")
            }
        }
        else {
            if viewModel.uploadCount < 6 {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
                    self.performSegue(withIdentifier: "uploadMusic", sender: self)
                }
            }
            else {
                let storyBoard = UIStoryboard(name: "Premium", bundle: .main)
                guard let VC = storyBoard.instantiateInitialViewController() else {return}
                VC.modalPresentationStyle = .custom
                VC.transitioningDelegate = tabBarController
                tabBarController?.present(VC, animated: true, completion: nil)
            }
        }
    }
    @objc private func action_Library() {
        if AppSettings.hasSubscription {
            if viewModel.uploadCount < 12 {
                action_OpenSheet()
            }
            else {
                showErrorMessages(message: "You've reached your daily limit.")
            }
        }
        else {
            if viewModel.uploadCount < 6 {
                action_OpenSheet()
            }
            else {
                let storyBoard = UIStoryboard(name: "Premium", bundle: .main)
                guard let VC = storyBoard.instantiateInitialViewController() else {return}
                VC.modalPresentationStyle = .custom
                VC.transitioningDelegate = tabBarController
                tabBarController?.present(VC, animated: true, completion: nil)
            }
        }
    }
    private func action_OpenSheet() {
        btn_Library.isSelected = false
        let ac = UIAlertController(title: "Choose Library Type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Library", style: .default, handler: { [weak self]action in
            self?.open_Library()
        }))
        ac.addAction(UIAlertAction(title: "Documents", style: .default, handler: { [weak self]action in
            self?.open_Document()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    private func open_Document() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeAudio),String(kUTTypeMP3),String(kUTTypeMIDIAudio)], in: .import)
        //Call Delegate
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    private func open_Library() {
        let controller = MPMediaPickerController(mediaTypes: .anyAudio)
        controller.allowsPickingMultipleItems = false
        controller.popoverPresentationController?.sourceView = self.view
        controller.delegate = self
        present(controller, animated: true)
    }
    @objc private func action_Navigate() {
        if AppSettings.hasSubscription {
            if viewModel.uploadCount < 12 {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
                    self.performSegue(withIdentifier: "uploadMusic", sender: self)
                }
            }
            else {
                showErrorMessages(message: "You've reached your daily limit.")
            }
        }
        else {
            if viewModel.uploadCount < 6 {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
                    self.performSegue(withIdentifier: "uploadMusic", sender: self)
                }
            }
            else {
                let storyBoard = UIStoryboard(name: "Premium", bundle: .main)
                guard let VC = storyBoard.instantiateInitialViewController() else {return}
                VC.modalPresentationStyle = .custom
                VC.transitioningDelegate = tabBarController
                tabBarController?.present(VC, animated: true, completion: nil)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UploadMusicVC {
            vc.selectedURL = selectedMusicURL
        }
    }
}
extension UploadTabVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
extension UploadTabVC : MPMediaPickerControllerDelegate, UIDocumentPickerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController,
                     didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        // Get the system music player.
        //let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        //musicPlayer.setQueue      (with: mediaItemCollection)
        mediaPicker.dismiss(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.showProgressHUD()
            guard let item : MPMediaItem =  mediaItemCollection.items.first,let pathURL: URL = item.assetURL else {
                self.hideProgressHUD()
                self.showErrorMessages(message: "Song import fails")
                return
            }
            let songAsset = AVURLAsset(url: pathURL, options: nil)
            
            let tracks = songAsset.tracks(withMediaType: .audio)
            
            if(tracks.count > 0){
                let track = tracks[0]
                if(track.formatDescriptions.count > 0){
                    let exportSession = AVAssetExportSession(asset: AVAsset(url: pathURL), presetName: AVAssetExportPresetAppleM4A)
                    exportSession?.shouldOptimizeForNetworkUse = true
                    exportSession?.outputFileType = AVFileType.m4a ;
                    
                    var fileName = item.value(forProperty: MPMediaItemPropertyTitle) as! String
                    var fileNameArr = NSArray()
                    fileNameArr = fileName.components(separatedBy: " ") as NSArray
                    fileName = fileNameArr.componentsJoined(by: "")
                    fileName = fileName.replacingOccurrences(of: ".", with: "")
                    
                    print("fileName -> \(fileName)")
                    let outputURL = self.documentURL().appendingPathComponent("fetchedSong.m4a")
                    print("OutURL->\(outputURL)")
                    print("fileSizeString->\(item.fileSizeString)")
                    print("fileSize->\(item.fileSize)")
                    do {
                        try FileManager.default.removeItem(at: outputURL)
                    } catch let error as NSError {
                        print(error.debugDescription)
                    }
                    
                    exportSession?.outputURL = outputURL
                    exportSession?.exportAsynchronously(completionHandler: { () -> Void in
                        if exportSession!.status == AVAssetExportSession.Status.completed  {
                            DispatchQueue.main.async {
                                self.hideProgressHUD()
                                print("Export Successfull")
                                self.selectedMusicURL = outputURL
                                self.performSegue(withIdentifier: "uploadMusic", sender: self)
                            }
                        } else {
                            self.hideProgressHUD()
                            self.showErrorMessages(message: "Export failed")
                            print("Export failed")
                            print(exportSession!.error as Any)
                        }
                    })
                }
                else {
                    self.hideProgressHUD()
                    self.showErrorMessages(message: "Export failed")
                    print("Export failed")
                }
            }
            else {
                self.hideProgressHUD()
                self.showErrorMessages(message: "Export failed")
                print("Export failed")
            }
        }
    }
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // Get the system music player.
        //let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        //musicPlayer.setQueue      (with: mediaItemCollection)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.showProgressHUD()
            guard let pathURL: URL = urls.first else {
                self.hideProgressHUD()
                self.showErrorMessages(message: "Song import fails")
                return
            }
            let songAsset = AVURLAsset(url: pathURL, options: nil)
            
            let tracks = songAsset.tracks(withMediaType: .audio)
            
            if(tracks.count > 0){
                let track = tracks[0]
                if(track.formatDescriptions.count > 0){
                    let exportSession = AVAssetExportSession(asset: AVAsset(url: pathURL), presetName: AVAssetExportPresetAppleM4A)
                    exportSession?.shouldOptimizeForNetworkUse = true
                    exportSession?.outputFileType = AVFileType.m4a ;
                    
                    let outputURL = self.documentURL().appendingPathComponent("fetchedSong.m4a")
                    print("OutURL->\(outputURL)")

                    do {
                        try FileManager.default.removeItem(at: outputURL)
                    } catch let error as NSError {
                        print(error.debugDescription)
                    }
                    
                    exportSession?.outputURL = outputURL
                    exportSession?.exportAsynchronously(completionHandler: { () -> Void in
                        if exportSession!.status == AVAssetExportSession.Status.completed  {
                            DispatchQueue.main.async {
                                self.hideProgressHUD()
                                print("Export Successfull")
                                self.selectedMusicURL = outputURL
                                self.performSegue(withIdentifier: "uploadMusic", sender: self)
                            }
                        } else {
                            self.hideProgressHUD()
                            self.showErrorMessages(message: "Export failed")
                            print("Export failed")
                            print(exportSession!.error as Any)
                        }
                    })
                }
                else {
                    self.hideProgressHUD()
                    self.showErrorMessages(message: "Export failed")
                    print("Export failed")
                }
            }
            else {
                self.hideProgressHUD()
                self.showErrorMessages(message: "Export failed")
                print("Export failed")
            }
        }
    }
    
}
extension UploadTabVC: RecorderViewControllerDelegate {
    func didFinishRecording(audioURL: URL) {
        self.showProgressHUD()
        let exportSession = AVAssetExportSession(asset: AVAsset(url: audioURL), presetName: AVAssetExportPresetAppleM4A)
        exportSession?.shouldOptimizeForNetworkUse = true
        exportSession?.outputFileType = AVFileType.m4a
        
        let outputURL = self.documentURL().appendingPathComponent("recordingUpload.m4a")
        print("OutURL->\(outputURL)")
        do {
            try FileManager.default.removeItem(at: outputURL)
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        exportSession?.outputURL = outputURL
        exportSession?.exportAsynchronously(completionHandler: { () -> Void in
            DispatchQueue.main.async {
                if exportSession!.status == AVAssetExportSession.Status.completed  {
                    DispatchQueue.main.async {
                        self.hideProgressHUD()
                        print("Export Successfull")
                        self.selectedMusicURL = outputURL
                        self.performSegue(withIdentifier: "uploadMusic", sender: self)
                    }
                } else {
                    self.hideProgressHUD()
                    self.showErrorMessages(message: "Export failed")
                    print("Export failed")
                    print(exportSession!.error as Any)
                    self.selectedMusicURL = audioURL
                    self.performSegue(withIdentifier: "uploadMusic", sender: self)
                }
            }
        })
    }
    func didStartRecording() {
        
    }
}
