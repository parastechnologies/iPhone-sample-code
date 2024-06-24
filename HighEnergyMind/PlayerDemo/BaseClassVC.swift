//
//  BaseClassVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 02/03/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import AVKit
import Lottie
import CoreLocation
import Loaf

open class BaseClassVC: UIViewController{
    
    
    typealias completionHandler = (_ success:Bool) -> Void
    var completionHandlerForOk : (()->())?
    var completion : completionHandler?
    var socialSingInClicked:((String)->())?
    var isOther = false
    var isMyProfile = false

    var userOtherId = String()

    var hasNotch: Bool {
     let bottom = UIApplication.shared.windows.first{ $0.isKeyWindow }?.safeAreaInsets.bottom ?? 0
     return bottom > 0
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(handleRefresh(_:)),
                                 for: .valueChanged)
        refreshControl.tintColor = .white
        
        return refreshControl
    }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("pull to refresh called")
        completion?(true)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
               // Always adopt a light interface style.
               overrideUserInterfaceStyle = .light
           }
        let restorationIdentifier = self.restorationIdentifier
        print("Identi",restorationIdentifier)

      //  Analytics.setScreenName("Scene Name", screenClass: restorationIdentifier)
    }
    
    lazy var loadingAnimation: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "TikTokLoadingAnimation")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.animationSpeed = 1//0.8
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        return animationView
    }()
    
    
    @IBAction func action_Back() {
        self.popORDismiss()
    }
    
    @objc func playVideoWithPlayer(url:URL?){
        
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        guard let getURl = url else {return}
        let player = AVPlayer(url: getURl)
        let controller = AVPlayerViewController()
        controller.player = player
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true) {
            player.play()
        }
    }
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        if seconds > 0{
            return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        }
        else{
            return (0,0,0)
        }
    }
    
    func addPullToFresh(addToControl:UITableView){
        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x,
                                         y: -30,
                                         width: 150,
                                         height: 150)
        addToControl.refreshControl = refreshControl
    }
    
    func stopPullToRefresh(){
        refreshControl.endRefreshing()
        print("Pull to ref stopped..")
    }
    
    func createMutableString(strings: [String], fonts: [UIFont], colors: [UIColor]) -> NSMutableAttributedString {
        let mutableString = NSMutableAttributedString()
        for i in 0..<strings.count {
            let attTxt = NSAttributedString(string: strings[i], attributes: [.font: fonts[i], .foregroundColor: colors[i]])
            mutableString.append(attTxt)
        }
        return mutableString
    }
    
    func showAlertCompletion(alertText : String, alertMessage : String,completion:@escaping(() -> ())) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: {(alert) in
            completion()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addGestureOnImage(_ view:UIImageView){
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(addAction(_ :)))
        gesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(gesture)
    }
    
    func addGestureOnView(_ view:UIView){
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(addAction(_ :)))
        gesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(gesture)
    }
    
    func addBottomView(view : UIView,frame:CGRect,color:UIColor){
        let bottomView = UIView()
        bottomView.frame = frame
        bottomView.backgroundColor = color
        view.addSubview(bottomView)
    }
    
    @objc func addAction(_ sender:UIGestureRecognizer){
        let view = sender.view
        switch view?.tag {
        case 7:
          
            print("cliekced ")
            
        case 8:
          
            print("cliekced ")
            
        case 100 :
           
            
            print("cliekced ")
            
        case 102 :


            print("cliekced ")
            
        case 101:
            socialSingInClicked?("Apple")
       

        case 103:
            socialSingInClicked?("Google")
            
        case 104:
            socialSingInClicked?("Linkedin")
            
            
        case 66 : //USED FOR FOLLOWING
            
            print("cliekced ")
           
        case 77:  //USED FOR FOLLOWer
            
          print("foll")
            
        case 88: //USED FOR Gems
            
            print("gems")
            
            
        case 99: //USED FOR connections
            print("Connections")
            
          

        default:
            print("Hello")
        }
    }

    
    @IBAction func NotificationAction(_ sender : UIButton) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationListVC") as! NotificationListVC
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func action_ViewDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func getDataFormFile() -> ([CountiesWithPhoneModel],String)
    {
        var country_code = [CountiesWithPhoneModel]()
        if let jsonFile = Bundle.main.path(forResource: "CountryCodes", ofType: "json")  {
            let url = URL.init(fileURLWithPath: jsonFile)
            do{
                let data  = try Data.init(contentsOf: url)
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
                if let json = jsonData as? [[String:String]]
                {
                    for list in json{
                        let data = CountiesWithPhoneModel.init(dial_code: (list["dial_code"] ?? ""), countryName: (list["name"] ?? ""), code: (list["code"] ?? ""))
                        country_code.append(data)
                    }
                    return (country_code,"")
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        return ([],"error")
    }
    
     func handlePlayAnimation(show: Bool) {
        if show {
            
            loadingAnimation.isHidden = false
            
            loadingAnimation.play()

        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                if self.loadingAnimation.isHidden == true {
//                return
//               }
                self.loadingAnimation.pause()
                self.loadingAnimation.isHidden = true
            }
        }
    }
}

//MARK: -  LOCAITON RELATED FUNCTIONS
extension BaseClassVC{
    func convertToAddress(lat:Double,long:Double , _ completion:@escaping (_ placemrk:CLPlacemark,_ fullAddress:String)->()){
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lat)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
           // print(placemarks?.first)

            if let getPlaceMark = placemarks{
                self.getAddress(placemarks: getPlaceMark) { placemrk, fullAddress in
                    completion(placemrk, fullAddress)

                }
            }
        })
    }
    
    func getAddress(placemarks: [CLPlacemark], _ completion:@escaping (_ placemrk:CLPlacemark,_ fullAddress:String)->()) {
        guard let placemark = placemarks.first, !placemarks.isEmpty else {return}
        let outputString = [placemark.locality,
                            placemark.subLocality,
                            placemark.thoroughfare,
                            placemark.postalCode,
                            placemark.subThoroughfare,
                            placemark.country].compactMap{$0}.joined(separator: ", ")
        print(outputString)
        completion(placemark, outputString)
//        let setDeatil = GooglePlaceDetail.init(lat: self.lat, long: self.long, city: placemark.locality, country: placemark.country, localPlace: outputString)
//        self.locationDetail = setDeatil
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
    
    func showBrokenRules(message:String){
        DispatchQueue.main.async {
            //self.showAlert(message: message, title: "Alert")
            self.presentAlertWithTitle(title: "", message: message, options: "Ok") { btnIndex in
                if btnIndex == 0 {
                    self.completionHandlerForOk?()
                }
            }
        }
    }
    
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
    func showNormalMessages(message:String) {
        DispatchQueue.main.async {
            Loaf(message, state: Loaf.State.warning, location: .bottom, presentingDirection: .left, dismissingDirection: .right ,sender: self).show()
        }
    }
    func showProgressHUD() {
        loadingAnimation.play()
//        progressHUD.show(in: self.view)
    }
    func hideProgressHUD() {
        loadingAnimation.stop()
//        progressHUD.dismiss()
    }
    
//    func setViewModelObserver(model:ViewModel){
//        hideKeyboardWhenTappedAround()
//        var viewModel = model
//        viewModel.updateLoadingStatus = { [weak self] in
//            DispatchQueue.main.async {
//                let _ = viewModel.isLoading ? self?.showProgressHUD() : self?.hideProgressHUD()
//            }
//        }
//        viewModel.showAlertClosure = {  [weak self] in
//            if let error = viewModel.error {
//                print(error)
//                DispatchQueue.main.async {
//                    self?.showBrokenRules(message: error)
//                }
//            }
//        }
//    }
//
//    func showProgressHUD() {
//        self.runOnMain {
//            let progressHUD = LottieProgressHUD.shared
//            self.view.addSubview(progressHUD)
//            progressHUD.show()
//        }
//    }
//
//    func hideProgressHUD() {
//        self.runOnMain {
//            let progressHUD = LottieProgressHUD.shared
//            progressHUD.hide()
//            progressHUD.removeFromSuperview()
//        }
//    }
     
    
    func getIfAlreadyExistFile(url:String) -> URL{
        
        let sendURL = URL(string: url)
        
        let documentsUrl     =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl   =  documentsUrl.appendingPathComponent(sendURL?.lastPathComponent ?? "")

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists video path cell config [\(destinationUrl.path)]")
           // guard let getURL = URL(string: destinationUrl.absoluteString ?? "") else {return}

            return URL(string: destinationUrl.absoluteString ) ?? URL.init(string: "")!
            //self.urlStr = destinationUrl.absoluteString

        }else{
            return URL(string: url ) ?? URL.init(string: "")!

           // self.urlStr = jobDetail?.videoURL ?? ""
        }
    }
    
}

final class MyLottieTextProvider: AnimationTextProvider {
    
    let dict = [
        "look around": "Hello World",
        "the remainder of": "From",
        "day trip": "Swift Senpai",
    ]
    
    func textFor(keypathName: String, sourceText: String) -> String {
        // Return the desire text based on key path
        // If not available, use the source text instead
        return dict[keypathName] ?? sourceText
    }
}
extension BaseClassVC {
//    func setBackgroundObserver() {
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
//        
//        let notificationCenter1 = NotificationCenter.default
//        notificationCenter1.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
//    }
//    @objc func appMovedToBackground() {
//        print("App moved to background!")
//    }
//    @objc func appMovedToForeground() {
//        print("App moved to Foreground!")
//    }
    
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            if let parent = parent, !(parent is UINavigationController || parent is UITabBarController) {
                return false
            }
            return true
        } else if let navController = navigationController, navController.presentingViewController?.presentedViewController == navController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    func popORDismiss(){
        if isModal{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.popToVC()
        }
    }
}

struct CountiesWithPhoneModel {
    var dial_code :String?
    var countryName : String?
    var code :String?
}
