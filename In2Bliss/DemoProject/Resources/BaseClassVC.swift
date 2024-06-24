import Foundation
import UIKit
import IBAnimatable
import Loaf
import JGProgressHUD
import AVFoundation

class BaseClassVC: UIViewController {
    var audioPlayer: AVAudioPlayer?
    
    private lazy var progressHUD : JGProgressHUD = {
        let progressHUD = JGProgressHUD()
        progressHUD.textLabel.text = "Loading"
        progressHUD.animation = JGProgressHUDFadeZoomAnimation()
        progressHUD.interactionType = JGProgressHUDInteractionType.blockAllTouches
        return progressHUD
    }()
    
    func popUpFrame(_ popview:UIView) {
        popview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(popview)
        popview.isHidden = true
    }
    
    func setRoundViewWithBAckground (customView:UIView){
        customView.frame = self.view.frame
        customView.backgroundColor =  UIColor.black.withAlphaComponent(0.6)
        self.view.addSubview(customView)
        let maskLayer = CALayer()
        maskLayer.frame = customView.bounds
        let circleLayer = CAShapeLayer()
        circleLayer.frame = CGRect(x:0 , y:0,width: customView.frame.size.width,height: customView.frame.size.height)
        let finalPath  = UIBezierPath(roundedRect: CGRect(x:0 , y:0,width: customView.frame.size.width,height: customView.frame.size.height), cornerRadius: 0)
        let circlePath = UIBezierPath(ovalIn: CGRect(x:customView.center.x - 170, y:customView.center.y - 400, width: 250, height: 250))
        finalPath.append(circlePath.reversing())
        circleLayer.path = finalPath.cgPath
        circleLayer.borderColor = UIColor.white.withAlphaComponent(1).cgColor
        circleLayer.borderWidth = 1
        maskLayer.addSublayer(circleLayer)
        customView.layer.mask = maskLayer
        
    }
    
    func customizeTextFiled(label:UILabel,textfield:UITextField,imageName: String){
        if textfield.text == ""{
            label.textColor = UIColor.black
            textfield.textColor = UIColor.black
            textfield.layer.borderColor = UIColor.red.cgColor
        }else{
            label.textColor = UIColor.red
            textfield.textColor = UIColor.red
            textfield.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    // MARK: - IBACTIONS
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        audioPlayer?.stop()
    }
    
    @IBAction func actionDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Double) -> String {
        if seconds < 60{
            return "\(Int(seconds)) sec"
        }
        else{
            return "\(Int(seconds / 60)) mins"
        }
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        if hours == 0{
            return String(format: "%02d:%02d", minutes, seconds)
        }else{
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}
extension BaseClassVC {
    func showProgressHUD() {
        progressHUD.show(in: self.view)
    }
    
    func hideProgressHUD() {
        progressHUD.dismiss()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    
    func showInfo(message:String) {
        DispatchQueue.main.async {
            Loaf(message, state: .info, location: .bottom, presentingDirection: .left, dismissingDirection: .right ,sender: self).show()
        }
    }
}

extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}
