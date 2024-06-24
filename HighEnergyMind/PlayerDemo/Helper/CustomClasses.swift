//
//  CustomClasses.swift
//  HighEnergyMind
//
//  Created by iOS TL on 11/03/24.
//

import Foundation
import UIKit
import IBAnimatable


//MARK: - CUSTOM IMAGE
class CircleImageView: AnimatableImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = self.bounds.size.width / 2.0
        
        self.layer.cornerRadius = radius
    }
}

//MARK: - CUSTOM BUTTON
@IBDesignable
class DefaultButton: UIButton {
    
    @IBInspectable var isCentered: Bool = false {
        didSet {
            updateUI()
        }
    }
    @IBInspectable var spacing: CGFloat = 5
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateUI()
    }
    
    func updateUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.isCentered {
                self.centerLabelVerticallyWithPadding(spacing: self.spacing)
            }
        }
    }
}

extension UIButton {
    func centerLabelVerticallyWithPadding(spacing:CGFloat) {
        // update positioning of image and title
        let imageSize = self.imageView!.frame.size
        self.titleEdgeInsets = UIEdgeInsets(top:0,
                                            left:-imageSize.width,
                                            bottom:-(imageSize.height + spacing),
                                            right:0)
        let titleSize = self.titleLabel!.frame.size
        self.imageEdgeInsets = UIEdgeInsets(top:-(titleSize.height + spacing),
                                            left:0,
                                            bottom: 0,
                                            right:-titleSize.width)
        
        // reset contentInset, so intrinsicContentSize() is still accurate
        let trueContentSize = self.titleLabel!.frame.union(self.imageView!.frame).size
        let oldContentSize = self.intrinsicContentSize
        let heightDelta = trueContentSize.height - oldContentSize.height
        let widthDelta = trueContentSize.width - oldContentSize.width
        self.contentEdgeInsets = UIEdgeInsets(top:heightDelta/2.0,
                                              left:widthDelta/2.0,
                                              bottom:heightDelta/2.0,
                                              right:widthDelta/2.0)
    }
}


//MARK: - CUSTOM COLLECTION VIEW
class SelfSizingCollectionView: UICollectionView {
    
    override var contentSize: CGSize{
        didSet {
            if oldValue.height != self.contentSize.height {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class DynamicHeightCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if bounds.size != intrinsicContentSize {
            
            self.invalidateIntrinsicContentSize()
            
        }
        
    }
    
    override var intrinsicContentSize: CGSize {
        
        return collectionViewLayout.collectionViewContentSize
        
    }
    
}

//MARK: - CUSTOM UISWITCH
class UISwitchCustom: UISwitch {
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = OffTint
            self.layer.cornerRadius = 16
            self.backgroundColor = OffTint
        }
    }
}
