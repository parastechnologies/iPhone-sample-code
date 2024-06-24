//
//  AppDelegate.swift
//  Muselink
//
//  Created by appsDev on 25/11/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FacebookCore
import Firebase
import SwiftyDropbox
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        if !AppSettings.hasShowTutorials {
            let storyBoard = UIStoryboard(name: "Tutorials", bundle: .main)
            let rootVC = storyBoard.instantiateInitialViewController()
            window?.rootViewController = rootVC
            window?.makeKeyAndVisible()
        }
        registerForPushNotifications(application: application)
        IAPManager.shared.startObserving()
        DropboxClientsManager.setupWithAppKey("9s66g1bs56nswgx")
        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        NetworkManager.sharedInstance.updateOnlieStatus(status: true) { _ in }
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        NetworkManager.sharedInstance.updateOnlieStatus(status: false) { _ in }
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let oauthCompletion: DropboxOAuthCompletion = {
              if let authResult = $0 {
                  switch authResult {
                  case .success:
                      print("Success! User is logged into DropboxClientsManager.")
                  case .cancel:
                      print("Authorization flow was manually canceled by user!")
                  case .error(_, let description):
                      print("Error: \(String(describing: description))")
                  }
              }
            }
        let canHandleUrl = DropboxClientsManager.handleRedirectURL(url, completion: oauthCompletion)
        return canHandleUrl ? true : ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    func applicationWillTerminate(_ application: UIApplication) {
        IAPManager.shared.stopObserving()
    }
} 
extension AppDelegate : UNUserNotificationCenterDelegate, MessagingDelegate{
    //MARK:- Notifications
    private func registerForPushNotifications(application:UIApplication) {
        //application.applicationIconBadgeNumber = 0
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options:[ .alert, .sound,.badge]){ (granted, error) in
            guard granted else {
                return
            }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        Messaging.messaging().delegate = self
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("refreshed token is : \(String(describing: fcmToken))")
        print("----------------------")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("====fail to register notifications=====")
        print(error.localizedDescription)
    }

    // When app is open then willPresent will call
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("----------UNUserNotificationCenter, willPresent notification--------------")
        print(notification.request.content.userInfo)
        handleNotification(userInfo: notification.request.content.userInfo)
        completionHandler([.alert, .sound, .badge])
    }
    
    // didReceive will call when click on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("----------UNUserNotificationCenter  didReceive response--------------")
        print(response.notification.request.content.userInfo)
        handleNotification(userInfo: response.notification.request.content.userInfo)
        print("-----------------------------------------------------------")
        completionHandler()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
    }
    // call when notification reached to device
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        application.applicationIconBadgeNumber += 1
        completionHandler(.newData)
    }
    private func handleNotification(userInfo:[AnyHashable:Any]) {
        if userInfo[AnyHashable("gcm.notification.type")] as? String ?? "" == "AudioMatch" {
            let userID = userInfo[AnyHashable("gcm.notification.To_Id")] as? String ?? ""
            print(userID)
            let storyboard = UIStoryboard(name: "Home", bundle: .main)
            let vc = storyboard.instantiateViewController(withIdentifier: "GotMatchUserVC") as! GotMatchUserVC
            vc.modalPresentationStyle = .fullScreen
            vc.otherUserName = userID
            vc.otherUserName = userInfo[AnyHashable("gcm.notification.To_User_Name")] as? String ?? ""
            let nav = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
        }
    }
}
extension UIApplication {
    class func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
