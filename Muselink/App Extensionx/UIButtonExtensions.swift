//
//  UIButtonExtensions.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 12/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import IBAnimatable
@IBDesignable
class CustomRightAndLeftImageButton:UIButton {
    @IBInspectable var leftImage     : UIImage = UIImage()
    @IBInspectable var rightImage    : UIImage = UIImage()
    @IBInspectable var titleColor    : UIColor = UIColor.black
    @IBInspectable var titleStr      : String  = String()
    let title = UILabel()
    override func layoutSubviews() {
        super.layoutSubviews()
        title.text = titleStr
    }
    override func draw(_ rect: CGRect) {
        let leftImg = UIImageView(image: leftImage)
        leftImg.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(leftImg)
        leftImg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        leftImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        title.text = titleStr
        title.font = .Avenir_Medium(size: 20)
        title.textColor = titleColor
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 45).isActive = true
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let rightImg = UIImageView(image: rightImage)
        rightImg.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rightImg)
        rightImg.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        rightImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
class CustomLeftImageButton:AnimatableButton {
    @IBInspectable var leftImage     : UIImage = UIImage()
    @IBInspectable var rightImage    : UIImage = UIImage()
    @IBInspectable var titleColor    : UIColor = UIColor.black
    @IBInspectable var titleStr      : String  = String()
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func draw(_ rect: CGRect) {
        let title = UILabel()
        title.text = titleStr
        title.font = .AvenirLTPRo_Regular(size: 15)
        title.textColor = titleColor
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let rightImg = UIImageView(image: rightImage)
        rightImg.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rightImg)
        rightImg.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        rightImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    func showAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now()+(0.5*Double(tag))) {[weak self] in
            self?.isHidden = false
        }
    }
}
