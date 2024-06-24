//
//  Ext-UITextView.swift
//  HighEnergyMind
//
//  Created by iOS TL on 04/04/24.
//

import Foundation
import UIKit


extension UITextView {
    
    // ALIGN TEXT TO CENTER
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
