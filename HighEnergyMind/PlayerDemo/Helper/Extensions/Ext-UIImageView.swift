//
//  Ext-UIImageView.swift
//  HighEnergyMind
//
//  Created by iOS TL on 27/03/24.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func showImage(image: String) {
        self.image = UIImage(named: image)
    }
    
//    func showImage(imgURL: String, contentMode: UIImageView.ContentMode = .scaleAspectFill, placeholderImage: String? = "bottom-logo") {
//        if let imageURL = URL(string: imgURL), imgURL != "" {
//
//            var placeImage: UIImage? = nil
//            if placeholderImage != nil {
//                placeImage = UIImage(named: placeholderImage!)
//                self.image = placeImage
//                //             self.contentMode = .scaleAspectFit
//            }
//
//            self.contentMode = contentMode
//            self.sd_setImage(with: imageURL, placeholderImage: placeImage, options: SDWebImageOptions.fromCacheOnly) { (image, error, cacheType, url) in
//                if error != nil {
//                    self.image = placeImage
//                    //                self.contentMode = .scaleAspectFit
//                } else {
//                    //                self.contentMode = .scaleAspectFill
//
//                    if image == nil {
//                        self.contentMode = contentMode
//                        self.sd_setImage(with: imageURL, placeholderImage: placeImage)
//                    }
//                }
//                return
//            }
////            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
//        } else {
////            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            self.image = UIImage(named: placeholderImage ?? "")
//            self.contentMode = .scaleAspectFit
//        }
//    }
    
    func showImage(imgURL:String,imgName:String = "")
    {
        var getLink = imgURL.removingPercentEncoding //REMOVING PREVIOUS PERCENTAGE ENCODING IN CASE OF ADDED BY OTHER PLATFORM
        getLink = getLink?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string:getLink ?? "") else {
            self.image = UIImage(named: imgName)
//            self.sd_setImage(with:URL(string:""), placeholderImage: UIImage(named: imgName))
            return
        }
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with:url, placeholderImage: UIImage(named: imgName))
//        sd_setImage(with: url,placeholderImage: UIImage(named: imgName)) { getImage, error, cacheType, url in
//            print("error is",error)
//            self.image = getImage
//        }
    }
    
    func showImageWithoutPlaceholder(imgURL:String,imgName:String = "")
    {
        var getLink = imgURL.removingPercentEncoding //REMOVING PREVIOUS PERCENTAGE ENCODING IN CASE OF ADDED BY OTHER PLATFORM
        getLink = getLink?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string:getLink ?? "") else {
            self.image = UIImage(named: imgName)
//            self.sd_setImage(with:URL(string:""), placeholderImage: UIImage(named: imgName))
            return
        }
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with:url, placeholderImage: UIImage(named: imgName))
//        sd_setImage(with: url,placeholderImage: UIImage(named: imgName)) { getImage, error, cacheType, url in
//            print("error is",error)
//            self.image = getImage
//        }
    }
}
