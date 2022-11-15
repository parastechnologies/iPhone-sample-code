//
//  UIColorExtensions.swift
//  Muselink
//
//  Created by appsDev on 26/11/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit

extension UIColor {
    class var darkBackGround : UIColor {
        return UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
    }
    class var semiDarkShadow : UIColor {
        return UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
    }
    class var semiDarkBackGround : UIColor {
        return UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1.0)
    }
    class var paleGray : UIColor {
        return UIColor(red: 235/255, green: 234/255, blue: 246/255, alpha: 1.0)
    }
    class var appRed : UIColor {
        return UIColor(red: 247/255, green: 71/255, blue: 95/255, alpha: 1.0)
    }
    class var brightPurple : UIColor {
        return UIColor(red: 196/255, green: 1/255, blue: 1, alpha: 1.0)
    }
    class var lightShadow : UIColor {
        return UIColor(red: 241/255, green: 241/255, blue: 248/255, alpha: 1.0)
    }
    class var darkShadow : UIColor {
        return UIColor(red: 201/255, green: 201/255, blue: 208/255, alpha: 1.0)
    }
    class var placeholder : UIColor {
        return UIColor(red: 164/255, green: 160/255, blue: 200/255, alpha: 1.0)
    }
    class var waterMelon : UIColor {
        return UIColor(red: 247/255, green: 71/255, blue: 95/255, alpha: 1.0)
    }
    class var skyBlue : UIColor {
        return UIColor(red: 115/255, green: 202/255, blue: 220/255, alpha: 1.0)
    }
    class var redPink : UIColor {
        return UIColor(red: 239/255, green: 114/255, blue: 158/255, alpha: 1.0)
    }
    class var paleGrayText : UIColor {
        return UIColor(red: 164/255, green: 160/255, blue: 200/255, alpha: 1.0)
    }
    class var paleGreen : UIColor {
        return UIColor(red: 107/255, green: 214/255, blue: 92/255, alpha: 1.0)
    }
    class var appOrange : UIColor {
        return UIColor(red: 255/255, green: 118/255, blue: 0, alpha: 1.0)
    }
    class var appPeachOrange : UIColor {
        return UIColor(red: 209/255, green: 117/255, blue: 109/255, alpha: 1.0)
    }
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat,a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}
