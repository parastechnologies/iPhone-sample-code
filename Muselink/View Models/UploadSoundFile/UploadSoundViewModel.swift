//
//  UploadSoundViewModel.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 04/03/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import AVFoundation

class UploadSoundViewModel :NSObject, ViewModel {
    var brokenRules : [BrokenRule]    = [BrokenRule]()
    var isValid     : Bool  = true
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    var didUpdateProgress: ((Double) -> ())?
    var didFinishExtract:(()->())?
    
    //API related Variable
    var error: String? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var rolesArray       = [RoleModel]()
    var selectedRoles    = [RoleModel]()
    var goalsArray       = [GoalModel]()
    var selectedGoals    = [GoalModel]()
    var dailyTips        : DailyTips?
    var descriptiontxt   = String()
    var locationArr      = [String]()
    var descripyionColor = "Black"
    var writingTimer             : Timer?
    var uploadCount      = 0
    private var ShortSoundPlayer: AVPlayer?
    var isPlayingAudio   = false {
        didSet {
            if isPlayingAudio {
                if shortAudioLink == nil {return}
                if FileManager.default.fileExists(atPath: shortAudioLink.path) {
                    ShortSoundPlayer = AVPlayer(url: shortAudioLink)
                    ShortSoundPlayer?.play()
                }
                else {
                    print("No Short Audio found")
                }
                
            }
            else {
                ShortSoundPlayer?.pause()
            }
        }
    }
    var audioLink      : URL = Bundle.main.url(forResource: "music", withExtension: "mp3")!
    var duration       : TimeInterval {
        get {
            let asset: AVAsset = AVAsset(url: audioLink)
            return CMTimeGetSeconds(asset.duration)
        }
    }
    var shortAudioLink : URL!
    var videoURL : URL!
    var lowerRange     = Double()
    var upperRange     = Double() {
        didSet {
            if writingTimer != nil {
                writingTimer?.invalidate()
                writingTimer = nil
            }
            writingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self](timer) in
                guard let self = self else {return}
                let spliter = AudioSplitter()
                spliter.processAudio(sourceFileURL: self.audioLink, startTime: self.lowerRange, endTime: self.upperRange)
                spliter.audioCroped = {
                    guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        return
                    }
                    // check if the file already exist at the destination folder if you don't want to download it twice
                    if FileManager.default.fileExists(atPath: documentsDirectoryURL.appendingPathComponent("ShortAudio.m4a").path) {
                        self.shortAudioLink = documentsDirectoryURL.appendingPathComponent("ShortAudio.m4a")
                        self.didFinishExtract?()
                    }
                }
            })
        }
    }
    var uploadAudio : AudioModel?
}
extension UploadSoundViewModel {
    func fetchRoles() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getRoles { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(let res):
                self.rolesArray = res.data ?? []
                self.dailyTips  = res.dailyTips
                self.didFinishFetch?()
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    func fetchGoals() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getGoals { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(let res):
                self.goalsArray = res.data ?? []
                self.didFinishFetch?()
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    func checkUploadCount() {
        let model = NetworkManager.sharedInstance
        model.checkForUploadingCount { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .success(let res):
                self.uploadCount = res.data ?? 0
                self.didFinishFetch?()
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    func upload() {
        do {
            let fullSoundudio    = try Data(contentsOf: audioLink)
            let shortSoundAudio  = try Data(contentsOf: shortAudioLink)
            let video            = try Data(contentsOf: videoURL)
            let model = NetworkManager.sharedInstance
            model.uploadSound(roles: selectedRoles, goals: selectedGoals, locationTags: locationArr, description: descriptiontxt, descriptionColor: descripyionColor, shortAudio: shortSoundAudio, fulludio: fullSoundudio,recVideo: video) { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result {
                case .success(let res):
                    self.uploadAudio = res.data
                    self.didFinishFetch?()
                case .failure(let err):
                    switch err {
                    case .errorReport(let desc):
                        print(desc)
                        self.error = desc
                    }
                    print(err.localizedDescription)
                }
            } uploadProgress: { [weak self](Double) in
                DispatchQueue.main.async {
                    self?.didUpdateProgress?(Double)
                }
            }
        }
        catch {
            self.error = "Unable to upload field."
            print(error.localizedDescription)
        }
    }
}
