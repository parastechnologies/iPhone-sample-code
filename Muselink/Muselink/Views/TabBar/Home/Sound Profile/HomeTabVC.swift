//
//  HomeTabVC.swift
//  Muselink
//
//  Created by appsDev on 04/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
import IBAnimatable
class HomeTabVC: BaseClassVC {
    @IBOutlet weak var btn_Replay : SoftUIView!
    @IBOutlet weak var btn_Info   : SoftUIView!
    @IBOutlet weak var btn_DM     : SoftUIView!
    @IBOutlet weak var btn_Star   : SoftUIView!
    @IBOutlet weak var btn_Next   : SoftUIView!
    @IBOutlet weak var btn_Search : SoftUIView! {
        didSet {
            btn_Search.type = .pushButton
            btn_Search.addTarget(self, action: #selector(action_Search), for: .touchDown)
            btn_Search.cornerRadius = 10
            btn_Search.mainColor = UIColor.paleGray.cgColor
            btn_Search.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
            btn_Search.borderWidth = 2
            btn_Search.borderColor = UIColor.white.cgColor
            btn_Search.setButtonImage(image: #imageLiteral(resourceName: "search"))
        }
    }
    @IBOutlet weak var dot_one   : SoftUIView! {
        didSet {
            dot_one.type         = .normal
            dot_one.isSelected   = true
            dot_one.mainColor    = UIColor.paleGray.cgColor
        }
    }
    @IBOutlet weak var dot_Two   : SoftUIView! {
        didSet {
            dot_Two.type         = .normal
            dot_Two.isSelected   = true
            dot_Two.mainColor    = UIColor.paleGray.cgColor
        }
    }
    @IBOutlet weak var dot_three  : SoftUIView! {
        didSet {
            dot_three.type       = .normal
            dot_three.isSelected = true
            dot_three.mainColor  = UIColor.paleGray.cgColor
        }
    }
    private lazy var dot_selected : UIView = {
        let view = UIView(frame: CGRect(x: 5, y: 5, width: 11, height: 11))
        view.backgroundColor = UIColor.appRed
        view.layer.cornerRadius = 5.5
        view.clipsToBounds = true
        return view
    }()
    @IBOutlet weak var scrollView: AnimatableScrollView! {
        didSet{ scrollView.delegate = self }
    }
    var slides : [UIViewController] = []
    private lazy var firstSlider : HomeFirstSliderVC = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeFirstSliderVC") as! HomeFirstSliderVC
        vc.viewmodel = viewmodel
        vc.parentVC  = self
        return vc
    }()
    private lazy var secondSlider : HomeSecondSlideVC = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeSecondSlideVC") as! HomeSecondSlideVC
        vc.viewmodel = viewmodel
        vc.parentVC  = self
        return vc
    }()
    private lazy var thirdSlider : HomeThirdSlideVC = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeThirdSlideVC") as! HomeThirdSlideVC
        vc.viewmodel = viewmodel
        vc.parentVC  = self
        return vc
    }()
    private var currentPageIndex = 0 {
        didSet {
            if currentPageIndex == 0 {
                UIView.animate(withDuration: 0.5) { [unowned self] in
                    dot_one.addSubview(dot_selected)
                }
                secondSlider.stop_Player()
            }
            else if currentPageIndex == 1 {
                UIView.animate(withDuration: 0.5) { [unowned self] in
                    dot_Two.addSubview(dot_selected)
                    firstSlider.stop_Player()
                }
            }
            else if currentPageIndex == 2 {
                UIView.animate(withDuration: 0.5) { [unowned self] in
                    dot_three.addSubview(dot_selected)
                }
                secondSlider.stop_Player()
                firstSlider.stop_Player()
                thirdSlider.viewmodel.getMessagesFromServer()
                thirdSlider.resetSubViews()
            }
        }
    }
    var isButtonBusy = false
    var viewmodel : SoundProfileViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewmodel = SoundProfileViewModel()
        slides = createSlides()
        viewmodel.didFinishFetch = {[weak self] in
            guard let self = self else {return}
            self.setupSlideScrollView(slides: self.slides)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: viewmodel)
        viewmodel.fetchAudioList()
        SocketHelper.shared.establishConnection()
    }
    override func viewDidDisappear(_ animated: Bool) {
        SocketHelper.shared.closeConnection()
    }
    private func createSlides() -> [UIViewController] {
        return [firstSlider, secondSlider,thirdSlider]
    }
    override func viewDidLayoutSubviews() {
        setUpViews()
    }
    private func setUpViews() {
        //btn_Reply
        btn_Replay.type = .pushButton
        btn_Replay.addTarget(self, action: #selector(action_Replay), for: .touchDown)
        btn_Replay.cornerRadius = btn_Replay.frame.height/2
        btn_Replay.mainColor = UIColor.paleGray.cgColor
        btn_Replay.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        btn_Replay.borderWidth = 2
        btn_Replay.borderColor = UIColor.white.cgColor
        btn_Replay.setButtonImageWithPadding(image: #imageLiteral(resourceName: "rewind"),padding: 15.upperDynamic())
        
        //btn_Info
        btn_Info.type = .pushButton
        btn_Info.addTarget(self, action: #selector(action_Info), for: .touchDown)
        btn_Info.cornerRadius = btn_Info.frame.height/2
        btn_Info.mainColor = UIColor.paleGray.cgColor
        btn_Info.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        btn_Info.borderWidth = 2
        btn_Info.borderColor = UIColor.white.cgColor
        btn_Info.setButtonImageWithPadding(image: #imageLiteral(resourceName: "info_icon"),padding: 15.upperDynamic())
        
        //btn_DM
        btn_DM.type = .pushButton
        btn_DM.addTarget(self, action: #selector(action_DM), for: .touchDown)
        btn_DM.cornerRadius = btn_DM.frame.height/2
        btn_DM.mainColor = UIColor.paleGray.cgColor
        btn_DM.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        btn_DM.borderWidth = 2
        btn_DM.borderColor = UIColor.white.cgColor
        btn_DM.setButtonImage(image: #imageLiteral(resourceName: "dm-btn_blue"))
        
        //btn_Star
        btn_Star.type = .pushButton
        btn_Star.addTarget(self, action: #selector(action_Star), for: .touchDown)
        btn_Star.cornerRadius = 10
        btn_Star.mainColor = UIColor.paleGray.cgColor
        btn_Star.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        btn_Star.borderWidth = 2
        btn_Star.borderColor = UIColor.white.cgColor
        btn_Star.setButtonImageWithPadding(image: #imageLiteral(resourceName: "star_3d"),padding: 8)
        
        // btn_Next
        btn_Next.type = .pushButton
        btn_Next.addTarget(self, action: #selector(action_Next), for: .touchDown)
        btn_Next.cornerRadius = 10
        btn_Next.mainColor = UIColor.paleGray.cgColor
        btn_Next.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        btn_Next.borderWidth = 2
        btn_Next.borderColor = UIColor.white.cgColor
        btn_Next.setButtonImageWithPadding(image: #imageLiteral(resourceName: "next_3d"),padding: 8)
    }
    private func setupSlideScrollView(slides : [UIViewController]) {
        if viewmodel.audioList.count <= viewmodel.currentIndex || viewmodel.audioList.count == 0 {
            return
        }
        btn_Star.isSelected = viewmodel.audioList[viewmodel.currentIndex].favoriteAudio ?? -1 == 1
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        for i in 0 ..< slides.count {
            slides[i].view.frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(slides[i].view)
        }
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width, y: 0), animated: false)
        dot_Two.addSubview(dot_selected)
    }
    @objc private func action_Replay() {
        if AppSettings.hasLogin {
            if isButtonBusy {
                return
            }
            isButtonBusy = true
            if viewmodel.audioList.count == 0 {
                return
            }
            firstSlider.reloadView()
            secondSlider.UpdatePlayerStatus()
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.width, y: 0), animated: false)
            dot_Two.addSubview(dot_selected)
            DispatchQueue.main.asyncAfter(deadline: .now()+1) { [unowned self] in
                isButtonBusy = false
            }
        }
        else {
            let storyBoard = UIStoryboard(name: "Registration", bundle: .main)
            let VC = storyBoard.instantiateViewController(withIdentifier: "RegistrationNavVC")
            VC.modalPresentationStyle = .custom
            VC.transitioningDelegate = tabBarController
            tabBarController?.present(VC, animated: true, completion: nil)
        }
    }
    @objc private func action_Info() {
        guard let VC = storyboard?.instantiateViewController(withIdentifier: "HomeInforPopUp") as? HomeInforPopUp else {return}
        VC.modalPresentationStyle = .custom
        VC.callback_Comment = {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                guard let self = self else {return}
                if AppSettings.hasLogin {
                    self.thirdSlider.viewmodel.getMessagesFromServer()
                    self.thirdSlider.action_ViewAll()
                }
                else {
                    let storyBoard = UIStoryboard(name: "Registration", bundle: .main)
                    let VC = storyBoard.instantiateViewController(withIdentifier: "RegistrationNavVC")
                    VC.modalPresentationStyle = .custom
                    VC.transitioningDelegate = self.tabBarController
                    self.tabBarController?.present(VC, animated: true, completion: nil)
                }
            }
        }
        VC.callback_Report = {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                guard let self = self else {return}
                if AppSettings.hasLogin {
                    let storyBoard = UIStoryboard(name: "Home", bundle: .main)
                    let VC = storyBoard.instantiateViewController(withIdentifier: "ReportNavC") as! UINavigationController
                    if let initVC = VC.viewControllers.first as? ReportPopUpVC {
                        initVC.selectedAudio = self.viewmodel.audioList[self.viewmodel.currentIndex]
                    }
                    VC.modalPresentationStyle = .custom
                    VC.transitioningDelegate = self.tabBarController
                    self.tabBarController?.present(VC, animated: true, completion: nil)
                }
                else {
                    let storyBoard = UIStoryboard(name: "Registration", bundle: .main)
                    let VC = storyBoard.instantiateViewController(withIdentifier: "RegistrationNavVC")
                    VC.modalPresentationStyle = .custom
                    VC.transitioningDelegate = self.tabBarController
                    self.tabBarController?.present(VC, animated: true, completion: nil)
                }
            }
        }
        VC.callback_Share = {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                var items = [URL]()
                if let urlStr = self?.viewmodel.audioList[self?.viewmodel.currentIndex ?? 0].recordingVideo?.replacingOccurrences(of: " ", with: "%20"), let url = URL(string: NetworkManager.recordVideoBaseURL + urlStr) {
                    items = [url]
                }
                else {
                    items = [URL(string: "https://www.muselink.app")!]
                }
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self?.tabBarController?.present(ac, animated: true)
            }
        }
        tabBarController?.present(VC, animated: true, completion: nil)
    }
    @objc private func action_DM() {
        if AppSettings.hasLogin {
            if AppSettings.hasSubscription {
                if viewmodel.dmCount <= 5 {
                    let VC = storyboard?.instantiateViewController(withIdentifier: "DM_NavC") as! UINavigationController
                    VC.modalPresentationStyle = .custom
                    VC.transitioningDelegate = tabBarController
                    if let initVC = VC.viewControllers.first as? HomeDMPopUp {
                        initVC.viewModel = viewmodel
                    }
                    tabBarController?.present(VC, animated: true, completion: nil)
                }
                else {
                    showErrorMessages(message: "You've reached your daily limit.")
                }
            }
            else {
                if viewmodel.dmCount <= 1 {
                    let VC = storyboard?.instantiateViewController(withIdentifier: "DM_NavC") as! UINavigationController
                    VC.modalPresentationStyle = .custom
                    VC.transitioningDelegate = tabBarController
                    if let initVC = VC.viewControllers.first as? HomeDMPopUp {
                        initVC.viewModel = viewmodel
                    }
                    tabBarController?.present(VC, animated: true, completion: nil)
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
        else {
            let storyBoard = UIStoryboard(name: "Registration", bundle: .main)
            let VC = storyBoard.instantiateViewController(withIdentifier: "RegistrationNavVC")
            VC.modalPresentationStyle = .custom
            VC.transitioningDelegate = tabBarController
            tabBarController?.present(VC, animated: true, completion: nil)
        }
    }
    @objc private func action_Star() {
        if AppSettings.hasLogin {
            if isButtonBusy {
                return
            }
            isButtonBusy = true
            if viewmodel.audioList.count == 0 {
                return
            }
            if viewmodel.audioList[viewmodel.currentIndex].favoriteAudio ?? -1 == 0 {
                viewmodel.gaveLike()
                viewmodel.didFinishFetch_Like = { [unowned self] in
                    self.btn_Star.isSelected = true
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        self.action_Next()
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+1) { [unowned self] in
                isButtonBusy = false
            }
        }
        else {
            let storyBoard = UIStoryboard(name: "Registration", bundle: .main)
            let VC = storyBoard.instantiateViewController(withIdentifier: "RegistrationNavVC")
            VC.modalPresentationStyle = .custom
            VC.transitioningDelegate = tabBarController
            tabBarController?.present(VC, animated: true, completion: nil)
        }
    }
    @objc private func action_Next() {
        if isButtonBusy {
            return
        }
        guard AppSettings.guestNextCount <= 10 || AppSettings.hasLogin else {
            let storyBoard = UIStoryboard(name: "Registration", bundle: .main)
            let VC = storyBoard.instantiateViewController(withIdentifier: "RegistrationNavVC")
            VC.modalPresentationStyle = .custom
            VC.transitioningDelegate = tabBarController
            tabBarController?.present(VC, animated: true, completion: nil)
            return
        }
        AppSettings.guestNextCount += 1
        isButtonBusy = true
        scrollView.animate(.slide(way: .out, direction: .left))
        if viewmodel.audioList.count == 0 {
            return
        }
        if viewmodel.audioList.count == viewmodel.currentIndex+1 {
            viewmodel.currentIndex = 0
        }
        else {
            viewmodel.currentIndex += 1
        }
        secondSlider.loopCount = 0
        firstSlider.reloadView()
        secondSlider.UpdatePlayerStatus()
        viewmodel.chatsArray.removeAll()
        viewmodel.getMessagesFromServer()
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width, y: 0), animated: false)
        dot_Two.addSubview(dot_selected)
        btn_Star.isSelected = viewmodel.audioList[viewmodel.currentIndex].favoriteAudio ?? -1 == 1
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {  [unowned self] in
            scrollView.animate(.slide(way: .in, direction: .left))
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [unowned self] in
            isButtonBusy = false
        }
    }
    @objc private func action_Search() {
        if AppSettings.hasLogin {
            if AppSettings.hasSubscription {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
                    let VC = storyboard?.instantiateViewController(withIdentifier: "HomeSearchVC") as! HomeSearchVC
                    VC.modalPresentationStyle = .custom
                    VC.viewmodel = viewmodel
                    tabBarController?.present(VC, animated: false, completion: nil)
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
        else {
            let storyBoard = UIStoryboard(name: "Registration", bundle: .main)
            let VC = storyBoard.instantiateViewController(withIdentifier: "RegistrationNavVC")
            VC.modalPresentationStyle = .custom
            VC.transitioningDelegate = tabBarController
            tabBarController?.present(VC, animated: true, completion: nil)
        }
    }
}
extension HomeTabVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        if currentPageIndex != Int(pageIndex) {
            currentPageIndex = Int(pageIndex)
        }
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            slides[0].view.transform = CGAffineTransform(translationX:(0.25-percentOffset.x)/0.25, y: 0)
            slides[1].view.transform = CGAffineTransform(translationX: percentOffset.x/0.25, y: 0)
        }
        else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            slides[1].view.transform = CGAffineTransform(translationX: (0.50-percentOffset.x)/0.25, y: 0)
            slides[2].view.transform = CGAffineTransform(translationX: percentOffset.x/0.50, y: 0)
        }
        else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
            slides[2].view.transform = CGAffineTransform(translationX: (0.75-percentOffset.x)/0.25, y: 0)
        }
    }
}
