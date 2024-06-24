//
//  UIViewControllerExtension.swift
//  WorkUp
//
//  Created by appsdeveloper Developer on 05/09/22.
//

import UIKit

extension UIViewController {
    
    static func topMostViewController() -> UIViewController? {
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return keyWindow?.rootViewController?.topMostViewController()
        }
        return UIApplication.shared.keyWindow?.rootViewController?.topMostViewController()
    }
    
    func topMostViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.topMostViewController()
        }
        else if let tabBarController = self as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return selectedViewController.topMostViewController()
            }
            return tabBarController.topMostViewController()
        }
        
        else if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
        
        else {
            return self
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String) -> UIViewController {
        var viewController = UIViewController()
        
        if #available(iOS 13.0, *) {
            if let destViewController : UIViewController = self.storyboard?.instantiateViewController(identifier: strIdentifier){
                viewController = destViewController
                self.navigationController?.pushViewController(destViewController, animated: false)
            }
        }
        else{
            if let destViewController : UIViewController = self.storyboard?.instantiateViewController(withIdentifier: strIdentifier) {
                viewController = destViewController
                self.navigationController?.pushViewController(destViewController, animated: false)
            }
        }
        return viewController
    }
    
    func addLabelWithMessage(message:String,frame:CGRect,view:UIView, _isCenter:Bool=false,setColor:UIColor = .white) {
        let label = UILabel()
        label.tag   = -100
        label.frame = frame
        
        label.textAlignment = .center
        label.text          = message
        view.addSubview(label)
        label.textColor = setColor
        //self.view.addSubview(label)
        //label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        if _isCenter{
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    func removeMessageLabel(){
        self.runOnMain {
            for i in self.view.subviews{
                if let lbl = i as? UILabel{
                    if i.tag == -100 || ((lbl.text?.contains("No")) != nil){
                        i.removeFromSuperview()
                    }
                }
            }
        }
        
    }
    
    func removeMessageLabelFromTalbe(table:UITableView){
        self.runOnMain {
            
            for i in table.subviews{
                if let lbl = i as? UILabel{
                    if i.tag == -100 || ((lbl.text?.contains("No")) != nil){
                        i.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    
    func removeMessageLabelFromCollection(collectionView:UICollectionView){
        self.runOnMain {
            
            for i in collectionView.subviews{
                if let lbl = i as? UILabel{
                    if i.tag == -100 || ((lbl.text?.contains("No")) != nil){
                        i.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func tabBarHideStatus(status:Bool){
        if status {
            self.tabBarController?.tabBar.isHidden        = true
            self.tabBarController?.tabBar.layer.zPosition = -1
        }else{
            self.tabBarController?.tabBar.isHidden        = false
            self.tabBarController?.tabBar.layer.zPosition = -0
        }
        
//        if let vc = self.tabBarController as? TabBarController{
//            vc.button.isHidden = status
//        }
    }
    
    func dismissAll(animated: Bool, completion: (() -> Void)? = nil) {
        
        //let keyWindow = UIApplication.shared.keyWindow?.window
        if let optionalWindow = UIApplication.shared.keyWindow?.window,  let rootViewController = optionalWindow.rootViewController, let presentedViewController = rootViewController.presentedViewController  {
            if let snapshotView = optionalWindow.snapshotView(afterScreenUpdates: false) {
                presentedViewController.view.addSubview(snapshotView)
                presentedViewController.modalTransitionStyle = .coverVertical
            }
            if !isBeingDismissed {
                rootViewController.dismiss(animated: animated, completion: completion)
            }
        }
    }
    
    func removeStatusBar(){
        for vi in self.view.subviews
        {
            if vi.tag == 7 {
                vi.removeFromSuperview()
            }
        }
    }
    
    
    public var isVisible: Bool {
           if isViewLoaded {
               return view.window != nil
           }
           return false
       }
    
    var isViewAppeared: Bool { viewIfLoaded?.isAppeared == true }


       public var isTopViewController: Bool {
           if self.navigationController != nil {
               return self.navigationController?.visibleViewController === self
           } else if self.tabBarController != nil {
               return self.tabBarController?.selectedViewController == self && self.presentedViewController == nil
           } else {
               return self.presentedViewController == nil && self.isVisible
           }
       }
    
    func openViewControllerBasedOnStoryBoard(_ strIdentifier:String, _ storyBoard:String) -> UIViewController {
        var viewController = UIViewController()
        
        let storyBoard:UIStoryboard? = UIStoryboard.init(name: storyBoard, bundle: Bundle.main)
        
        if #available(iOS 13.0, *) {
            
            if let destViewController : UIViewController = storyBoard?.instantiateViewController(identifier: strIdentifier){
                viewController = destViewController
                self.navigationController?.pushViewController(destViewController, animated: false)
            }
        }
        else{
            if let destViewController : UIViewController = storyBoard?.instantiateViewController(withIdentifier: strIdentifier) {
                viewController = destViewController
                self.navigationController?.pushViewController(destViewController, animated: false)
            }
        }
        return viewController
    }
    
    /*
     func presentViewControllerBasedOnStoryBoard(_ strIdentifier:String, _ storyBoard:String) -> UIViewController {
     var viewController = UIViewController()
     let storyBoard:UIStoryboard? = UIStoryboard.init(name: storyBoard, bundle: Bundle.main)
     if #available(iOS 13.0, *) {
     if let destViewController : UIViewController = storyBoard?.instantiateViewController(identifier: strIdentifier){
     viewController = destViewController
     viewController.modalPresentationStyle = .overFullScreen
     viewController.modalTransitionStyle = .crossDissolve
     self.present(viewController, animated: true, completion: nil)
     }
     }
     else{
     if let destViewController : UIViewController = storyBoard?.instantiateViewController(withIdentifier: strIdentifier) {
     viewController = destViewController
     viewController.modalPresentationStyle = .overFullScreen
     self.present(viewController, animated: true, completion: nil)
     }
     }
     return viewController
     }
     */
    
    func presentViewControllerBasedOnStoryBoard(_ strIdentifier:String, _ storyBoard:String) -> UIViewController {
        var viewController = UIViewController()
        let storyBoard:UIStoryboard? = UIStoryboard.init(name: storyBoard, bundle: Bundle.main)
        if #available(iOS 13.0, *) {
            if let destViewController : UIViewController = storyBoard?.instantiateViewController(identifier: strIdentifier){
                viewController = destViewController
                let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .fullScreen
                // navigationController.modalTransitionStyle = .crossDissolve
                navigationController.isNavigationBarHidden = true
                self.present(navigationController, animated: true, completion: nil)
            }
        }
        else{
            if let destViewController : UIViewController = storyBoard?.instantiateViewController(withIdentifier: strIdentifier) {
                viewController = destViewController
                let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)
                navigationController.isNavigationBarHidden = true
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }
        }
        return viewController
    }
    
    func changeStatusBar() {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            let statusbarView = UIView()
            statusbarView.tag = 7
            statusbarView.backgroundColor = UIColor.black
            view.addSubview(statusbarView)
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
        }
        else {
            let statusBar = UIApplication.shared.value(forKeyPath:
                                                        "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.black
        }
    }
    
    
    func popToVC(){
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupBackButton(){
        let backBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backPressed))
        backBtn.image = UIImage(named: "ic_backArrow")
        backBtn.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = backBtn
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationItem.hidesBackButton = true
    }
    
    func navigationBarHiddenStatus(_ status:Bool){
        self.navigationController?.setNavigationBarHidden(status, animated: false)
    }
    
    @objc func backPressed()
    {
        print("Back pressed.")
        self.popToVC()
    }
    
    
    
    func setDelay(time:Double,complete:@escaping () -> Void)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            complete()
        }
    }
    
    func runOnMain(complete:@escaping () -> Void)
    {
        DispatchQueue.main.async {
            complete()
        }
    }
    
    func insertView(frame:CGRect, view:UIView)
    {
        view.frame = frame
        self.view.addSubview(view)
    }
    
    func removeUserDefault()
    {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if (key == "deviceToken" || key == "deviceT") || (key == "pushKitVoipToken")
            {
                print("Token will be saved. Not deleted")
            }
            else
            {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    func showAlert(message:String,title:String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension UIViewController:UITextFieldDelegate
{
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
