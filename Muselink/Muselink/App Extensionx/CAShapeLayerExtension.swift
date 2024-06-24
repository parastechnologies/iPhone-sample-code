//
//  CAShapeLayerExtension.swift
//  Muselink
//
//  Created by iOS TL on 05/10/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    func setAnimatedStroke(value:CGFloat) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
            self.strokeEnd = value
        }
    }
}
