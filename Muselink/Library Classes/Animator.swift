//
//  Animator.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 10/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
class AnimatorFactory {
    var propertyAnimator : UIViewPropertyAnimator?
    var popUpScale = 1.05
    var newValue   = 1.05
    @discardableResult
    func rotateRepeat(view: SoftUIView) -> UIViewPropertyAnimator? {
        propertyAnimator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0.0, options: [.curveLinear], animations: {
            view.transform = .init(scaleX: CGFloat(self.popUpScale), y: CGFloat(self.popUpScale))
        }, completion: { _ in
            if self.popUpScale == 1 {
                self.popUpScale = self.newValue
            }
            else {
                self.popUpScale = 1
            }
            self.rotateRepeat(view: view)
        })
        return propertyAnimator
    }
}
