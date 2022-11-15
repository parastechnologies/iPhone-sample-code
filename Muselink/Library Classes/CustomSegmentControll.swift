//
//  CustomSegmentControll.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 07/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
class CustomSegmentedControl: UISegmentedControl {
    private let segmentInset: CGFloat = 5
    private let segmentImage: UIImage? = UIImage(color: UIColor.skyBlue)
    override func layoutSubviews(){
        super.layoutSubviews()
        //background
        layer.cornerRadius = bounds.height/2
        backgroundColor = .clear
        //foreground
        setTitleTextAttributes([NSAttributedString.Key.font : UIFont.Avenir_Medium(size: 20), NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        setTitleTextAttributes([NSAttributedString.Key.font : UIFont.Avenir_Medium(size: 20), NSAttributedString.Key.foregroundColor: UIColor.darkBackGround], for: .selected)
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = segmentImage    //substitute with our own colored image
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")    //this removes the weird scaling animation!
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.bounds.height/2
        }
    }
}
