//
//  BaseClassVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 02/03/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import Loaf
import JGProgressHUD
class BaseClassVC: UIViewController {
    private lazy var progressHUD : JGProgressHUD = {
        let progressHUD = JGProgressHUD()
        progressHUD.textLabel.text = "Loading"
        progressHUD.animation = JGProgressHUDFadeZoomAnimation()
        progressHUD.interactionType = JGProgressHUDInteractionType.blockAllTouches
        return progressHUD
    }()
    @objc func action_Back() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { [unowned self] in
            navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func action_Dismiss() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
extension BaseClassVC {
    func setUpVM(model:ViewModel){
        hideKeyboardWhenTappedAround()
        var viewModel = model
        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let _ = viewModel.isLoading ? self?.showProgressHUD() : self?.hideProgressHUD()
            }
        }
        viewModel.showAlertClosure = {  [weak self] in
            if let error = viewModel.error {
                print(error)
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    Loaf(error, state: .error, location: .bottom, presentingDirection: .left, dismissingDirection: .right ,sender: self).show()
                }
            }
        }
    }
    func showErrorMessages(message:String) {
        DispatchQueue.main.async {
            Loaf(message, state: .error, location: .bottom, presentingDirection: .left, dismissingDirection: .right ,sender: self).show()
        }
    }
    func showSuccessMessages(message:String) {
        DispatchQueue.main.async {
            Loaf(message, state: .success, location: .bottom, presentingDirection: .left, dismissingDirection: .right ,sender: self).show()
        }
    }
    func showProgressHUD() {
        progressHUD.show(in: self.view)
    }
    func hideProgressHUD() {
        progressHUD.dismiss()
    }
}
extension BaseClassVC {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension BaseClassVC {
    func setBackgroundObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        let notificationCenter1 = NotificationCenter.default
        notificationCenter1.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    @objc func appMovedToBackground() {
        print("App moved to background!")
    }
    @objc func appMovedToForeground() {
        print("App moved to Foreground!")
    }
}
