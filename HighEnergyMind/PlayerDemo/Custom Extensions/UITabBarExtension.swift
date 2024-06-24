//
//  UITabBarExtension.swift
//  WorkUp
//
//  Created by appsdeveloper Developer on 07/09/22.
//


import UIKit

class CustomTabBar: UITabBar {
    
    @IBInspectable var height: CGFloat = 75.0
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first else {
          return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            
            if #available(iOS 11.0, *) {
                sizeThatFits.height = height + window.safeAreaInsets.bottom
            } else {
                sizeThatFits.height = height
            }
        }
        return sizeThatFits
      }
    
}
    

