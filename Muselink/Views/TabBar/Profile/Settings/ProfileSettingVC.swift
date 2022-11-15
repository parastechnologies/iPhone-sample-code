//
//  ProfileSettingVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 08/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import StoreKit

class ProfileSettingVC: BaseClassVC {
    @IBOutlet weak var btn_back    : SoftUIView!
    @IBOutlet weak var view_Back_1 : SoftUIView!
    @IBOutlet weak var view_Back_2 : SoftUIView!
    @IBOutlet weak var view_Back_3 : SoftUIView!
    @IBOutlet weak var view_Back_4 : SoftUIView!
    var viewModel : SettingsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingsViewModel()
        setUpVM(model: viewModel)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchSettings()
        setUpViews()
    }
    private func setUpViews() {
        btn_back.type = .pushButton
        btn_back.addTarget(self, action: #selector(action_Back), for: .touchDown)
        btn_back.cornerRadius = 10
        btn_back.mainColor = UIColor.paleGray.cgColor
        btn_back.darkShadowColor = UIColor(white: 0, alpha: 0.20).cgColor
        btn_back.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        btn_back.borderWidth = 1
        btn_back.borderColor = UIColor.white.cgColor
        btn_back.setButtonImage(image: #imageLiteral(resourceName: "Back_black"))
        
        view_Back_1.type = .normal
        view_Back_1.cornerRadius = 10
        view_Back_1.mainColor = UIColor.paleGray.cgColor
        view_Back_1.darkShadowColor = UIColor(white: 0, alpha: 0.20).cgColor
        view_Back_1.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        view_Back_1.borderWidth = 1
        view_Back_1.borderColor = UIColor.white.cgColor
        
        view_Back_2.type = .normal
        view_Back_2.cornerRadius = 10
        view_Back_2.mainColor = UIColor.paleGray.cgColor
        view_Back_2.darkShadowColor = UIColor(white: 0, alpha: 0.20).cgColor
        view_Back_2.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        view_Back_2.borderWidth = 1
        view_Back_2.borderColor = UIColor.white.cgColor
        
        view_Back_3.type = .normal
        view_Back_3.cornerRadius = 10
        view_Back_3.mainColor = UIColor.paleGray.cgColor
        view_Back_3.darkShadowColor = UIColor(white: 0, alpha: 0.20).cgColor
        view_Back_3.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        view_Back_3.borderWidth = 1
        view_Back_3.borderColor = UIColor.white.cgColor
        
        view_Back_4.type = .normal
        view_Back_4.cornerRadius = 10
        view_Back_4.mainColor = UIColor.paleGray.cgColor
        view_Back_4.darkShadowColor = UIColor(white: 0, alpha: 0.20).cgColor
        view_Back_4.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        view_Back_4.borderWidth = 1
        view_Back_4.borderColor = UIColor.white.cgColor
    }
    @objc private func action_Account() {
        let storyBoard = UIStoryboard(name: "Registration", bundle: .main)
        let VC = storyBoard.instantiateViewController(withIdentifier: "RegistrationNavVC")
        VC.modalPresentationStyle = .custom
        VC.transitioningDelegate = self
        tabBarController?.present(VC, animated: true, completion: nil)
    }
    @IBAction func action_Buttons(_ sender:UIButton) {
        switch sender.tag {
        case 1:
            performSegue(withIdentifier: "account", sender: self)
            break
        case 2:
            performSegue(withIdentifier: "pushNotification", sender: self)
            break
        case 3:
            performSegue(withIdentifier: "support", sender: self)
            break
        case 4:
            if let VC = storyboard?.instantiateViewController(withIdentifier: "InviteFriendNav") {
                VC.modalPresentationStyle = .custom
                VC.transitioningDelegate = self
                tabBarController?.present(VC, animated: true, completion: nil)
            }
            break
        case 5:
            performSegue(withIdentifier: "termAndUse", sender: self)
            break
        case 6:
            performSegue(withIdentifier: "privacyPolicy", sender: self)
            break
        case 7:
            let storyBoard = UIStoryboard(name: "Tutorials", bundle: .main)
            let VC = storyBoard.instantiateInitialViewController() as! TutorialsScreenContainerVC
            VC.isFromSetting = true
            VC.modalPresentationStyle = .fullScreen
            tabBarController?.present(VC, animated: true, completion: nil)
            break
        case 8:
            SKStoreReviewController.requestReview()
            break
        case 9:
            if let VC = storyboard?.instantiateViewController(withIdentifier: "SettingAccountClearCachePopUp") as? SettingAccountClearCachePopUp {
                VC.modalPresentationStyle = .custom
                tabBarController?.present(VC, animated: true, completion: nil)
            }
            break
        case 10:
            let alert = UIAlertController(title: "Delete Account?", message: "Are you sure you want to delete you account?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { _ in
                //Cancel Action
            }))
            alert.addAction(UIAlertAction(title: "Yes",
                                          style: .default,
                                          handler: {(_: UIAlertAction!) in
                                            //Sign out action
                                          }))
            self.present(alert, animated: true, completion: nil)
            break
        case 11:
            let alert = UIAlertController(title: "Logout?", message: "Are you sure you want to Logout?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { _ in
                //Cancel Action
            }))
            alert.addAction(UIAlertAction(title: "Yes",
                                          style: .default,
                                          handler: {(_: UIAlertAction!) in
                NetworkManager.sharedInstance.updateOnlieStatus(status: false) { _ in }
                AppSettings.hasLogin = false
                AppSettings.userID   = 0
                AppSettings.hasSubscription = false
                AppSettings.chatUniqeNumber = ""
                AppSettings.profileImageURL = ""
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                let initialViewController  = storyboard.instantiateViewController(withIdentifier: "SelectExplorerVC")
                let nav = UINavigationController.init(rootViewController: initialViewController)
                nav.isNavigationBarHidden = true
                appDelegate.window?.rootViewController =  nil
                appDelegate.window?.rootViewController = nav
                appDelegate.window?.makeKeyAndVisible()
            }))
            self.present(alert, animated: true, completion: nil)
            break
        default:
            print("Not listed")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "account" {
            if let vc = segue.destination as? SettingAccountVC {
                vc.viewModel = viewModel
            }
        }
        else if segue.identifier == "pushNotification" {
            if let vc = segue.destination as? SettingPushNotificationVC {
                vc.viewModel = viewModel
            }
        }
    }
}
extension ProfileSettingVC: UIViewControllerTransitioningDelegate {
    // 2.
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
