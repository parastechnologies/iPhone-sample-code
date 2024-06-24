//
//  Indicator.swift
//  KeyChange
//
//  Created by mac11 on 08/05/23.
//

import Foundation
import UIKit

final class Indicator {
    static let shared = Indicator()

    var blurImg   = UIImageView()
    var label    = UILabel()
    var indicator = UIActivityIndicatorView()
    
    private init() {
        blurImg.frame           = UIScreen.main.bounds
        blurImg.backgroundColor = UIColor.black
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha    = 0.7
        indicator.style  = .whiteLarge
        indicator.center = blurImg.center
        indicator.startAnimating()
        indicator.color  = UIColor.white//Constants.AppColor.blueColor
        
        let y = indicator.frame.origin.y + indicator.frame.size.height + 20
        label = UILabel(frame: CGRect(x: 0, y: y, width: blurImg.frame.size.width, height: 25))
        label.textColor = UIColor.white
        label.textAlignment = .center
        
    }
    
    func show(_ withText:String){
        DispatchQueue.main.async( execute: { [weak self] in
            self?.label.text = withText
            UIApplication.shared.keyWindow?.addSubview(self?.blurImg ?? UIImageView())
            UIApplication.shared.keyWindow?.addSubview(self?.indicator ?? UIActivityIndicatorView())
            UIApplication.shared.keyWindow?.addSubview(self?.label ?? UILabel())
        })
    }
    
    func hide(){
        DispatchQueue.main.async( execute: {
            self.blurImg.removeFromSuperview()
            self.indicator.removeFromSuperview()
            self.label.removeFromSuperview()
        })
    }
}


//extension String {
//    var html2AttributedString: NSAttributedString? {
//        do {
//            return try NSAttributedString(data: Data(utf8), options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
//        } catch {
//            print("error:", error)
//            return nil
//        }
//    }
//    var html2String: String {
//        return html2AttributedString?.string ?? ""
//    }
//}
