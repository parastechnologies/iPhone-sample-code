//
//  SongPopUpViewModel.swift
//  Muselink
//
//  Created by iOS TL on 21/07/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import Foundation
import UIKit

class SongPopUpViewModel :NSObject, ViewModel {

    var brokenRules : [BrokenRule]    = [BrokenRule]()
    var searchText  : Dynamic<String> = Dynamic("")
    var isValid     : Bool = true
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    var didFinishFetch_Like: (() -> ())?
    var didFinishFetch_Description: (() -> ())?
    var didFibishFetch_Comment : (()->())?
    var didFibishFetch_CommentAll : (()->())?
    var didFinishSend_DM: (() -> ())?
    
    //API related Variable
    var error: String? {
        didSet { self.showAlertClosure?()    }
    }
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    var selectedAudio : AudioModel?
    var selectedAudioDetail : AudioDescriptionData?
    var chatsArray: [CommentModel] = [CommentModel]()

    func getMessagesFromServer() {
        chatsArray.removeAll()
        SocketHelper.shared.sendMessage(message:"{\"music_id\":\"\(selectedAudio?.audioID ?? "0")\",\"type\":\"commentList\",\"serviceType\":\"Commenting\"}", withNickname: selectedAudio?.audioID ?? "0")
        SocketHelper.shared.fetchedComment = {[weak self] commentRes in
            guard let self = self, let res = commentRes else {
                return
            }
            switch res {
            case .single(let data):
                self.chatsArray.append(data)
            case .array(let data):
                self.chatsArray.append(contentsOf: data)
            }
            self.didFibishFetch_Comment?()
            self.didFibishFetch_CommentAll?()
        }
    }
    func sendMessage(text:String) {
        SocketHelper.shared.sendMessage(message: "{\"user_id\":\"\(AppSettings.userID)\",\"music_id\":\"\(selectedAudio?.audioID ?? "0")\",\"comment\":\"\(text)\",\"type\":\"add_comment\",\"serviceType\":\"Commenting\"}", withNickname: "muselink_\(AppSettings.userID)")
    }
}
extension SongPopUpViewModel {
    func gaveLike() {
        guard let userID = selectedAudio?.userID, let audioId = selectedAudio?.audioID else {
            return
        }
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.giveLike(audioID: audioId, toID: userID) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(_):
                self.selectedAudio?.favoriteAudio = 1
                DispatchQueue.main.async {
                    self.didFinishFetch_Like?()
                }
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
    func fetchAudioDescriotion() {
        guard let audioID = selectedAudio?.audioID else {
            return
        }
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getAudioDescription(audioId: audioID) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(let res):
                self.selectedAudioDetail = res.data
                DispatchQueue.main.async {
                    self.didFinishFetch_Description?()
                }
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
    func sendDirectMessage(message:String) {
        guard let userID = selectedAudio?.userID else {
            error = "Please try again"
            return
        }
        if message.isEmpty {
            error = "Please write something."
            return
        }
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.sendDM(message: message, toID: userID) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.didFinishSend_DM?()
                }
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
}
