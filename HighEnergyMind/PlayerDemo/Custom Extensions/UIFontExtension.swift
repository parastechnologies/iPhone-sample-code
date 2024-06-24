//
//  UIFontExtension.swift
//  WorkUp
//
//  Created by iOS TL on 24/05/23.
//

import Foundation
import UIKit

extension UIFont{
    /// Poppins-Regular
        ///
        /// - Parameter size: Font size you need
        /// - Returns: your custom font for custom size
        class func poppinRegular(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "Poppins-Regular", size: size)  ?? .systemFont(ofSize: 15)
        }
    
        class func poppinMedium(ofSize size:CGFloat) -> UIFont{
        return UIFont(name: "Poppins-Medium", size: size) ?? .systemFont(ofSize: 15)
        }
    
    class func interSemibold(ofSize size:CGFloat) -> UIFont{
    return UIFont(name: "Inter-Semibold", size: size) ?? .systemFont(ofSize: 15)
    }
    
    class func interRegular(ofSize size:CGFloat) -> UIFont{
    return UIFont(name: "Inter-Regular", size: size) ?? .systemFont(ofSize: 15)
    }
}
