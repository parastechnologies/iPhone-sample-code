//
//  ProgressBarView.swift
//  progressBar
//
//  Created by ashika shanthi on 1/4/18.
//  Copyright © 2018 ashika shanthi. All rights reserved.
//

import UIKit
class ProgressBarView: UIView {
    
    var bgPath: UIBezierPath!
    var shapeLayer: CAShapeLayer!
    var progressLayer: CAShapeLayer!
    var progress: Float = 0 {
        willSet(newValue) {
            progressLayer.strokeEnd = CGFloat(newValue)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgPath = UIBezierPath()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bgPath = UIBezierPath()
    }
    func simpleShape(color : UIColor) {
        bgPath = UIBezierPath()
        createCirclePath()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath.cgPath
        shapeLayer.lineWidth = 8
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.paleGray.cgColor
        shapeLayer.shadowRadius = 2
        shapeLayer.shadowOpacity = 1
        shapeLayer.shadowOffset = CGSize( width: 2, height: 2)
        shapeLayer.shadowColor = UIColor(red: 223/255, green: 228/255, blue: 238/255, alpha: 1.0).cgColor
        
        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 8
        progressLayer.fillColor = nil
        progressLayer.strokeColor = color.cgColor
        progressLayer.strokeEnd = 0.0
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(progressLayer)
    }
    func simpleHalfShape(strokeColor:UIColor = UIColor.paleGray,shadowColor:UIColor = UIColor(red: 0.8196078431, green: 0.8039215686, blue: 0.7803921569, alpha: 1)) {
        createHalfCirclePath()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath.cgPath
        shapeLayer.lineWidth = 8
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.shadowRadius = 2
        shapeLayer.shadowOpacity = 1
        shapeLayer.shadowOffset = CGSize( width: 4, height: 4)
        shapeLayer.shadowColor = shadowColor.cgColor
        
        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 4
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.brightPurple.cgColor
        progressLayer.strokeEnd = 0.0
        
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(progressLayer)
    }
    
    private func createCirclePath() {
        let x = self.frame.width/2
        let y = self.frame.height/2
        let center = CGPoint(x: x, y: y)
        bgPath.addArc(withCenter: center, radius: x, startAngle: CGFloat(4.71), endAngle: CGFloat(4.70), clockwise: true)
        bgPath.close()
    }
    private func createHalfCirclePath() {
        let x = self.frame.width/2
        let y = self.frame.height/2
        let center = CGPoint(x: x, y: y+20)
        bgPath.addArc(withCenter: center, radius: y+10, startAngle: CGFloat(2.4), endAngle: CGFloat(7.05), clockwise: true)
    }
}
