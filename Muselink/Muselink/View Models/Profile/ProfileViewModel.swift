

import UIKit

class ProfileViewModel :NSObject, ViewModel {
    enum ScreenType {
        case profileTab
        case editInterest
        case editGoal
        case editBiography
    }
    enum ProfileTableType {
        case SoundFile
        case AboutMe
    }
    var brokenRules : [BrokenRule]    = [BrokenRule]()
    var isValid     : Bool  {
        get {
            self.brokenRules = [BrokenRule]()
            self.Validate()
            return self.brokenRules.count == 0 ? true : false
        }
    }
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure             : (() -> ())?
    var updateLoadingStatus          : (() -> ())?
    var didFinishFetch               : (() -> ())?
    var didFinishBiographyUpdate     : (() -> ())?
    var didFinishFetch_Goal          : (() -> ())?
    var didFinishGoalUpdate          : (() -> ())?
    var didFinishFetch_Ineterest     : (() -> ())?
    var didFinishInterestUpdate      : (() -> ())?
    var didFinishUploadProfilePhoto  : (() -> ())?
    var didFinishRefreshProfilePhoto : (() -> ())?
    var didClickOnMore               : ((Int) -> ())?
    //API related Variable
    var error: String? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var tableType             = ProfileTableType.SoundFile
    var screenType            = ScreenType.profileTab
    var audioList             = [AudioModel]()
    var aboutMeData           : AboutMeModel?
    var biography             = String()
    var goalsArray            = [GoalModel]()
    var interestCategoryArray = [InsterestCategoryModel]()
    var selectedGoals         = [GoalModel]()
    var selectedInterest      = [InsterestModel]()
    var profileImage          : String? {
        didSet {
            self.didFinishRefreshProfilePhoto?()
        }
    }
    func Validate() {
        switch screenType {
        case .editInterest:
            if selectedInterest.isEmpty {
                self.brokenRules.append(BrokenRule(propertyName: "NoPersonalInterest", message: "Please select any Interest"))
                return
            }
        case .editGoal:
            if selectedGoals.isEmpty {
                self.brokenRules.append(BrokenRule(propertyName: "NoPersonalGoal", message: "Please select any Goal"))
            }
        case .editBiography:
            if biography.isEmpty {
                self.brokenRules.append(BrokenRule(propertyName: "NoBiography", message: "Please enter anything for Biography"))
            }
        case .profileTab:
            break
        }
    }
}
extension ProfileViewModel {
    func fetchAudioList() {
        let model = NetworkManager.sharedInstance
        model.getUploadedAudiolist { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(let res):
                self.audioList = res.data ?? []
                if self.profileImage ?? "0" != res.profileImage ?? "1" {
                    AppSettings.profileImageURL = res.profileImage ?? AppSettings.profileImageURL
                    self.profileImage = res.profileImage
                    DispatchQueue.main.async {
                        self.didFinishRefreshProfilePhoto?()
                    }
                }
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
    func removeAudio(_ index:Int) {
        if audioList.count <= index {
            return
        }
        let model = NetworkManager.sharedInstance
        model.removeAudio(audioID: Int(audioList[index].audioID ?? "0") ?? 0) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(_):
                self.fetchAudioList()
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
    func notificationChange(_ index:Int) {
        if audioList.count <= index {
            return
        }
        let status = audioList[index].notificationStatus ?? "0" == "1" ? true : false
        let model = NetworkManager.sharedInstance
        model.setAudioNotification(audioID: Int(audioList[index].audioID ?? "0") ?? 0, status: !status) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(_):
                self.fetchAudioList()
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
    func fetchAboutMe() {
        let model = NetworkManager.sharedInstance
        model.getAboutMe { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(let res):
                self.aboutMeData = res.data
                self.selectedGoals = res.data?.personalCareerGoal ?? []
                self.selectedInterest = res.data?.personalInterest ?? []
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
    func updateBiagraphy() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.editBiography(text: biography) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(_):
                self.aboutMeData?.biography = self.biography
                DispatchQueue.main.async {
                    self.didFinishBiographyUpdate?()
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
    func fetchGoals() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getGoals { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(let res):
                self.goalsArray = res.data ?? []
                DispatchQueue.main.async {
                    self.didFinishFetch_Goal?()
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
    func updateGoal() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.updateGoal(goals: selectedGoals) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(_):
                self.aboutMeData?.personalCareerGoal = self.selectedGoals
                DispatchQueue.main.async {
                    self.didFinishGoalUpdate?()
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
    func fetchInterest() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getInterests { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(let res):
                self.interestCategoryArray = res.data ?? []
                DispatchQueue.main.async {
                    self.didFinishFetch_Ineterest?()
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
    func updateInterest() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.updateInterest(interest: selectedInterest) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(_):
                self.aboutMeData?.personalInterest = self.selectedInterest
                DispatchQueue.main.async {
                    self.didFinishInterestUpdate?()
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
    func uploadProfilePic(image:UIImage) {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.submitProfilePic(image: image) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(_):
                self.didFinishUploadProfilePhoto?()
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
extension ProfileViewModel : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch screenType {
        case .profileTab:
            switch tableType {
            case .SoundFile:
                return 1
            case .AboutMe:
                return 3
            }
        case .editInterest:
            return 1
        case .editGoal:
            return 1
        case .editBiography:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch screenType {
        case .profileTab:
            switch tableType {
            case .SoundFile:
                return audioList.count
            case .AboutMe:
                return 1
            }
        case .editInterest:
            return interestCategoryArray.count
        case .editGoal:
            return 0
        case .editBiography:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch screenType {

        case .profileTab:
            switch tableType {
            case .SoundFile:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ProfileSoundFile") as? Cell_ProfileSoundFile else {
                    return Cell_ProfileSoundFile()
                }
                cell.selectionStyle = .none
                let data = audioList[indexPath.row]
                cell.lbl_Title.text = data.fullAudio
                cell.lbl_Desc.attributedText = data.datumDescription?.htmlText
                cell.btn_More.tag = indexPath.row
                cell.btn_More.addTarget(self, action: #selector(action_Cell_More(_:)), for: .touchUpInside)
                return cell
            case .AboutMe:
                if indexPath.section == 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ProfileAboutMe_Interest") as? Cell_ProfileAboutMe_Interest else {
                        return Cell_ProfileAboutMe_Interest()
                    }
                    cell.selectionStyle = .none
                    cell.parentobj    = self
                    cell.currentIndex = indexPath.section
                    cell.loadCollection()
                    if selectedInterest.isEmpty {
                        cell.view_Empty.isHidden = false
                    }
                    else {
                        cell.view_Empty.isHidden = true
                    }
                    return cell
                }
                else if indexPath.section == 1 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ProfileAboutMe_Goal") as? Cell_ProfileAboutMe_Goal else {
                        return Cell_ProfileAboutMe_Goal()
                    }
                    cell.selectionStyle = .none
                    cell.parentobj    = self
                    cell.currentIndex = indexPath.section
                    cell.loadCollection()
                    if selectedGoals.isEmpty {
                        cell.view_Empty.isHidden = false
                    }
                    else {
                        cell.view_Empty.isHidden = true
                    }
                    return cell
                }
                else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ProfileAboutMe_Description") as? Cell_ProfileAboutMe_Description else {
                        return Cell_ProfileAboutMe_Description()
                    }
                    cell.selectionStyle = .none
                    cell.lbl_desc.text = aboutMeData?.biography
                    if aboutMeData?.biography?.isEmpty ?? true {
                        cell.view_Empty.isHidden = false
                        cell.lbl_desc.text = "\n\n\n\n"
                    }
                    else {
                        cell.view_Empty.isHidden = true
                    }
                    return cell
                }
            }
        case .editInterest:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ProfileCategoryInterest") as? Cell_ProfileCategoryInterest else {
                return Cell_ProfileCategoryInterest()
            }
            cell.parentobj    = self
            cell.currentIndex = indexPath.row
            cell.loadCollection()
            cell.selectionStyle = .none
            return cell
                
        case .editGoal:
            return UITableViewCell()
            
        case .editBiography:
            return UITableViewCell()
        }
    }
    @objc private func action_Cell_More(_ sender:UIButton) {
        didClickOnMore?(sender.tag)
    }
}
