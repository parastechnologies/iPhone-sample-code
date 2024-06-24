//
//  UIImageViewExtension.swift
//  WorkUp
//
//  Created by appsdeveloper Developer on 27/10/22.
//

import UIKit
import SDWebImage

extension UIImageView{
    
    func alphaAtPoint(_ point: CGPoint) -> CGFloat {
        
        var pixel: [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let alphaInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: alphaInfo) else {
            return 0
        }
        
        context.translateBy(x: -point.x, y: -point.y);
        
        layer.render(in: context)
        
        let floatAlpha = CGFloat(pixel[3])
        
        return floatAlpha
    }
    
  
    
    func setImage(link:String)
    {
        var getLink = link.removingPercentEncoding //REMOVING PREVIOUS PERCENTAGE ENCODING IN CASE OF ADDED BY OTHER PLATFORM
        getLink = getLink?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string:getLink ?? "") else {
            self.sd_setImage(with: URL(string:""), completed: nil)
            return
        }
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
                  self.sd_setImage(with: url, completed: nil)
        // self.sd_setImage(with: url, placeholderImage: nil, options: .allowInvalidSSLCertificates, context: nil)
//        sd_setImage(with: url) { getImage, error, cacheType, url in
//            print("error is",error)
//            self.image = getImage
//        }
    }
    
    func setImageWithPlaceholder(link:String,imgName:String)
    {
        var getLink = link.removingPercentEncoding //REMOVING PREVIOUS PERCENTAGE ENCODING IN CASE OF ADDED BY OTHER PLATFORM
        getLink = getLink?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string:getLink ?? "") else {
            self.sd_setImage(with:URL(string:""), placeholderImage: UIImage(named: imgName))
            return
        }
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with:url, placeholderImage: UIImage(named: imgName))
//        sd_setImage(with: url,placeholderImage: UIImage(named: imgName)) { getImage, error, cacheType, url in
//            print("error is",error)
//            self.image = getImage
//        }
    }
    
    
    
    func setImageWithoutLoader(link:String)
    {
        var getLink = link.removingPercentEncoding //REMOVING PREVIOUS PERCENTAGE ENCODING IN CASE OF ADDED BY OTHER PLATFORM
        getLink = getLink?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string:getLink ?? "") else {
            self.sd_setImage(with: URL(string:""), completed: nil)
            return
        }
        self.sd_setImage(with: url, completed: nil)
    }
    
    func showLoading()
    {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_imageIndicator?.startAnimatingIndicator()
        
    }
    func hideLoading(){
        self.sd_imageIndicator?.stopAnimatingIndicator()
    }
    
    public func maskCircle() {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        // self.image = anyImage
    }
}
