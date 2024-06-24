//
//  ScrollViewExtension.swift
//  WorkUp
//
//  Created by Gursewak Singh on 07/07/23.
//

import Foundation

import Foundation
import UIKit

extension UIScrollView {
    enum ScrollDirection {
        case up, down, unknown
    }
    
    var scrollDirection: ScrollDirection {
        guard let superview = superview else { return .unknown }
        return panGestureRecognizer.translation(in: superview).y > 0 ? .up : .down
    }
    
    var isReachedBottom: Bool {
        if (contentOffset.y >= (contentSize.height - frame.size.height)) {
            //reach bottom
            return true
        }
        return false
    }
    
    var isReachedTop: Bool {
        if (contentOffset.y <= 0){
            //reach top
            return true
        }
        return false
    }
}
