//
//  ProfileTabVC.swift
//  Muselink
//
//  Created by appsDev on 04/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
import IBAnimatable
import AVKit
class Cell_ProfileAboutMe  : UITableViewCell {
    @IBOutlet weak var btn_First  : UIButton!
    @IBOutlet weak var btn_Second : UIButton!
    
}
class ProfileTabVC: BaseClassVC {
    @IBOutlet weak var img_User         : AnimatableImageView!
    @IBOutlet weak var btn_Settings     : SoftUIView!
    @IBOutlet weak var btn_Camera       : SoftUIView!
    @IBOutlet weak var btn_SoundFile    : SoftUIView!
    @IBOutlet weak var btn_AboutMe      : SoftUIView!
    @IBOutlet weak var view_ImageView   : UIView!
    @IBOutlet weak var view_BtnBack     : UIView!
    @IBOutlet weak var tbl_SoundFile    : UITableView!
    @IBOutlet weak var contraint_height : NSLayoutConstraint!
    @IBOutlet weak var view_EmptySound  : UIView!
    @IBOutlet weak var btn_UploadSound  : SoftUIView!
    private var lbl_SoundFile           : UILabel!
    private var lbl_AboutMe             : UILabel!
    private var isSoundFile = true
    
    private let maxHeaderHeight: CGFloat = 0.4*UIScreen.main.bounds.height
    private let minHeaderHeight: CGFloat = 0
    private var previousScrollOffset: CGFloat = 0
    private var previousScrollViewHeight: CGFloat = 0
    private var selectedItems = [YPMediaItem]()
    private let selectedImageV = UIImageView()
    var viewModel : ProfileViewModel! {
        didSet {
            tbl_SoundFile.dataSource = viewModel
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl_SoundFile.register(UINib(nibName: "Cell_ProfileAboutMe_Interest", bundle: .main), forCellReuseIdentifier: "Cell_ProfileAboutMe_Interest")
        tbl_SoundFile.register(UINib(nibName: "Cell_ProfileAboutMe_Goal", bundle: .main), forCellReuseIdentifier: "Cell_ProfileAboutMe_Goal")
        viewModel = ProfileViewModel()
        viewModel.didFinishRefreshProfilePhoto = {[unowned self] in
            DispatchQueue.main.async {
                if let name = self.viewModel.profileImage {
                    self.img_User.setImage(name: name)
                }
            }
        }
        viewModel.didFinishFetch = {[unowned self] in
            DispatchQueue.main.async {
                self.tbl_SoundFile.reloadData()
                if self.viewModel.audioList.isEmpty && self.isSoundFile {
                    self.view_EmptySound.isHidden = false
                }
                else {
                    self.view_EmptySound.isHidden = true
                }
            }
        }
        viewModel.didClickOnMore = { [unowned self] audioIndex in
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "AudioFileMorePopUpNav") as! UINavigationController
            if let initVC = VC.viewControllers.first as? SoundFileMorePopUp {
                initVC.selectedAudio = viewModel.audioList[audioIndex]
                initVC.audioIndex    = audioIndex
                initVC.callback_Remove = { index in
                    viewModel.removeAudio(index)
                }
                initVC.callback_CopyLink = { index in
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {[weak self] in
                        guard let self = self else {return}
                        let pasteboard = UIPasteboard.general
                        pasteboard.string = NetworkManager.recordVideoBaseURL + (viewModel.audioList[index].recordingVideo?.replacingOccurrences(of: " ", with: "%20") ?? "")
                        self.showSuccessMessages(message: "You text copied to clipboard")
                    }
                }
                initVC.callback_ShareTo = { index in
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {[weak self] in
                        guard let self = self else {return}
                        var items = [URL]()
                        if let urlStr = viewModel.audioList[index].recordingVideo?.replacingOccurrences(of: " ", with: "%20"), let url = URL(string: NetworkManager.recordVideoBaseURL + urlStr) {
                            items = [url]
                        }
                        else {
                            items = [URL(string: "https://www.muselink.app")!]
                        }
                        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                        self.tabBarController?.present(ac, animated: true)
                    }
                }
                initVC.callback_NotificationChange = { index in
                    viewModel.notificationChange(index)
                }
            }
            VC.modalPresentationStyle = .custom
            VC.transitioningDelegate = self
            tabBarController?.present(VC, animated: true, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpVM(model: viewModel)
        viewModel.screenType = .profileTab
        viewModel.fetchAudioList()
    }
    override func viewDidAppear(_ animated: Bool) {
        setUpViews()
    }
    private func setUpViews() {
        contraint_height.constant      = 0.4*UIScreen.main.bounds.height
        view_ImageView.backgroundColor = .clear
        
        btn_Settings.type = .pushButton
        btn_Settings.addTarget(self, action: #selector(action_Settings), for: .touchDown)
        btn_Settings.cornerRadius = 10
        btn_Settings.mainColor = UIColor.paleGray.cgColor
        btn_Settings.darkShadowColor = UIColor.darkShadow.cgColor
        btn_Settings.lightShadowColor = UIColor.lightShadow.cgColor
        btn_Settings.setButtonImage(image: UIImage(named: "settingsIcon")!)
        btn_Settings.borderWidth = 2
        btn_Settings.borderColor = UIColor.white.cgColor
        
        btn_Camera.type = .pushButton
        btn_Camera.addTarget(self, action: #selector(action_Camera), for: .touchDown)
        btn_Camera.cornerRadius = 10
        btn_Camera.mainColor = UIColor.paleGray.cgColor
        btn_Camera.darkShadowColor = UIColor.darkShadow.cgColor
        btn_Camera.lightShadowColor = UIColor.lightShadow.cgColor
        btn_Camera.setButtonImage(image: UIImage(named: "cameraIcon")!)
        btn_Camera.borderWidth = 2
        btn_Camera.borderColor = UIColor.white.cgColor
        
        btn_SoundFile.type = .toggleButton
        btn_SoundFile.isSelected = true
        btn_SoundFile.addTarget(self, action: #selector(action_SoundFile), for: .touchDown)
        btn_SoundFile.cornerRadius = 10
        btn_SoundFile.mainColor = UIColor.paleGray.cgColor
        btn_SoundFile.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        btn_SoundFile.lightShadowColor = UIColor.lightShadow.cgColor
        btn_SoundFile.borderWidth = 2
        btn_SoundFile.borderColor = UIColor.white.cgColor
        lbl_SoundFile = btn_SoundFile.setButtonTitle(font: UIFont.AvenirLTPRo_Demi(size: 22.upperDynamic()), title: "Sound File(s)",titleColor: .darkGray)
        
        btn_AboutMe.type = .toggleButton
        btn_AboutMe.isSelected = false
        btn_AboutMe.addTarget(self, action: #selector(action_AboutMe), for: .touchDown)
        btn_AboutMe.cornerRadius = 10
        btn_AboutMe.mainColor = UIColor.paleGray.cgColor
        btn_AboutMe.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        btn_AboutMe.lightShadowColor = UIColor.lightShadow.cgColor
        btn_AboutMe.borderWidth = 2
        btn_AboutMe.borderColor = UIColor.white.cgColor
        lbl_AboutMe = btn_AboutMe.setButtonTitle(font: UIFont.AvenirLTPRo_Demi(size: 22.upperDynamic()), title: "About Me",titleColor: .darkGray)
        
        btn_UploadSound.type = .pushButton
        btn_UploadSound.addTarget(self, action: #selector(action_UploadSound), for: .touchDown)
        btn_UploadSound.cornerRadius = ((UIScreen.main.bounds.width-40)*29)/374
        btn_UploadSound.borderColor = UIColor.paleGray.cgColor
        btn_UploadSound.borderWidth = 5
        btn_UploadSound.mainColor   = UIColor.brightPurple.cgColor
        btn_UploadSound.setButtonTitle(font: .Avenir_Medium(size: 25), title: "Upload Sound File",titleColor: .white)
        
        view_BtnBack.backgroundColor = .clear
        
        if isSoundFile {
            btn_AboutMe.isSelected = false
            btn_SoundFile.isSelected = true
        }
        else {
            btn_AboutMe.isSelected = true
            btn_SoundFile.isSelected = false
        }
    }
    @objc private func action_UploadSound() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {[unowned self] in
            self.tabBarController?.selectedIndex = 2
        }
    }
    @objc private func action_Settings() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {[unowned self] in
            self.performSegue(withIdentifier: "setting", sender: self)
        }
    }
    @objc private func action_Camera() {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.itemOverlayType = .grid
        config.shouldSaveNewPicturesToAlbum = false
        config.showsPhotoFilters = false
        config.video.compression = AVAssetExportPresetPassthrough
        config.startOnScreen = .library
        config.screens = [.library, .photo]
        config.video.libraryTimeLimit = 500.0
        config.showsCrop = .rectangle(ratio: (16/9))
        config.wordings.libraryTitle = "Photo Library"
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.maxCameraZoomFactor = 2.0
        config.library.maxNumberOfItems = 5
        config.gallery.hidesRemoveButton = false
        config.library.preselectedItems = selectedItems
        let picker = YPImagePicker(configuration: config)
        picker.imagePickerDelegate = self
        picker.didFinishPicking { [unowned picker] items, _ in
            self.selectedItems = items
            if let img = items.singlePhoto?.image {
                self.img_User.image = img
                self.viewModel.uploadProfilePic(image: img)
            }
            picker.dismiss(animated: true, completion: nil)
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {[unowned self] in
            self.present(picker, animated: true)
        }
    }
    @objc private func action_SoundFile() {
        if !isSoundFile {
            isSoundFile   = true
            btn_AboutMe.isSelected = false
        }
        viewModel.tableType = .SoundFile
        tbl_SoundFile.reloadData()
        if self.viewModel.audioList.isEmpty && self.isSoundFile {
            self.view_EmptySound.isHidden = false
        }
        else {
            self.view_EmptySound.isHidden = true
        }
    }
    @objc private func action_AboutMe() {
        if isSoundFile {
            isSoundFile   = false
            btn_SoundFile.isSelected = false
        }
        viewModel.tableType = .AboutMe
        viewModel.fetchAboutMe()
        if self.viewModel.audioList.isEmpty && self.isSoundFile {
            self.view_EmptySound.isHidden = false
        }
        else {
            self.view_EmptySound.isHidden = true
        }
    }
}
extension ProfileTabVC :UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.tableType {
        case .SoundFile:
            let storyBoard = UIStoryboard(name: "SongDetail", bundle: .main)
            let VC = storyBoard.instantiateViewController(withIdentifier: "SongDetailNavVC") as! UINavigationController
            VC.modalPresentationStyle = .custom
            VC.transitioningDelegate = self
            if let initVC = VC.viewControllers.first as? SongDetailContainerVC {
                initVC.selectedAudio = viewModel.audioList[indexPath.row]
            }
            tabBarController?.present(VC, animated: true, completion: nil)
        case .AboutMe:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.tableType {
        case .SoundFile:
            return 0
        case .AboutMe:
            return 50
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.tableType == .SoundFile {
            return UIView()
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        view.backgroundColor = .paleGray
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 300, height: 50))
        label.textColor = .black
        label.font      = UIFont.Avenir_Medium(size: 25)
        if section == 0 {
            label.text      = "Personal Interests"
        }
        else if section == 1 {
            label.text      = "Career Goals"
        }
        else {
            label.text      = "Biography"
        }
        view.addSubview(label)
        
        let editView = SoftUIView(frame: CGRect(x: UIScreen.main.bounds.width-100, y: 10, width: 80, height: 30))
        editView.addTarget(self, action: #selector(action_Edit(_:)), for: .touchDown)
        editView.type = .pushButton
        editView.tag  = section
        editView.cornerRadius = 15
        editView.borderColor = UIColor.paleGray.cgColor
        editView.borderWidth = 3
        editView.mainColor   = UIColor.waterMelon.cgColor
        editView.setButtonTitle(font: .Avenir_Medium(size: 16), title: "Edit",titleColor: .white)
        view.addSubview(editView)
        return view
    }
    @objc private func action_Edit(_ sender:SoftUIView) {
        switch sender.tag {
        case 0:
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {[unowned self] in
                let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileEditInterestVC") as! ProfileEditInterestVC
                vc.viewModel = viewModel
                navigationController?.pushViewController(vc, animated: true)
            }
            break
        case 1:
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {[unowned self] in
                let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileEditGoalVC") as! ProfileEditGoalVC
                vc.viewModel = viewModel
                navigationController?.pushViewController(vc, animated: true)
            }
            break
        case 2:
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {[unowned self] in
                let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileEditBiographyVC") as! ProfileEditBiographyVC
                vc.viewModel = viewModel
                navigationController?.pushViewController(vc, animated: true)
            }
            break
        default:
            print("Not in Index")
        }
    }
}
extension ProfileTabVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Always update the previous values
        defer {
            self.previousScrollViewHeight = scrollView.contentSize.height
            self.previousScrollOffset = scrollView.contentOffset.y
        }
        let heightDiff = scrollView.contentSize.height - self.previousScrollViewHeight
        let scrollDiff = (scrollView.contentOffset.y - self.previousScrollOffset)
        
        // If the scroll was caused by the height of the scroll view changing, we want to do nothing.
        guard heightDiff == 0 else { return }
        
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        if canAnimateHeader(scrollView) {
            // Calculate new header height
            var newHeight = self.contraint_height.constant
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, self.contraint_height.constant - abs(scrollDiff))
                // Header needs to animate
                if newHeight != self.contraint_height.constant {
                    self.contraint_height.constant = newHeight
                    self.updateHeader(isScrollDown: true)
                    self.setScrollPosition(self.previousScrollOffset)
                }
            } else if isScrollingUp {
                newHeight = min(self.maxHeaderHeight, self.contraint_height.constant + abs(scrollDiff))
                // Header needs to animate
                if newHeight != self.contraint_height.constant {
                    self.contraint_height.constant = newHeight
                    self.updateHeader(isScrollDown: false)
                    self.setScrollPosition(self.previousScrollOffset)
                }
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        if self.contraint_height.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.contraint_height.constant - minHeaderHeight
        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.contraint_height.constant = self.minHeaderHeight
            self.updateHeader(isScrollDown: false)
            self.view.layoutIfNeeded()
        })
    }
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.contraint_height.constant = self.maxHeaderHeight
            self.updateHeader(isScrollDown: true)
            self.view.layoutIfNeeded()
        })
    }
    func setScrollPosition(_ position: CGFloat) {
        self.tbl_SoundFile.contentOffset = CGPoint(x: self.tbl_SoundFile.contentOffset.x, y: position)
    }
    func updateHeader(isScrollDown:Bool) {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.contraint_height.constant - self.minHeaderHeight
        let percentage = openAmount / range
        view_ImageView.backgroundColor = .init(r: 26, g: 26, b: 26, a: 1-percentage)
        if openAmount > 130 {
            view_BtnBack.backgroundColor = fadeFromColor(fromColor: .darkBackGround, toColor: .paleGray, withPercentage: percentage)
            btn_SoundFile.mainColor = fadeFromColor(fromColor: .darkBackGround, toColor: .paleGray, withPercentage: percentage).cgColor
            btn_SoundFile.darkShadowColor = fadeFromColor(fromColor: .black, toColor: .darkShadow, withPercentage: percentage).cgColor
            btn_SoundFile.borderColor =  UIColor(white: 1, alpha: percentage).cgColor
            btn_SoundFile.lightShadowColor = fadeFromColor(fromColor: .darkGray, toColor: .lightShadow, withPercentage: percentage).cgColor
            btn_AboutMe.mainColor = fadeFromColor(fromColor: .darkBackGround, toColor: .paleGray, withPercentage: percentage).cgColor
            btn_AboutMe.darkShadowColor = fadeFromColor(fromColor: .black, toColor: .darkShadow, withPercentage: percentage).cgColor
            btn_AboutMe.borderColor = UIColor(white: 1, alpha: percentage).cgColor
            btn_AboutMe.lightShadowColor = fadeFromColor(fromColor: .darkGray, toColor: .lightShadow, withPercentage: percentage).cgColor
            lbl_AboutMe.textColor   = fadeFromColor(fromColor: .white, toColor: .darkGray, withPercentage: percentage)
            lbl_SoundFile.textColor = fadeFromColor(fromColor: .white, toColor: .darkGray, withPercentage: percentage)
        }
        else {
            view_BtnBack.backgroundColor = fadeFromColor(fromColor: .paleGray, toColor: .darkBackGround, withPercentage: 1-percentage)
            btn_SoundFile.mainColor = fadeFromColor(fromColor: .paleGray, toColor: .darkBackGround, withPercentage: 1-percentage).cgColor
            btn_SoundFile.darkShadowColor = UIColor(white: 0, alpha: 1-percentage).cgColor
            btn_SoundFile.borderColor =  UIColor(white: 0, alpha: 1-percentage).cgColor
            btn_SoundFile.lightShadowColor = fadeFromColor(fromColor: .lightShadow, toColor: .darkGray, withPercentage: 1-percentage).cgColor
            btn_AboutMe.mainColor = fadeFromColor(fromColor: .paleGray, toColor: .darkBackGround, withPercentage: 1-percentage).cgColor
            btn_AboutMe.darkShadowColor = UIColor(white: 0, alpha: 1-percentage).cgColor
            btn_AboutMe.borderColor = UIColor(white: 0, alpha: 1-percentage).cgColor
            btn_AboutMe.lightShadowColor = fadeFromColor(fromColor: .lightShadow, toColor: .darkGray, withPercentage: 1-percentage).cgColor
            lbl_AboutMe.textColor   = fadeFromColor(fromColor: .darkGray, toColor: .white, withPercentage: 1-percentage)
            lbl_SoundFile.textColor = fadeFromColor(fromColor: .darkGray, toColor: .white, withPercentage: 1-percentage)
        }
    }
}
extension ProfileTabVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
// YPImagePickerDelegate
extension ProfileTabVC: YPImagePickerDelegate {
    func noPhotos() {}
    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        return true// indexPath.row != 2
    }
}
