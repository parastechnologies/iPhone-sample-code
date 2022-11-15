//
//  UITextViewExtensions.swift
//  Muselink
//
//  Created by iOS TL on 27/07/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

extension UITextView {
    @discardableResult
    func resolveLocationTags(tagColor : UIColor = UIColor.paleGray)->[String] {

        // turn string in to NSString
        let nsText = NSString(string: self.text)
        var tagWords = [String]()
        // this needs to be an array of NSString.  String does not work.
        let words = nsText.components(separatedBy: CharacterSet(charactersIn: "@#ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_").inverted)

        // you can staple URLs onto attributed strings
        let attrString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font:self.font ?? UIFont.AvenirLTPRo_Regular(size: 16),NSAttributedString.Key.foregroundColor:textColor ?? .white])
        // tag each word if it has a hashtag
        for word in words {
            if word.count < 3 {
                continue
            }
            // found a word that is prepended by a hashtag!
            // homework for you: implement @mentions here too.
            if word.hasPrefix("@") {
                let stringifiedWord = word.dropFirst()
                tagWords.append(String(stringifiedWord))
                // a range is the character position, followed by how many characters are in the word.
                // we need this because we staple the "href" to this range.
                let matchRange:NSRange = nsText.range(of: word as String)
                        
                // search for word occurrence
                if (matchRange.length > 0) {
                    attrString.addAttribute(NSAttributedString.Key.link, value: "hash:\(stringifiedWord)", range: matchRange)
                }
            }
            if word.hasPrefix("#") {
                let stringifiedWord = word.dropFirst()
                tagWords.append(String(stringifiedWord))
                // a range is the character position, followed by how many characters are in the word.
                // we need this because we staple the "href" to this range.
                let matchRange:NSRange = nsText.range(of: word as String)
                        
                // search for word occurrence
                if (matchRange.length > 0) {
                    attrString.addAttribute(NSAttributedString.Key.link, value: "hash:\(stringifiedWord)", range: matchRange)
                }
            }
        }

        // we're used to textView.text
        // but here we use textView.attributedText
        // again, this will also wipe out any fonts and colors from the storyboard,
        // so remember to re-add them in the attrs dictionary above
        self.attributedText = attrString
        return tagWords
    }
}
