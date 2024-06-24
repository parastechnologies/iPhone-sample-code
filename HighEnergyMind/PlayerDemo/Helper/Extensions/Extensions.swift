//
//  ExtensionData.swift
//  KeyChange
//
//  Created by mac11 on 08/05/23.
//

import Foundation
import UIKit
import IBAnimatable

enum DateFormattt: String{
    case HHmm = "HH:mm"
    case hmma = "h:mm a"
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss.sssZ"
    case yyyyMMddHHmm = "yyyy-MM-dd HH:mm:ssZ"
    case yyyyMMdd = "yyyy-MM-dd"
    case EEEEddMMYYYY = "EEEE d,MMMM yyyy"
}

private var kAssociationKeyMaxLength: Int = 0
enum Timezone: String {
    case UTC = "UTC"
}
extension String{
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
    func isValidAccountNumber() -> Bool {
        let regexPattern = "^[0-9]{6,20}$"
        let range = NSPredicate(format:"SELF MATCHES %@", regexPattern)
        return range.evaluate(with: self)
        
    }
    func isValidRoutingNumber() -> Bool {
        let regexPattern = "^[0-9]{9}$"
        let range = NSPredicate(format:"SELF MATCHES %@", regexPattern)
        return range.evaluate(with: self)
    }
    func convertDate(from inputFormat: DateFormattt, to outputFormat: DateFormattt, timezone: Timezone? = nil, dateStyle: DateFormatter.Style? = nil, timeStyle: DateFormatter.Style? = nil, getString: Bool) -> (date:Date?,dateInString:String?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat.rawValue
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let dateStyle = dateStyle{
            dateFormatter.dateStyle = dateStyle
        }
        if let timeStyle = timeStyle{
            dateFormatter.timeStyle = timeStyle
        }
        
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = outputFormat.rawValue
        if let date = date{
            let dateInStrValue = dateFormatter.string(from: date )
            let dateValue = dateFormatter.date(from: dateInStrValue)
            if getString{
                return (nil,dateInStrValue)
            }
            return (dateValue, nil)
        }
        return (nil,nil)
    }
    
    func convertDate(inputFormat: String = "yyyy-MM-dd HH:mm:ss", outputFormat: String = "yyyy-MM-dd", timezone: String? = nil) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if timezone != nil {
            dateFormatter.timeZone = TimeZone(abbreviation: timezone!)
        }
        if let date = dateFormatter.date(from: self) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = outputFormat
            return dateFormatter.string(from: date)
        } else {
            return "No Date"
        }
    }
    
    func parseToStringNums() -> [String]? {
//        return Int(self.components(separatedBy: )
        return self.components(separatedBy: CharacterSet(charactersIn: "-"))
    }
    
}

extension AnimatableTextField{
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
              prospectiveText.count > maxLength
        else { return }
        let selection = selectedTextRange
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        selectedTextRange = selection
    }
}

extension UIViewController{
    func getFormattedDate(strDate: String , currentFomat:String, expectedFromat: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = currentFomat
        let date : Date = dateFormatterGet.date(from: strDate) ?? Date()
        dateFormatterGet.dateFormat = expectedFromat
        return dateFormatterGet.string(from: date)
    }
    
    func getPastTime(for date : Date, utcTimeString: String, inputFormat: String, outputFormat: String) -> String {
        var secondsAgo = Int(Date().timeIntervalSince(date))
        if secondsAgo < 0 {
            secondsAgo = secondsAgo * (-1)
        }
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day

        if secondsAgo < minute  {
            if secondsAgo < 2{
                return "just now"
            }else{
                return "\(secondsAgo) seconds ago"
            }
        } else if secondsAgo < hour {
            let min = secondsAgo/minute
            if min == 1{
                return "\(min) minute ago"
            }else{
                return "\(min) minutes ago"
            }
        } else if secondsAgo < day {
            let hr = secondsAgo/hour
            if hr == 1{
                return "\(hr) hour ago"
            } else {
                return "\(hr) hours ago"
            }
        } else if secondsAgo < week {
            let day = secondsAgo/day
            if day == 1{
                return "\(day) day ago"
            }else{
                return "\(day) days ago"
            }
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = inputFormat
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            
            if let utcDate = dateFormatter.date(from: utcTimeString) {
                let localTimeZone = TimeZone.current
                let localDateFormatter = DateFormatter()
                localDateFormatter.dateFormat = outputFormat
                localDateFormatter.timeZone = localTimeZone
                
                return localDateFormatter.string(from: utcDate) // 20 Dec 2023
            } else {
                return "Invalid Date"
            }
        }
    }
    
    func convertUTCToLocalTime(utcTimeString: String, inputFormat: String, outputFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        if let utcDate = dateFormatter.date(from: utcTimeString) {
            let localTimeZone = TimeZone.current
            let localDateFormatter = DateFormatter()
            localDateFormatter.dateFormat = outputFormat
            localDateFormatter.timeZone = localTimeZone
            
            return localDateFormatter.string(from: utcDate) // 20 Dec 2023
        } else {
            return "Invalid Date"
        }
    }
    
    func restrictNumericInput(for textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {
            return true
        }
        let numericSet = CharacterSet(charactersIn: "0123456789")
        return string.rangeOfCharacter(from: numericSet) == nil
    }
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


//MARK: - INT
extension Int {
    func secondsToMinutes() -> Int {
        return (self / 60)
    }
}

/* Date Formats
 Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
 09/12/2018                        --> MM/dd/yyyy
 09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
 Sep 12, 2:11 PM                   --> MMM d, h:mm a
 September 2018                    --> MMMM yyyy
 Sep 12, 2018                      --> MMM d, yyyy
 Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
 2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
 12.09.18                          --> dd.MM.yy
 10:41:02.112                      --> HH:mm:ss.SSS
 */
