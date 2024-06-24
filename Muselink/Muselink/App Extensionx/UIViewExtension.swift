//
//  UIViewExtension.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 08/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor],cornerRadius:CGFloat = 0) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil,cornerRadius:cornerRadius)
    }
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?,cornerRadius:CGFloat) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.cornerRadius = cornerRadius
        gradient.masksToBounds = true
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    func addConstraintsWithVisualStrings(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    /** This method binds the view with frame of keyboard frame. So, The View will change its frame with the height of the keyboard's height */
    func bindToTheKeyboard(_ bottomConstaint: NSLayoutConstraint? = nil) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: bottomConstaint)
    }
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let curveframe = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let deltaY = targetFrame.origin.y - curveframe.origin.y
        
        if let constraint = notification.object as? NSLayoutConstraint {
            constraint.constant = deltaY
            UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions.init(rawValue: curve), animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions.init(rawValue: curve), animations: {
                self.frame.origin.y += deltaY
            }, completion: nil)
        }
    }
    func dropShadow(shadowColor: UIColor = UIColor.black,
                    fillColor: UIColor   = UIColor.white,
                    opacity: Float       = 0.2,
                    offset: CGSize       = CGSize(width: 0.0, height: 1.0),
                    radius: CGFloat      = 10) -> CAShapeLayer {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path          = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor     = fillColor.cgColor
        shadowLayer.shadowColor   = shadowColor.cgColor
        shadowLayer.shadowPath    = shadowLayer.path
        shadowLayer.shadowOffset  = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius  = radius
        layer.insertSublayer(shadowLayer, at: 0)
        return shadowLayer
    }
}
