//
//  StringExtension.swift
//  WorkUp
//
//  Created by appsdeveloper Developer on 08/09/22.
//

import Foundation
import UIKit
extension String{
    
    var path: String? {
        return Bundle.main.path(forResource: self, ofType: nil)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }
    
    var toDouble: Double {
        return Double(self) ?? 0.0
    }
    var toInt:Int {
        return Int(self) ?? 0
    }
    
    static func format(decimal:Float, _ maximumDigits:Int = 1, _ minimumDigits:Int = 1) ->String? {
        let number = NSNumber(value: decimal)
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = maximumDigits
        numberFormatter.minimumFractionDigits = minimumDigits
        return numberFormatter.string(from: number)
    }
    
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
            let attributedString = NSMutableAttributedString(string: self)
            for string in strings {
                let range = (self as NSString).range(of: string)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            }

            guard let characterSpacing = characterSpacing else {return attributedString}

            attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

            return attributedString
        }
    
    var subStringAfterLastHash : String {
            guard let subrange = self.range(of: "#\\s?", options: [.regularExpression, .backwards]) else { return self }
            return String(self[subrange.upperBound...])
    }
    
    func isStringLink(string: String) -> Bool {
            let types: NSTextCheckingResult.CheckingType = [.link]
            let detector = try? NSDataDetector(types: types.rawValue)
            guard (detector != nil && string.count > 0) else { return false }
            if detector!.numberOfMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.count)) > 0 {
                return true
            }
            return false
        }
    
    func withBoldText(text: String, font: UIFont? = nil) -> NSAttributedString {
      let _font = font ?? UIFont.systemFont(ofSize: 14, weight: .regular)
      let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
      let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)]
      let range = (self as NSString).range(of: text)
      fullString.addAttributes(boldFontAttribute, range: range)
      return fullString
    }
    
    var currencySymbol : String {
        return "$"
    }
 
    var isLowercase: Bool {
          return self == self.lowercased()
      }

      var isUppercase: Bool {
          return self == self.uppercased()
      }
    
    
    var digits: String {
            return components(separatedBy: CharacterSet.decimalDigits.inverted)
                .joined()
        }
    
    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
            let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)
            return ceil(boundingBox.width)
        }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        //Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
//        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
        let regex = ".*[A-Z].*"
        let isMatched = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: self)
        return isMatched
    }
        
        var toFloat : CGFloat {
            if let doubleValue = Double(self) {
               return CGFloat(doubleValue)
            }
            return 0.0
        }
        
        
        var addCurrency : String {
            return "$\(self)"
        }
   
        func fromUTCToLocalDateTime() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//"yyyy-MM-dd h:mm:ss"
            
            //MM-dd-yyyy h:mm a
            //"MM-dd-yyyy h:mm a"//"yyyy-MM-dd HH:mm:ss Z"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            var formattedString = self.replacingOccurrences(of: "Z", with: "")
            if let lowerBound = formattedString.range(of: ".")?.lowerBound {
                formattedString = "\(formattedString[..<lowerBound])"
            }
            
            guard let date = dateFormatter.date(from: formattedString) else {
                return self
            }

    //        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            dateFormatter.dateFormat = "d MMM, yyyy | hh:mm a"//"MMM d, yyyy | hh:mm a"
            dateFormatter.timeZone = TimeZone.current
            return dateFormatter.string(from: date)
        }
        
         func fromUTCToLocalDateOnly() -> String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"  //"2022-06-16T11:37:17.901Z"
               dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                var formattedString = self.replacingOccurrences(of: "Z", with: "")
             
                if let lowerBound = formattedString.range(of: ".")?.lowerBound {
                    formattedString = "\(formattedString[..<lowerBound])"
                }

                guard let date = dateFormatter.date(from: formattedString) else {
                    return self
                }

        //      dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
                dateFormatter.dateFormat = "MM-dd-yyyy"
                dateFormatter.timeZone = TimeZone.current
                return dateFormatter.string(from: date)
            }
        
        func formattedDate() -> String {
               let dateFormatter = DateFormatter()
             //  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"  //"2022-06-16T11:37:17.901Z"
            
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" //2022-04-20T06:41:40.168Z

    //           var formattedString = self.replacingOccurrences(of: "Z", with: "")
    //           if let lowerBound = formattedString.range(of: ".")?.lowerBound {
    //               formattedString = "\(formattedString[..<lowerBound])"
    //           }

               guard let date = dateFormatter.date(from: self) else {
                   return self
               }

       //      dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
               dateFormatter.dateFormat = "d MMM yyyy"
               dateFormatter.timeZone = TimeZone.current
               return dateFormatter.string(from: date)
           }
    
    func formattedTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" //2022-04-20T06:41:40.168Z
        
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
        
    func fromUTCToLocalTimeOnly() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//"yyyy-MM-dd HH:mm:ss" //2022-12-16T05:00:18.097Z
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        var formattedString = self.replacingOccurrences(of: "Z", with: "")
        if let lowerBound = formattedString.range(of: ".")?.lowerBound {
            formattedString = "\(formattedString[..<lowerBound])"
        }
        guard let date = dateFormatter.date(from: formattedString) else {
            return self
        }
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    
    func timeAgoFromUTC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//"yyyy-MM-dd HH:mm:ss" //2022-12-16T05:00:18.097Z
       dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        var formattedString = self.replacingOccurrences(of: "Z", with: "")
        if let lowerBound = formattedString.range(of: ".")?.lowerBound {
            formattedString = "\(formattedString[..<lowerBound])"
        }
        guard let date = dateFormatter.date(from: formattedString) else {
            return self
        }
        dateFormatter.dateFormat = "d MMM, yyyy | hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
       }
        
        func getAgoTimeString(dateStr:String) -> String {
            let date = Date()
            let dataFormat = DateFormatter()
            dataFormat.locale = Locale(identifier: "en_US_POSIX")
            dataFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" //yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
           // dataFormat.timeZone = NSTimeZone(name: "UTC")! as TimeZone
            let createDate = dataFormat.date(from: dateStr )
          //  print(createDate ?? "default value")
            let result = dataFormat.string(from: date)
            let nowDate = dataFormat.date(from: result)
            if let getCreateDate = createDate, let getCurrent = nowDate {
                let agoTime = self.timeAgoSinceDate(getCreateDate, currentDate: getCurrent, numericDates: true)
                return agoTime
            }
            return dateStr
        }
    func convert(inputFormat: DateFormat, outputFormat: DateFormat) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = inputFormat.rawValue
        dateFormat.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormat.date(from: self) {
            dateFormat.dateFormat = outputFormat.rawValue
            dateFormat.timeZone = TimeZone.current
            return dateFormat.string(from: date)
        }
        return ""
    }
    func getAgoTimeStringWithUTC(dateStr:String) -> String {
        let date = Date()
        let dataFormat = DateFormatter()
        dataFormat.locale = Locale(identifier: "en_US_POSIX")
        dataFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" //yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
        dataFormat.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let createDate = dataFormat.date(from: dateStr )
      //  print(createDate ?? "default value")
        let result = dataFormat.string(from: date)
        let nowDate = dataFormat.date(from: result)
        if let getCreateDate = createDate, let getCurrent = nowDate {
            let agoTime = self.timeAgoSinceDate(getCreateDate, currentDate: getCurrent, numericDates: true)
            return agoTime
        }
        return dateStr
    }
        
        func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
            let calendar = Calendar.current
            let now = currentDate
            let earliest = (now as NSDate).earlierDate(date)
            let latest = (earliest == now) ? date : now
            let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
            if (components.year! >= 2) {
                return "\(components.year!) years ago"
            } else if (components.year! >= 1){
                if (numericDates){
                    return "1 year ago"
                } else {
                    return "Last year"
                }
            } else if (components.month! >= 2) {
                return "\(components.month!) months ago"
            } else if (components.month! >= 1){
                if (numericDates){
                    return "1 month ago"
                } else {
                    return "Last month"
                }
            } else if (components.weekOfYear! >= 2) {
                return "\(components.weekOfYear!) weeks ago"
            } else if (components.weekOfYear! >= 1){
                if (numericDates){
                    return "1 week ago"
                } else {
                    return "Last week"
                }
            } else if (components.day! >= 2) {
                return "\(components.day!) days ago"
            } else if (components.day! >= 1){
                if (numericDates){
                    return "1 day ago"
                } else {
                    return "Yesterday"
                }
            } else if (components.hour! >= 2) {
                return "\(components.hour!) hours ago"
            } else if (components.hour! >= 1){
                if (numericDates){
                    return "1 hour ago"
                } else {
                    return "An hour ago"
                }
            } else if (components.minute! >= 2) {
                return "\(components.minute!) minutes ago"
            } else if (components.minute! >= 1){
                if (numericDates){
                    return "1 minute ago"
                } else {
                    return "A minute ago"
                }
            } else if (components.second! >= 3) {
                return "\(components.second!) seconds ago"
            } else {
                return "Just now"
            }
        }
        
    
}

extension Double {
    var toInt:Int{
        if self.isNaN || self.isInfinite {
            return 0
        }
        return Int(self)
    }
    
    func rounded(toPlaces places:Int) -> Double {
          let divisor = pow(10.0, Double(places))
          return (self * divisor).rounded() / divisor
      }
    
    func lastRounded() -> Double{
        guard let doubleStr = Double(String(format: "%.2f", ceil(self*100)/100)) else { return 0 } // 3.15
        return doubleStr
    }
    func reduceScale(to places: Int) -> Double {
            let multiplier = pow(10, Double(places))
            let newDecimal = multiplier * self // move the decimal right
            let truncated = Double(Int(newDecimal)) // drop the fraction
            let originalDecimal = truncated / multiplier // move the decimal back
            return originalDecimal
        }
}

extension Float {
    func rounded(toPlaces places:Float) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}


extension Int {
    var toDouble : Double{
        return Double(self)
    }
    var toString : String{
        return "\(self)"
    }
    
    
}


extension NSMutableAttributedString {
    var fontSize:CGFloat { return 12}
    var regularFont:UIFont { return UIFont(name: "Poppins-SemiBold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: 14) }
    var boldFont:UIFont { return UIFont(name: "Poppins-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: 13) }
    var normalFont:UIFont { return UIFont(name: "Poppins-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    var mediumFont:UIFont { return UIFont(name: "Poppins-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    var regularHelFont:UIFont { return UIFont(name: "HelveticaNeue-SemiBold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: 14) }
    var boldHelFont:UIFont { return UIFont(name: "HelveticaNeue-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: 13) }
    var normalHelFont:UIFont { return UIFont(name: "HelveticaNeue-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    var mediumHelFont:UIFont { return UIFont(name: "HelveticaNeue-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: 14)}
    var italicHelFont:UIFont { return UIFont(name: "HelveticaNeue-Italic", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    func bold(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldHelFont
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    func MediumFont(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : mediumHelFont
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    func ItalicFont(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : italicHelFont
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    //Helvetica Neue Italic
    func normal(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalHelFont,
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    func changeColor(_ value:String,color:UIColor) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .foregroundColor : color,
            .font : mediumFont
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    func regular(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : regularFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func astrickRed(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font               :  normalFont,
            .foregroundColor    : UIColor.red
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
//    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
//            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
//            let boundingBox = self.boundingRect(with: constraintRect,
//                                            options: .usesLineFragmentOrigin,
//                                                attributes: [.font: font], context: nil)
//
//            return ceil(boundingBox.width)
//        }
    
    
}

extension NSAttributedString {
    func replacing(placeholder:String, with valueString:String) -> NSAttributedString {
        if let range = self.string.range(of:placeholder) {
            let nsRange = NSRange(range,in:valueString)
            let mutableText = NSMutableAttributedString(attributedString: self)
            mutableText.replaceCharacters(in: nsRange, with: valueString)
            return mutableText as NSAttributedString
        }
        return self
    }
}

extension Optional where Wrapped == String {

    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }

}
extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}
enum DateFormat: String {//Apr 21 2023//2023-04-21
    case yyyyMMddHHmmssZ = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case MMMddyyyy = "MMM dd yyyy"
    case MMMddyyyyhhmmA = "MMM dd, yyyy | hh:mm a"
    case MMMMDDYYYY = "MMMM dd,yyyy"
    case DDMMMYYYY = "dd,MMM yyyy"
    case MMMMDD_YYYY = "MMMM dd, yyyy"
    case ddMMyyyy = "dd-MM-yyyy"
    case ddMMMyyyy = "dd-MMM-yyyy"
    case HHmm = "HH:mm"
    case hmma = "h:mm a"
    case hhmma = "hh:mm a"
    case yyyyMMdd = "yyyy-MM-dd"
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case DDMMM_YYYY = "dd MMM yyyy"
    case MMM_dd = "MMM dd"
    
}
/*
 2023-04-27T12:24:21.856Z
 */

