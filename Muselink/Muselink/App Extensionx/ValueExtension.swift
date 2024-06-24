//
//  ValueExtension.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 09/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit

extension Int {
    func lowerDynamic()->CGFloat {
        return CGFloat(CGFloat(self)*(896/UIScreen.main.bounds.height))
    }
    func upperDynamic()->CGFloat {
        return CGFloat(CGFloat(self)*(UIScreen.main.bounds.height/896))
    }
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180.0
    }
}
extension CGFloat {
    func lowerDynamic()->CGFloat {
        return CGFloat(CGFloat(self)*(896/UIScreen.main.bounds.height))
    }
    func upperDynamic()->CGFloat {
        return CGFloat(CGFloat(self)*(UIScreen.main.bounds.height/896))
    }
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180.0
    }
}
extension Double {
    var toTimeString: String {
        let seconds: Int = Int(self.truncatingRemainder(dividingBy: 60.0))
        let minutes: Int = Int(self / 60.0)
        return String(format: "%d:%02d", minutes, seconds)
    }
}

