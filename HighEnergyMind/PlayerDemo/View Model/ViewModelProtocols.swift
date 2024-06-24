//
//  ViewModelProtocols.swift
//  Roffers
//
//  Created by Apps on 10/08/21.
//

import UIKit
import Foundation
import IBAnimatable

struct BrokenRule {
    var propertyName :String
    var message :String
}

enum TxtFldIdentifier {
    case email
    case password
    case search
}

enum OtpTxtFldIdentifier {
    case first
    case second
    case third
    case fourth
}

/// the below protocols Manage alert and loader and validations

protocol ViewModel {
    var brokenRules :[BrokenRule] { get set}
    var isValid :Bool { mutating get }
    var showAlertClosure: (() -> ())? { get set }
    var updateLoadingStatus: (() -> ())? { get set }
    //var didFinishFetch: ((ApiType) -> ())? { get set }
    var error: String? { get set }
    var isLoading: Bool { get set }
}

/// Mark: Creating Generic datatype for accepting dynamic data

class Dynamic<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    var value: T {
        didSet {
            listener?(value)
        }
    }
    init(_ v: T) {
        value = v
    }
}

// MARK:- Creating Binding UI for the UITextField
@IBDesignable
class BindingTextField : AnimatableTextField {
    var indexPath     : IndexPath = IndexPath(row: 0, section: 0)
    var textChanged   :(String) -> () = { _ in }
    var imageView     = UIImageView(image: UIImage(named: "Close"))
    var parentVCEnum  : ViewControllers?
    let label         = UILabel()
    
    func bind(callback :@escaping (String) -> ()) {
        self.textChanged = callback
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField :UITextField) {
        print(textField.text!)
        self.textChanged(textField.text!)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        do {
            if textField.text! == "" && string == " "
            {
                return false
            }
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                return false
                
            } else {
                return true
            }
        }
        catch {
            return false
        }
        return true
    }
}

class CustomImageView : UIImageView {
    var navigationController: UINavigationController?
}

extension BindingTextField {
    func changeResponders(textFieldIdentifier: OtpTxtFldIdentifier, textField: BindingTextField?) {
        switch textFieldIdentifier {
        case .first:
            textField?.becomeFirstResponder()
        case .second:
            textField?.becomeFirstResponder()
        case .third:
            textField?.becomeFirstResponder()
        default:
            textField?.resignFirstResponder()
        }
    }
    
//    func changeTextFieldUI(textFieldIdentifier: OtpTxtFldIdentifier, makeWhite: Bool) {
//        if makeWhite {
//            self.borderColor = AppColor.app075E54
//            self.borderWidth = 2
//        } else {
//            self.borderColor = AppColor.appD0D5DD
//            self.borderWidth = 2
//        }
//    }
}

extension BindingTextField {
    func setRightSideEyeImg(leftPadding: CGFloat, rightPadding: CGFloat, textFieldIdentifier: TxtFldIdentifier) {
        // If not set, use 0 as default value
        var leftPaddingValue: CGFloat = 0.0
        if !leftPadding.isNaN {
            leftPaddingValue = leftPadding
        }
        
        // If not set, use 0 as default value
        var rightPaddingValue: CGFloat = 0.0
        if !rightPadding.isNaN {
            rightPaddingValue = rightPadding
        }
        
        let gesture = UITapGestureRecognizer()
        if textFieldIdentifier == .password {
            imageView.image = UIImage(named: "hide")
            imageView.frame = CGRect(x: 0, y: (self.bounds.height - imageView.bounds.height) / 2, width: UIImageView(image: UIImage(named: "hide")).bounds.width, height: imageView.bounds.height)
            gesture.addTarget(self, action: #selector(changeEyeImg(_:)))
        } else if textFieldIdentifier == .email {
            imageView.image = UIImage(named: "close-icon")
            imageView.frame = CGRect(x: 0, y: (self.bounds.height - imageView.bounds.height) / 2, width: UIImageView(image: UIImage(named: "close-icon")).bounds.width, height: imageView.bounds.height)
            gesture.addTarget(self, action: #selector(crossBtnTap(_:)))
        } else {
            imageView.frame = CGRect(x: 0, y: (self.bounds.height - imageView.bounds.height) / 2, width: imageView.bounds.width, height: imageView.bounds.height)
            gesture.addTarget(self, action: #selector(crossBtnTap(_:)))
        }
        
        gesture.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
        
        imageView.contentMode = .scaleAspectFill
        let padding = rightPaddingValue + (imageView.bounds.size.width) + leftPaddingValue
        let sideView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.bounds.height))
        sideView.isUserInteractionEnabled = true
        sideView.addSubview(imageView)
        
        self.rightViewMode = .always
        self.rightView?.isUserInteractionEnabled = true
        self.rightView = sideView
        self.bringSubviewToFront(sideView)
    }
    
    @objc func changeEyeImg(_ sender: UITapGestureRecognizer) {
        let tappedImage = sender.view as! UIImageView
        isSecureTextEntry = !isSecureTextEntry
        tappedImage.image = UIImage(named: isSecureTextEntry ? "hide" : "show")
    }
    
    @objc func crossBtnTap(_ sender: UITapGestureRecognizer) {
        //text = ""
    }
}
