//
//  UIButtonExtension.swift
//  WorkUp
//
//  Created by appsdeveloper Developer on 05/09/22.
//

import UIKit
import SDWebImage

//Button
extension UIButton{
    
    func setImageTintColor(_ color: UIColor) {
          let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
          self.setImage(tintedImage, for: .normal)
          self.tintColor = color
      }
    
    var roundBorder : UIButton {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
        return self
    }
    
    func btnMultipleLines() {
           titleLabel?.numberOfLines = 0
           titleLabel?.lineBreakMode = .byWordWrapping
           titleLabel?.textAlignment = .center
       }
    
    func underline() {
           guard let text = self.titleLabel?.text else { return }
           let attributedString = NSMutableAttributedString(string: text)
           //NSAttributedStringKey.foregroundColor : UIColor.blue
           attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
           attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
           attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
           self.setAttributedTitle(attributedString, for: .normal)
       }
    
    func underline(withColor:UIColor) {
          // guard let text = self.titleLabel?.text else { return }
        
           let text = "Ok"
           let attributedString = NSMutableAttributedString(string: text)
           //NSAttributedStringKey.foregroundColor : UIColor.blue
//           attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: withColor, range: NSRange(location: 0, length: text.count))

           attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
           attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
           self.setAttributedTitle(attributedString, for: .normal)
       }
    
    func alignTextUnderImage(spacing: CGFloat = 6.0)
       {
           if let image = self.imageView?.image
           {
               let imageSize: CGSize = image.size
               self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
               let labelString = NSString(string: self.titleLabel!.text!)
               let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font ?? UIFont.systemFont(ofSize: 15)])
               self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
           }
       }
    
    func imageToRight() {
         transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
         titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
         imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
     }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat,size:CGRect) {
            let border = CALayer()
            border.removeFromSuperlayer()
            border.backgroundColor = color.cgColor
            border.frame = size//CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
            self.layer.addSublayer(border)
    }
    
    func setImage(link:String)
          {
              var getLink = link
              getLink = getLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
              
              guard let url = URL(string:getLink) else {
//                  self.sd_setImage(with: URL(string:""), completed: nil)
                  self.sd_setImage(with:URL(string:""), for: .normal, placeholderImage: UIImage(named: ""))
                  return }
              self.sd_imageIndicator = SDWebImageActivityIndicator.gray
              self.sd_setImage(with:url, for: .normal, placeholderImage: UIImage(named: ""))
          }
          
          func setImageWithPlaceholder(link:String,imgName:String)
            {
                var getLink = link
                getLink = getLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                guard let url = URL(string:getLink) else {
                    self.sd_setImage(with:URL(string:""), for: .normal, placeholderImage: UIImage(named: imgName))


                    return }
                self.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.sd_setImage(with:url, for: .normal, placeholderImage: UIImage(named: imgName))
            }
    
}

class MarqueeButton: UIButton {

    override func layoutSubviews() {
           super.layoutSubviews()
           applyMarqueeEffect()
       }
       
        func applyMarqueeEffect() {
           // Check if the text width is greater than the button's width
           guard let titleLabel = titleLabel, let text = titleLabel.text, let font = titleLabel.font else {
               return
           }
           
           let attributes: [NSAttributedString.Key: Any] = [.font: font]
           let textWidth = (text as NSString).size(withAttributes: attributes).width + 30
           
           if textWidth > bounds.width {
               // Apply marquee effect animation
               let animation = CABasicAnimation(keyPath: "position")
               animation.fromValue = NSValue(cgPoint: layer.position)
               animation.toValue = NSValue(cgPoint: CGPoint(x: (-textWidth)+30, y: layer.position.y))
               animation.duration = Double(textWidth) / 30 // Adjust the duration based on your preference
               animation.repeatCount = .greatestFiniteMagnitude
               titleLabel.layer.add(animation, forKey: "marqueeAnimation")
           } else {
               // Remove any existing marquee animation
               titleLabel.layer.removeAnimation(forKey: "marqueeAnimation")
           }
       }
       
       override func prepareForInterfaceBuilder() {
           super.prepareForInterfaceBuilder()
           applyMarqueeEffect()
       }
}
