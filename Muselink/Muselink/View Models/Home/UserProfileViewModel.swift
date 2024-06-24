//
//  UserProfileViewModel.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 11/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
class UserProfileViewModel :NSObject, ViewModel {
    var brokenRules : [BrokenRule]    = [BrokenRule]()
    var isValid     : Bool = true
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    var didFinishFetch_Like: (() -> ())?
    //API related Variable
    var error: String? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var userList = [UserProfileModel]()
    var currentIndex = 0
}
extension UserProfileViewModel {
    func fetchUsersList() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getUserlist { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(let res):
                self.userList = res.data ?? []
                AppSettings.hasSubscription = res.subscriptionStatus ?? 0 == 1 ? true : false
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
        guard let userID = userList[currentIndex].id else {
            return
        }
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.giveLikeToUser(toID: userID) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(_):
                self.userList[self.currentIndex].favoriteStaus = 1
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
}
extension UserProfileViewModel : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if userList.count == currentIndex {
            return 0
        }
        return 4
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        else if section == 1 {
            if userList[currentIndex].personalInterest?.isEmpty ?? true {
                return 0
            }
        }
        else if section == 2 {
            if userList[currentIndex].personalInterest?.isEmpty ?? true {
                return 0
            }
        }
        else if section == 3 {
            if userList[currentIndex].biography?.isEmpty ?? true {
                return 0
            }
        }
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        view.backgroundColor = .paleGray
        let label = UILabel(frame: view.bounds)
        label.textColor = .black
        label.textAlignment = .center
        label.font      = UIFont.Avenir_Medium(size: 25)
        if section == 1 {
            label.text      = "Personal Interests"
        }
        else if section == 2  {
            label.text      = "Career Goals"
        }
        else {
            label.text      = "Biography"
        }
        view.addSubview(label)
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            if userList[currentIndex].personalInterest?.isEmpty ?? true {
                return 0
            }
        }
        else if section == 2 {
            if userList[currentIndex].personalInterest?.isEmpty ?? true {
                return 0
            }
        }
        else if section == 3 {
            if userList[currentIndex].biography?.isEmpty ?? true {
                return 0
            }
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ProfileImage") as? Cell_ProfileImage else {
                return Cell_ProfileAboutMe()
            }
            let data = userList[currentIndex]
            cell.selectionStyle = .none
            cell.Img_Flag.setCellImage(image: #imageLiteral(resourceName: "flag"))
            cell.lbl_Username.text = data.userName
            cell.imgView_profile?.setImage(name: data.profileImage ?? "")
            return cell
        }
        else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Home_User_Interest") as? Cell_Home_User_Interest else {
                return Cell_Home_User_Interest()
            }
            cell.selectionStyle = .none
            cell.parentobj    = self
            cell.currentIndex = indexPath.section
            cell.loadCollection()
            return cell
        }
        else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Home_User_Goal") as? Cell_Home_User_Goal else {
                return Cell_Home_User_Goal()
            }
            cell.selectionStyle = .none
            cell.parentobj    = self
            cell.currentIndex = indexPath.section
            cell.loadCollection()
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ProfileAboutMe_Description") as? Cell_ProfileAboutMe_Description else {
                return Cell_ProfileAboutMe_Description()
            }
            cell.selectionStyle = .none
            cell.lbl_desc.text = userList[currentIndex].biography
            return cell
        }
    }
}
