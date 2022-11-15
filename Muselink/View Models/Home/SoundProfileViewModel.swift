//
//  SoundProfileViewModel.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 27/04/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SoundProfileViewModel :NSObject, ViewModel {
    
    enum SearchType : String {
        case All
        case location
        case userName
    }
    
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
    var didFinishSearh:(() -> ())?
    var didSelectSearchItem:((AudioModel) -> ())?
    
    //API related Variable
    var error: String? {
        didSet { self.showAlertClosure?()    }
    }
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    var audioList = [AudioModel]()
    var currentIndex = 0
    var selectedAudioDetail : AudioDescriptionData?
    var chatsArray: [CommentModel] = [CommentModel]()
    
    var searchAudioList = [AudioModel]()
    var searchHistory   : [String] {
        var arr = AppSettings.audioSearchHistory.components(separatedBy: ",")
        arr.removeFirst()
        return arr
    }
    var selectedSearchType = SearchType.All
    var dmCount   = 0
    var likeCount = 0
    func getMessagesFromServer() {
        chatsArray.removeAll()
        SocketHelper.shared.sendMessage(message:"{\"music_id\":\"\(audioList[currentIndex].audioID ?? "0")\",\"type\":\"commentList\",\"serviceType\":\"Commenting\"}", withNickname: audioList[currentIndex].audioID ?? "0")
        SocketHelper.shared.fetchedComment = {[weak self] commentRes in
            guard let self = self else {
                return
            }
            guard let res = commentRes else {
                self.didFibishFetch_Comment?()
                self.didFibishFetch_CommentAll?()
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
        SocketHelper.shared.sendMessage(message: "{\"user_id\":\"\(AppSettings.userID)\",\"music_id\":\"\(audioList[currentIndex].audioID ?? "0")\",\"comment\":\"\(text)\",\"type\":\"add_comment\",\"serviceType\":\"Commenting\"}", withNickname: "muselink_\(AppSettings.userID)")
    }
}
extension SoundProfileViewModel {
    func fetchAudioList() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getAudiolist { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(let res):
                self.audioList = (res.data ?? []).reversed()
                AppSettings.hasSubscription = res.subscriptionStatus ?? 0 == 1 ? true : false
                self.dmCount   = res.dmCount ?? 0
                DispatchQueue.main.async {
                    self.didFinishFetch?()
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
    func gaveLike() {
        guard let userID = audioList[currentIndex].userID, let audioId = audioList[currentIndex].audioID else {
            return
        }
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.giveLike(audioID: audioId, toID: userID) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(_):
                self.audioList[self.currentIndex].favoriteAudio = 1
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
        guard let audioID = audioList[currentIndex].audioID else {
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
        guard let userID = audioList[currentIndex].userID else {
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
                    self.dmCount += 1
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
    func search() {
        if searchText.value.isEmpty {
            error = "Please write something to serach"
            return
        }
        var localSearch = searchHistory
        localSearch.append(searchText.value)
        AppSettings.audioSearchHistory = localSearch.joined(separator: ",")
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.search(searchType: "Audio", type: selectedSearchType.rawValue, text: searchText.value) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(let res):
                self.searchAudioList = res.data ?? []
                self.didFinishSearh?()
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
extension SoundProfileViewModel : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchAudioList.isEmpty ? searchHistory.count : searchAudioList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchAudioList.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_SearchHistory") as? Cell_SearchHistory else {
                return Cell_SearchHistory()
            }
            cell.selectionStyle = .none
            cell.btn_Title.setTitle(searchHistory[indexPath.row], for: .normal)
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ProfileSoundFile") as? Cell_ProfileSoundFile else {
                return Cell_ProfileSoundFile()
            }
            cell.selectionStyle = .none
            let data = searchAudioList[indexPath.row]
            cell.lbl_Title.text = data.fullAudio
            cell.lbl_Desc.attributedText = data.datumDescription?.htmlText
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchAudioList.isEmpty {
            searchText.value = searchHistory[indexPath.row]
            search()
        }
        else {
            didSelectSearchItem?(searchAudioList[indexPath.row])
        }
    }
}
