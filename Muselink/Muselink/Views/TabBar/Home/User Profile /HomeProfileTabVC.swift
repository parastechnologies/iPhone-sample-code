//
//  HomeProfileTabVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 11/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import IBAnimatable
class HomeProfileTabVC: UIViewController {
    @IBOutlet weak var tbl_Profile : AnimatableTableView!
    @IBOutlet weak var btn_Replay : SoftUIView!
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
    private var viewModel : UserProfileViewModel! {
        didSet {
            tbl_Profile.dataSource = viewModel
            tbl_Profile.delegate   = viewModel
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl_Profile.register(UINib(nibName: "Cell_Home_User_Interest", bundle: .main), forCellReuseIdentifier: "Cell_Home_User_Interest")
        tbl_Profile.register(UINib(nibName: "Cell_Home_User_Goal", bundle: .main), forCellReuseIdentifier: "Cell_Home_User_Goal")
        viewModel = UserProfileViewModel()
        viewModel.didFinishFetch = {[weak self] in
            self?.tbl_Profile.reloadData()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchUsersList()
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
    @objc private func action_Replay() {
        if AppSettings.hasLogin {
            tbl_Profile.animate(.slide(way: .out, direction: .right))
            if viewModel.currentIndex == 0 {
                viewModel.currentIndex = 0
            }
            else {
                viewModel.currentIndex -= 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {[unowned self] in
                tbl_Profile.animate(.slide(way: .in, direction: .right))
                tbl_Profile.reloadData()
                tbl_Profile.scrollsToTop = true
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
    @objc private func action_DM() {
        if AppSettings.hasLogin {
            if AppSettings.hasSubscription {
                let VC = storyboard?.instantiateViewController(withIdentifier: "DM_NavC")
                VC!.modalPresentationStyle = .custom
                VC!.transitioningDelegate = tabBarController
                tabBarController?.present(VC!, animated: true, completion: nil)
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
    @objc private func action_Star() {
        if AppSettings.hasLogin {
            if viewModel.userList[viewModel.currentIndex].favoriteStaus ?? -1 == 0 {
                viewModel.gaveLike()
                viewModel.didFinishFetch_Like = { [unowned self] in
                    self.btn_Star.isSelected = true
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
    @objc private func action_Next() {
        tbl_Profile.animate(.slide(way: .out, direction: .left))
        if viewModel.userList.count == viewModel.currentIndex+1 {
            viewModel.currentIndex = 0
        }
        else {
            viewModel.currentIndex += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {[unowned self] in
            tbl_Profile.reloadData()
            tbl_Profile.scrollsToTop = true
            tbl_Profile.animate(.slide(way: .in, direction: .left))
        }
    }
    @objc private func action_Search() {
        if AppSettings.hasLogin {
            if AppSettings.hasSubscription {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
//                    let VC = storyboard?.instantiateViewController(withIdentifier: "HomeSearchVC") as! HomeSearchVC
//                    VC.modalPresentationStyle = .custom
//                    VC.viewmodel = viewModel
//                    tabBarController?.present(VC, animated: false, completion: nil)
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
