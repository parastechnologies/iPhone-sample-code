//
//  UIImageViewExtension.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 05/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import Photos
import SDWebImage
class ImageViewRoundView:UIImageView {
    var roundValue       : CGFloat = 0
    var border_Color     : UIColor = UIColor.white
    var border_Width     : CGFloat = 0
    var shadow_Color     : UIColor = UIColor.black
    var shadaowView = UIView()
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        shadaowView.frame = frame
        if shadaowView.tag != 100 {
            shadaowView.tag = 100
            _ = shadaowView.dropShadow(shadowColor: shadow_Color, fillColor: .clear, opacity: 0.2, offset: CGSize(width: 0.0, height: 2.0), radius: roundValue)
            superview?.insertSubview(shadaowView, at: 0)
        }
    }
    override func draw(_ rect: CGRect) {
        layer.borderWidth = border_Width
        layer.borderColor = border_Color.cgColor
        layer.cornerRadius = roundValue
        layer.masksToBounds = true
    }
}
extension UIImageView {
    func fetchImageAsset(_ asset: PHAsset?, targetSize size: CGSize, contentMode: PHImageContentMode = .aspectFill, options: PHImageRequestOptions? = nil, completionHandler: ((Bool) -> Void)?) {
      // 1
      guard let asset = asset else {
        completionHandler?(false)
        return
      }
        
      // 2
      let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, info in
        self.image = image
        completionHandler?(true)
      }
      // 3
      PHImageManager.default().requestImage(
        for: asset,
        targetSize: size,
        contentMode: contentMode,
        options: options,
        resultHandler: resultHandler)
    }
    
    func setImage(name:String,placeholderImage : UIImage = #imageLiteral(resourceName: "SampleUser")) {
        if let imgURL = URL(string: NetworkManager.profileImageBaseURL+name) {
            sd_setImage(with: imgURL, placeholderImage: placeholderImage, options: .highPriority, context: nil)
        }
    }
}
