//
//  NeumorphicUIExtensions.swift
//  Muselink
//
//  Created by appsDev on 26/11/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
import IBAnimatable
import simd
extension SoftUIView {
    @discardableResult
    func setTextView(font:UIFont,textColor:UIColor = .black)->UITextView {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.textColor = textColor
        txtView.backgroundColor = .clear
        txtView.font = font
        self.addSubview(txtView)
        txtView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        txtView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        txtView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        txtView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        return txtView
    }
    @discardableResult
    func setButtonTitle(font:UIFont,title:String,titleColor:UIColor = .black)->UILabel {
        let actionLabel = UILabel()
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionLabel.textColor = titleColor
        actionLabel.font = font
        actionLabel.text = title
        actionLabel.numberOfLines = 0
        actionLabel.textAlignment = .center
        self.setContentView(actionLabel)
        actionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        actionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return actionLabel
    }
    func setButtonTitlewithImage(image:UIImageView,font:UIFont,title:UILabel,titleColor:UIColor = .black) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.setContentView(view)
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = titleColor
        title.font = font
        title.text = "0"
        title.textAlignment = .center
        view.addSubview(title)
        title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.3*self.bounds.width).isActive = true
        title.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    func setButtonTitlewithImageAndSpacer(img:UIImage,font:UIFont,title:String,titleColor:UIColor = .black) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.setContentView(view)
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let actionLabel = UILabel()
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionLabel.textColor = titleColor
        actionLabel.font = font
        actionLabel.text = title
        actionLabel.textAlignment = .left
        view.addSubview(actionLabel)
        actionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:80).isActive = true
        actionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        actionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let image = UIImageView(image: img)
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let spacerImage = UIImageView(image: #imageLiteral(resourceName: "border-inside"))
        spacerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spacerImage)
        spacerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        spacerImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    @discardableResult
    func setTextField(font:UIFont,placeholder:String,titleColor:UIColor = .black,placeholderColor:UIColor = .gray)->UITextField {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let actionLabel = UITextField()
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionLabel.textColor = titleColor
        actionLabel.font = font
        actionLabel.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.font:font,NSAttributedString.Key.foregroundColor:placeholderColor])
        actionLabel.textAlignment = .left
        view.addSubview(actionLabel)
        actionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:20).isActive = true
        actionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        actionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return actionLabel
    }
    @discardableResult
    func setBindingTextField(font:UIFont,placeholder:String,titleColor:UIColor = .black,placeholderColor:UIColor = .gray)->BindingTextField {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let actionLabel = BindingTextField()
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionLabel.textColor = titleColor
        actionLabel.font = font
        actionLabel.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.font:font,NSAttributedString.Key.foregroundColor:placeholderColor])
        actionLabel.textAlignment = .left
        view.addSubview(actionLabel)
        actionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:20).isActive = true
        actionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        actionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return actionLabel
    }
    @discardableResult
    func setTextFieldithSpacer(font:UIFont,placeholder:String,titleColor:UIColor = .black,placeholderColor:UIColor = .gray)->BindingTextField {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let actionLabel = BindingTextField()
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionLabel.textColor = titleColor
        actionLabel.font = font
        actionLabel.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.font:font,NSAttributedString.Key.foregroundColor:placeholderColor])
        actionLabel.textAlignment = .left
        view.addSubview(actionLabel)
        actionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:100).isActive = true
        actionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        actionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let spacerImage = UIImageView(image: #imageLiteral(resourceName: "border-inside"))
        spacerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spacerImage)
        spacerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive = true
        spacerImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return actionLabel
    }
    func setOTPView(view:VPMOTPTextField) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
    @discardableResult
    func setTextFieldithImageAndSpacer(img:UIImage,font:UIFont,placeholder:String,titleColor:UIColor = .black,placeholderColor:UIColor = .gray)-> BindingTextField {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let actionLabel = BindingTextField()
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionLabel.textColor = titleColor
        actionLabel.font = font
        actionLabel.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.font:font,NSAttributedString.Key.foregroundColor:placeholderColor])
        actionLabel.textAlignment = .left
        view.addSubview(actionLabel)
        actionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:80).isActive = true
        actionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        actionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let image = UIImageView(image: img)
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let spacerImage = UIImageView(image: #imageLiteral(resourceName: "border-inside"))
        spacerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spacerImage)
        spacerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        spacerImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return actionLabel
    }
    @discardableResult
    func setButtonImage(image:UIImage) -> UIImageView{
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = image
        self.setContentView(img)
        img.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        img.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return img
    }
    func setSegmentWithTitles(title1:String,title2:String) {
        let img = CustomSegmentedControl()
        img.setTitle(title1, forSegmentAt: 0)
        img.setTitle(title2, forSegmentAt: 1)
        img.translatesAutoresizingMaskIntoConstraints = false
        self.setContentView(img)
        img.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        img.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
        img.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        img.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
    }
    @discardableResult
    func setProfileImage(image:UIImage,border_Color:UIColor = .clear,border_Width:CGFloat = 0) -> UIImageView {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = image
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius  = self.bounds.width/2
        img.layer.masksToBounds = true
        img.layer.borderWidth   = border_Width
        img.layer.borderColor   = border_Color.cgColor
        self.setContentView(img)
        img.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        img.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        img.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        img.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        return img
    }
    func setCellImage(image:UIImage) {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = image
        img.contentMode = .scaleAspectFit
        self.setContentView(img)
        img.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        img.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
    }
    func setButtonImageWithPadding(image:UIImage,padding:CGFloat) {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = image
        self.setContentView(img)
        NSLayoutConstraint(item: img, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: frame.width-(CGFloat(2)*padding)).isActive = true
        NSLayoutConstraint(item: img, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: frame.height-(CGFloat(2)*padding)).isActive = true
        img.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        img.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    @discardableResult
    func addInnerView(frame:CGRect,cornerRadius:CGFloat,backgroundColor:UIColor)-> UIView {
        let actionView = UIView(frame: frame)
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionView.backgroundColor     = backgroundColor
        actionView.layer.cornerRadius  = cornerRadius
        actionView.layer.masksToBounds = true
        self.setContentView(actionView)
        NSLayoutConstraint(item: actionView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: actionView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 10).isActive = true
        actionView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        actionView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return actionView
    }
    func addTextViewWithButton(textView:UITextView,sendbutton:UIButton) {
        let view = UIView(frame: bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.setContentView(view)
        NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: bounds.width).isActive = true
        NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: bounds.height).isActive = true
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        view.isUserInteractionEnabled = true
        textView.isUserInteractionEnabled = true
        self.isUserInteractionEnabled = true
        textView.font = UIFont.AvenirLTPRo_Regular(size: 18)
        textView.textColor = UIColor.placeholder
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 5).isActive = true
        sendbutton.isUserInteractionEnabled = true
        sendbutton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendbutton)
        NSLayoutConstraint(item: sendbutton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60).isActive = true
        sendbutton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        sendbutton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
    public func addInnerGradientViewWithImage(frame:CGRect,cornerRadius: CGFloat = 0, themeColor: [UIColor],imageView:UIImageView) {
        let actionView = UIView(frame: frame)
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionView.applyGradient(colours: themeColor, cornerRadius: cornerRadius)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        actionView.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: actionView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: actionView.centerYAnchor).isActive = true
        self.setContentView(actionView)
        NSLayoutConstraint(item: actionView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: frame.width).isActive = true
        NSLayoutConstraint(item: actionView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: frame.height).isActive = true
        actionView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        actionView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    public func addInnerGradientViewWithImageAndStripe(frame:CGRect,cornerRadius: CGFloat = 0, themeColor: [UIColor],imageView:UIImageView,lowePoint:CGFloat = 50,upperPoint:CGFloat = 90) ->[CAShapeLayer]{
        let view = UIView(frame: bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        let actionView = UIView(frame: frame)
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionView.applyGradient(colours: themeColor, cornerRadius: cornerRadius)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        actionView.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: actionView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: actionView.centerYAnchor).isActive = true
        NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: lowePoint).isActive = true
        NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: lowePoint).isActive = true
        view.addSubview(actionView)
        self.setContentView(view)
        
        NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: bounds.width).isActive = true
        NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: bounds.height).isActive = true
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        NSLayoutConstraint(item: actionView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: frame.width).isActive = true
        NSLayoutConstraint(item: actionView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: frame.height).isActive = true
        actionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        actionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        var shapeLayer = [CAShapeLayer]()
        for i in 0...360 {
            if !i.isMultiple(of: 3) {
                continue
            }
            let bgPath = UIBezierPath()
            bgPath.move(to: CGPoint(x:CGFloat(lowePoint.upperDynamic()*sin(i.degreesToRadians))+view.bounds.width/2, y: CGFloat(lowePoint.upperDynamic()*cos(i.degreesToRadians))+view.bounds.height/2))
            bgPath.addLine(to: CGPoint(x: CGFloat(upperPoint.upperDynamic()*sin(i.degreesToRadians))+view.bounds.width/2, y: CGFloat(upperPoint.upperDynamic()*cos(i.degreesToRadians))+view.bounds.height/2))
            let progressLayer = CAShapeLayer()
            progressLayer.path = bgPath.cgPath
            progressLayer.lineCap = .round
            progressLayer.lineWidth = 2
            progressLayer.fillColor = nil
            if i < 90 {
                let index = Double(i/3)
                let red   = (233+(Double(0.23)*index))/255
                let green = (0+(4.9*index))/255
                let blue  = (248-(6.94*index))/255
                
                progressLayer.strokeColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0).cgColor
            }
            else if i < 180 {
                let index = Double((i-90)/3)
                let red   = (240+(Double(0.27)*index))/255
                let green = (147+(2.8*index))/255
                let blue  = (40-(1.33*index))/255
                
                progressLayer.strokeColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0).cgColor
            }
            else if i < 270 {
                let index = Double((i-180)/3)
                let red   = (248-(Double(5.7)*index))/255
                let green = (225+(0.2*index))/255
                let blue  = (0+(7.6*index))/255
                progressLayer.strokeColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0).cgColor
            }
            else {
                let index = Double((i-270)/3)
                let red   = (75+(Double(5)*index))/255
                let green = (231-(7.5*index))/255
                let blue  = (228+(0.67*index))/255
                progressLayer.strokeColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0).cgColor
            }
            progressLayer.strokeEnd = CGFloat([0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0].randomElement() ?? 0.0)
            view.layer.addSublayer(progressLayer)
            shapeLayer.append(progressLayer)
        }
        return shapeLayer
    }
    
    public func addInnerGradientViewWithProgress() ->[CAShapeLayer]{
        let view = UIView(frame: bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.setContentView(view)
        
        NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: bounds.width).isActive = true
        NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: bounds.height).isActive = true
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        var shapeLayer = [CAShapeLayer]()
        for i in 0...360 {
            if !i.isMultiple(of: 3) {
                continue
            }
            
            let bgPath = UIBezierPath()
            bgPath.move(to: CGPoint(x:CGFloat(120.upperDynamic()*sin(i.degreesToRadians))+view.bounds.width/2, y: CGFloat(110.upperDynamic()*cos(i.degreesToRadians))+view.bounds.height/2))
            bgPath.addLine(to: CGPoint(x: CGFloat(135.upperDynamic()*sin(i.degreesToRadians))+view.bounds.width/2, y: CGFloat(135.upperDynamic()*cos(i.degreesToRadians))+view.bounds.height/2))
            let progressLayer = CAShapeLayer()
            progressLayer.path = bgPath.cgPath
            progressLayer.lineCap = .round
            progressLayer.lineWidth = 2.5
            progressLayer.fillColor = nil
            if i < 90 {
                let index = Double(i/3)
                let red   = (248-(Double(5.7)*index))/255
                let green = (225+(0.2*index))/255
                let blue  = (0+(7.6*index))/255
                progressLayer.strokeColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0).cgColor
            }
            else if i < 180 {
                let index = Double((i-90)/3)
                let red   = (75+(Double(5)*index))/255
                let green = (231-(7.5*index))/255
                let blue  = (228+(0.67*index))/255
                progressLayer.strokeColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0).cgColor
            }
            else if i < 270 {
                let index = Double((i-180)/3)
                let red   = (233+(Double(0.23)*index))/255
                let green = (0+(4.9*index))/255
                let blue  = (248-(6.94*index))/255
                progressLayer.strokeColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0).cgColor
            }
            else {
                let index = Double((i-270)/3)
                let red   = (240+(Double(0.27)*index))/255
                let green = (147+(2.8*index))/255
                let blue  = (40-(1.33*index))/255
                progressLayer.strokeColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0).cgColor
            }
            progressLayer.strokeEnd = CGFloat(1.0)
            progressLayer.isHidden = true
            view.layer.addSublayer(progressLayer)
            shapeLayer.append(progressLayer)
        }
        return shapeLayer
    }
    func setButtonWithGrowingTextView(btn:UIButton,textView:GrowingTextView) {
        let view          = UIStackView()
        view.distribution = .fill
        view.axis         = .horizontal
        view.spacing      = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addArrangedSubview(textView)
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        view.addArrangedSubview(btn)
        NSLayoutConstraint(item: btn, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: btn, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50).isActive = true
        btn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    @discardableResult
    func addLeftSideCornerView()->CAShapeLayer {
        let curvedPath = UIBezierPath()
        curvedPath.move(to: CGPoint(x: 0, y: 0))
        curvedPath.addLine(to: CGPoint(x: 30, y: 0))
        curvedPath.addQuadCurve(to: CGPoint(x: 0, y: 50), controlPoint: CGPoint(x: 25, y: 25))
        curvedPath.addLine(to: CGPoint(x: 0, y: 0))
        curvedPath.close()
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = curvedPath.cgPath
        maskLayer.masksToBounds = true
        layer.addSublayer(maskLayer)
        return maskLayer
    }
}
extension UIButton {
    override open var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                 setState()
            } else {
                 resetState()
            }
        }
    }
    override open var isEnabled: Bool {
        didSet{
            if isEnabled == false {
                setState()
            } else {
                resetState()
            }
        }
    }
    func setState(){
        self.layer.shadowOffset = CGSize(width: -2, height: -2)
        self.layer.sublayers?[0].shadowOffset = CGSize(width: 2, height: 2)
        self.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 0)
    }
    
    func resetState(){
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.sublayers?[0].shadowOffset = CGSize(width: -2, height: -2)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 2)
    }
    
    public func addSoftUIEffectForButton(cornerRadius: CGFloat = 15.0, themeColor: UIColor = UIColor(red: 241/255, green: 243/255, blue: 246/255, alpha: 1.0)) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize( width: 2, height: 2)
        self.layer.shadowColor = UIColor(red: 223/255, green: 228/255, blue: 238/255, alpha: 1.0).cgColor
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.backgroundColor = themeColor.cgColor
        shadowLayer.shadowColor = UIColor.white.cgColor
        shadowLayer.cornerRadius = cornerRadius
        shadowLayer.shadowOffset = CGSize(width: -2.0, height: -2.0)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 2
        self.layer.insertSublayer(shadowLayer, below: self.imageView?.layer)
    }
}
