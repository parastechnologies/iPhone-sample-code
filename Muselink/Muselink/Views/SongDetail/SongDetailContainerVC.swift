//
//  SongDetailContainerVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 25/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SongDetailContainerVC: BaseClassVC {
    @IBOutlet weak var btn_Replay : SoftUIView!
    @IBOutlet weak var btn_Info   : SoftUIView!
    @IBOutlet weak var btn_DM     : SoftUIView!
    @IBOutlet weak var dot_one   : SoftUIView! {
        didSet {
            dot_one.type = .normal
            dot_one.isSelected = true
            dot_one.mainColor = UIColor.darkBackGround.cgColor
            dot_one.darkShadowColor = UIColor.black.cgColor
            dot_one.lightShadowColor = UIColor.darkGray.cgColor
        }
    }
    @IBOutlet weak var dot_Two   : SoftUIView! {
        didSet {
            dot_Two.type      = .normal
            dot_Two.isSelected = true
            dot_Two.mainColor = UIColor.darkBackGround.cgColor
            dot_Two.darkShadowColor = UIColor.black.cgColor
            dot_Two.lightShadowColor = UIColor.darkGray.cgColor
        }
    }
    @IBOutlet weak var dot_three  : SoftUIView! {
        didSet {
            dot_three.type = .normal
            dot_three.isSelected = true
            dot_three.mainColor = UIColor.darkBackGround.cgColor
            dot_three.darkShadowColor = UIColor.black.cgColor
            dot_three.lightShadowColor = UIColor.darkGray.cgColor
        }
    }
    private lazy var dot_selected : UIView = {
        let view = UIView(frame: CGRect(x: 5, y: 5, width: 11, height: 11))
        view.backgroundColor = UIColor.appRed
        view.layer.cornerRadius = 5.5
        view.clipsToBounds = true
        return view
    }()
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    var slides:[UIViewController] = [];
    private lazy var firstSlider : SongDetailSoundFileVC = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SongDetailSoundFileVC")         as! SongDetailSoundFileVC
        vc.viewmodel = viewmodel
        vc.parentVC  = self
        return vc
    }()
    private lazy var secondSlider : SongDetailSoundWithProgressVC = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SongDetailSoundWithProgressVC") as! SongDetailSoundWithProgressVC
        vc.viewmodel = viewmodel
        vc.parentVC  = self
        return vc
    }()
    private lazy var thirdSlider : SongDetailCommentVC = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SongDetailCommentVC")           as! SongDetailCommentVC
        vc.viewmodel = viewmodel
        vc.parentVC  = self
        return vc
    }()
    private var currentPageIndex    = 0 {
        didSet {
            if currentPageIndex == 0 {
                UIView.animate(withDuration: 0.5) {[unowned self] in
                    dot_one.addSubview(dot_selected)
                }
                secondSlider.stop_Player()
            }
            else if currentPageIndex == 1 {
                UIView.animate(withDuration: 0.5) {[unowned self] in
                    dot_Two.addSubview(dot_selected)
                }
                firstSlider.stop_Player()
            }
            else if currentPageIndex == 2 {
                UIView.animate(withDuration: 0.5) {[unowned self] in
                    dot_three.addSubview(dot_selected)
                }
                secondSlider.stop_Player()
                firstSlider.stop_Player()
                thirdSlider.viewmodel.getMessagesFromServer()
            }
        }
    }
    private var viewmodel : SongPopUpViewModel! {
        didSet{
            viewmodel.selectedAudio = selectedAudio
        }
    }
    var selectedAudio :AudioModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewmodel = SongPopUpViewModel()
        setUpVM(model: viewmodel)
        slides = createSlides()
        viewmodel.didFinishFetch = {[weak self] in
            guard let self = self else {return}
            self.setupSlideScrollView(slides: self.slides)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: viewmodel)
        SocketHelper.shared.establishConnection()
    }
    override func viewWillDisappear(_ animated: Bool) {
        SocketHelper.shared.closeConnection()
        secondSlider.stop_Player()
        firstSlider.stop_Player()
    }
    private func createSlides() -> [UIViewController] {
        return [firstSlider, secondSlider,thirdSlider]
    }
    override func viewDidLayoutSubviews() {
        setUpViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSlideScrollView(slides: slides)
    }
    private func setUpViews() {
        //btn_Reply
        btn_Replay.type = .pushButton
        btn_Replay.addTarget(self, action: #selector(action_Star), for: .touchDown)
        btn_Replay.cornerRadius = btn_Replay.frame.height/2
        btn_Replay.mainColor = UIColor.darkBackGround.cgColor
        btn_Replay.darkShadowColor  = UIColor.black.cgColor
        btn_Replay.lightShadowColor = UIColor.semiDarkBackGround.cgColor
        btn_Replay.borderWidth = 2
        btn_Replay.borderColor = UIColor.black.cgColor
        btn_Replay.setButtonImageWithPadding(image: #imageLiteral(resourceName: "star_icon"),padding: 5.upperDynamic())
        btn_Replay.isSelected = viewmodel.selectedAudio?.favoriteAudio ?? -1 != 0
        
        //btn_Info
        btn_Info.type = .pushButton
        btn_Info.addTarget(self, action: #selector(action_Info), for: .touchDown)
        btn_Info.cornerRadius = btn_Info.frame.height/2
        btn_Info.mainColor = UIColor.darkBackGround.cgColor
        btn_Info.darkShadowColor = UIColor.black.cgColor
        btn_Info.lightShadowColor = UIColor.semiDarkBackGround.cgColor
        btn_Info.borderWidth = 2
        btn_Info.borderColor = UIColor.black.cgColor
        btn_Info.setButtonImageWithPadding(image: #imageLiteral(resourceName: "info"),padding: 10.upperDynamic())
        
        //btn_DM
        btn_DM.type = .pushButton
        btn_DM.addTarget(self, action: #selector(action_DM), for: .touchDown)
        btn_DM.cornerRadius = btn_DM.frame.height/2
        btn_DM.mainColor = UIColor.darkBackGround.cgColor
        btn_DM.darkShadowColor = UIColor.black.cgColor
        btn_DM.lightShadowColor = UIColor.semiDarkBackGround.cgColor
        btn_DM.borderWidth = 2
        btn_DM.borderColor = UIColor.black.cgColor
        btn_DM.setButtonImage(image: #imageLiteral(resourceName: "DM-Btn-Blue"))
    }
    private func setupSlideScrollView(slides : [UIViewController]) {
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].view.frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(slides[i].view)
        }
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width, y: 0), animated: false)
        dot_Two.addSubview(dot_selected)
    }
    @objc private func action_Info() {
        let storyBoard = UIStoryboard(name: "Home", bundle: .main)
        guard let VC = storyBoard.instantiateViewController(withIdentifier: "HomeInforPopUp") as? HomeInforPopUp else {return}
        VC.modalPresentationStyle = .custom
        VC.callback_Comment = {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                guard let self = self else {return}
                self.thirdSlider.viewmodel.getMessagesFromServer()
                self.thirdSlider.action_ViewAll()
            }
        }
        VC.callback_Report = {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                guard let self = self else {return}
                let storyBoard = UIStoryboard(name: "Home", bundle: .main)
                let VC = storyBoard.instantiateViewController(withIdentifier: "ReportNavC") as! UINavigationController
                if let initVC = VC.viewControllers.first as? ReportPopUpVC {
                    initVC.selectedAudio = self.viewmodel.selectedAudio
                }
                VC.modalPresentationStyle = .custom
                VC.transitioningDelegate = self.tabBarController
                self.present(VC, animated: true, completion: nil)
            }
        }
        VC.callback_Share = {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                var items = [URL]()
                if let urlStr = self?.viewmodel.selectedAudio?.recordingVideo?.replacingOccurrences(of: " ", with: "%20"), let url = URL(string: NetworkManager.recordVideoBaseURL + urlStr) {
                    items = [url]
                }
                else {
                    items = [URL(string: "https://www.muselink.app")!]
                }
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self?.present(ac, animated: true)
            }
        }
        
        
        present(VC, animated: true, completion: nil)
    }
    @objc private func action_DM() {
        if AppSettings.hasSubscription {
            let storyBoard = UIStoryboard(name: "Home", bundle: .main)
            let VC = storyBoard.instantiateViewController(withIdentifier: "DM_NavC") as! UINavigationController
            VC.modalPresentationStyle = .custom
            VC.transitioningDelegate = self
//                if let initVC = VC.viewControllers.first as? HomeDMPopUp {
//                    initVC.viewModel = viewmodel
//                }
            present(VC, animated: true, completion: nil)
        }
        else {
            let storyBoard = UIStoryboard(name: "Premium", bundle: .main)
            guard let VC = storyBoard.instantiateInitialViewController() else {return}
            VC.modalPresentationStyle = .custom
            VC.transitioningDelegate = self
            present(VC, animated: true, completion: nil)
        }
    }
    @objc private func action_Star() {
        if viewmodel.selectedAudio?.favoriteAudio ?? -1 == 0 {
            viewmodel.gaveLike()
            viewmodel.didFinishFetch_Like = { [unowned self] in
                self.btn_Replay.isSelected = true
            }
        }
    }
    @IBAction func action_Close() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
extension SongDetailContainerVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        currentPageIndex = Int(pageIndex)
        //pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        /*
         * below code changes the background color of view on paging the scrollview
         */
//        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        /*
         * below code scales the imageview on paging the scrollview
         */
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
extension SongDetailContainerVC: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
    
