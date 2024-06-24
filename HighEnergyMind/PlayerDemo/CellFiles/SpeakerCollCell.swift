//
//  SpeakerCollCell.swift
//  HighEnergyMind
//
//  Created by iOS TL on 11/03/24.
//

import UIKit

class SpeakerCollCell: UICollectionViewCell {

    @IBOutlet weak var speakerImg               : CircleImageView!
    @IBOutlet weak var speakerName              : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: AudioFile) {
//        if i%2 == 0 {
//            speakerImg.image = UIImage(named: "speaker")
//            speakerName.text = "Mary Angela"
//        } else {
//            speakerImg.image = UIImage(named: "deleteAccount")
//            speakerName.text = "Esther"
//        }
        speakerImg.showImage(imgURL: data.speakerImg ?? "")
        speakerName.text = data.speakerName ?? ""
    }
}
