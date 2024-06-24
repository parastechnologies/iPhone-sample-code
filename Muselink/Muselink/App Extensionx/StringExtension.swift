//
//  StringExtension.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 28/04/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

extension String {
    var htmlText : NSAttributedString {
        let data = Data(self.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            return attributedString
        }
        else {
            return NSAttributedString(string: self)
        }
    }
    static var emojiArray :[String] {
        let arr = ["😊","😆","😬","😐","🤔","😜","😏","😳","😍"]
        return arr
    }
    func currentCountryName() -> String {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
                // Country name was found
                return name
            } else {
                // Country name cannot be found
                return countryCode
            }
        }
        else {
            return "India"
        }
    }
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
