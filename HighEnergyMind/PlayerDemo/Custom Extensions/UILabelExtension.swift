//
//  UILabelExtension.swift
//  WorkUp
//
//  Created by appsdeveloper Developer on 05/09/22.
//

import UIKit
extension UILabel {
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
               let readMoreText: String = trailingText + moreText

               let lengthForVisibleString: Int = self.vissibleTextLength
               let mutableString: String = self.text!
               let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
               let readMoreLength: Int = (readMoreText.count)
               let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font ?? .systemFont(ofSize: 15)])
               let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
               answerAttributed.append(readMoreAttributed)
               self.attributedText = answerAttributed
           }

           var vissibleTextLength: Int {
               let font: UIFont = self.font
               let mode: NSLineBreakMode = self.lineBreakMode
               let labelWidth: CGFloat = self.frame.size.width
               let labelHeight: CGFloat = self.frame.size.height
               let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

               let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
               let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
               let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

               if boundingRect.size.height > labelHeight {
                   var index: Int = 0
                   var prev: Int = 0
                   let characterSet = CharacterSet.whitespacesAndNewlines
                   repeat {
                       prev = index
                       if mode == NSLineBreakMode.byCharWrapping {
                           index += 1
                       } else {
                           index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                       }
                   } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
                   return prev
               }
               return self.text!.count
           }
    
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
    func textHeight(withWidth width: CGFloat) -> CGFloat {
          guard let text = text else {
             return 0
          }
        return text.height(withConstrainedWidth: UIScreen.main.bounds.width, font: UIFont.init(name: "Poppins-Medium", size: 14)!)
       }
    
    
    var isTruncated: Bool {
          frame.width < intrinsicContentSize.width
       }

       var isClipped: Bool {
           frame.height < intrinsicContentSize.height
       }
        
}


enum TrailingContent {
    case readmore
    case readless

    var text: String {
        switch self {
        case .readmore: return "...Read More"
        case .readless: return " Read Less"
        }
    }
}

extension UILabel {

    private var minimumLines: Int { return 2 }
    private var highlightColor: UIColor { return .red }

    private var attributes: [NSAttributedString.Key: Any] {
        return [.font: UIFont(name: "ProximaNova-Bold", size: 15) ?? .systemFont(ofSize: 18)]
    }
    
    public func requiredHeight(for text: String) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = minimumLines
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
      }

    func highlight(_ text: String, color: UIColor) {
        guard let labelText = self.text else { return }
        let range = (labelText as NSString).range(of: text)

        let mutableAttributedString = NSMutableAttributedString.init(string: labelText)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.attributedText = mutableAttributedString
    }

    func appendReadmore(after text: String, trailingContent: TrailingContent) {
        self.numberOfLines = minimumLines
        let fourLineText = "\n\n\n"
        let fourlineHeight = requiredHeight(for: fourLineText)
        let sentenceText = NSString(string: text)
        let sentenceRange = NSRange(location: 0, length: sentenceText.length)
        var truncatedSentence: NSString = sentenceText
        var endIndex: Int = sentenceRange.upperBound
        let size: CGSize = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        while truncatedSentence.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.height >= fourlineHeight {
            if endIndex == 0 {
                break
            }
            endIndex -= 1
            truncatedSentence = NSString(string: sentenceText.substring(with: NSRange(location: 0, length: endIndex)))
            truncatedSentence = (String(truncatedSentence) + trailingContent.text) as NSString
        }
        self.text = truncatedSentence as String
        self.highlight(trailingContent.text, color: highlightColor)
    }

    func appendReadLess(after text: String, trailingContent: TrailingContent) {
        self.numberOfLines = 0
        self.text = text + trailingContent.text
        self.highlight(trailingContent.text, color: highlightColor)
    }
}
