//
//  AffOTDCollCell.swift
//  PlayerDemo
//
//  Created by iOS TL on 24/06/24.
//

import Foundation
import UIKit


class AffOTDCollCell: UICollectionViewCell {
    @IBOutlet weak var affOTDLbl                : UILabel!
    @IBOutlet weak var aotdTV                   : UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        let verticalInset = max((aotdTV.frame.height - aotdTV.contentSize.height) / 2, 0)
//        aotdTV.contentInset = UIEdgeInsets(top: verticalInset, left: 0, bottom: 0, right: 0)
//        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let verticalInset = max((aotdTV.frame.height - aotdTV.contentSize.height) / 2, 0)
        aotdTV.contentInset = UIEdgeInsets(top: verticalInset, left: 0, bottom: 0, right: 0)
    }
    
    func configureAffPlay(data: String) {
//        aotdTV.text = "I am thankful and grateful for the good in my life."
        aotdTV.text = data
    }
}
