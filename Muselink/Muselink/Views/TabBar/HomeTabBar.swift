//
//  HomeTabBar.swift
//  Muselink
//
//  Created by appsDev on 04/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit

@IBDesignable
public class HomeTabBar: UITabBar {
    @IBInspectable public var animated: Bool = true
    @IBInspectable public var shadowColor: UIColor = UIColor(white: 1, alpha: 1)  {
        didSet {
            layoutIfNeeded()
        }
    }
    @IBInspectable public var shadowRadius: CGFloat = 10  {
        didSet {
            layoutIfNeeded()
        }
    }
    private var shapeLayer: CALayer?
    private var circleLayer: CALayer?
    public var containerInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    fileprivate var selectedIndex = -1
    //MARK:- Methodes
    private func addBackgroundShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.shadowColor = shadowColor.cgColor
        shapeLayer.shadowRadius = shadowRadius
        shapeLayer.shadowOffset = .zero
        shapeLayer.shadowOpacity = 1.0
        shapeLayer.fillColor = UIColor(red: 232/255, green: 231/255, blue: 244/255, alpha: 1.0).cgColor
        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    override public func draw(_ rect: CGRect) {
        addBackgroundShape()
    }
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        let height = CGFloat(60+bottomPadding)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = height
        return sizeThatFits
    }
    override public func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    private func createPath() -> CGPath {
        //Properties
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        let path = UIBezierPath()
        let height = CGFloat(80+(bottomPadding))
        
        let firstCorner = CGPoint(x: containerInsets.left, y: containerInsets.top)
        let secondCorner = CGPoint(x: containerInsets.left, y: height - containerInsets.bottom )
        let thirdCorner = CGPoint(x: bounds.width - containerInsets.right, y: height - containerInsets.bottom)
        let fourthCorner = CGPoint(x: bounds.width - containerInsets.right, y: containerInsets.top)
        
        //Curve Points
        let startPoint = CGPoint(x: firstCorner.x + 30, y: firstCorner.y)
        let firstPoint = CGPoint(x: firstCorner.x, y:  firstCorner.y + 30)
        let secondCurvePoint1 = CGPoint(x: secondCorner.x, y: secondCorner.y)
        let secondCurvePoint2 = CGPoint(x: secondCorner.x, y: secondCorner.y)
        let thirdCurvePoint1 = CGPoint(x: thirdCorner.x, y: thirdCorner.y)
        let thirdCurvePoint2 = CGPoint(x: thirdCorner.x, y: thirdCorner.y)
        let endCurvePoint1 = CGPoint(x: fourthCorner.x, y:  fourthCorner.y + 30)
        let endPoint = CGPoint(x: fourthCorner.x - 30, y: fourthCorner.y)
        
        //Draw
        path.move(to: startPoint)
        path.addQuadCurve(to: firstPoint, controlPoint: firstCorner)
        path.addLine(to: secondCurvePoint1)
        path.addQuadCurve(to: secondCurvePoint2, controlPoint: secondCorner)
        path.addLine(to: thirdCurvePoint1)
        path.addQuadCurve(to: thirdCurvePoint2, controlPoint: thirdCorner)
        path.addLine(to: endCurvePoint1)
        path.addQuadCurve(to: endPoint, controlPoint: fourthCorner)
        path.addLine(to: startPoint)
        path.close()
        
        return path.cgPath
    }
    private func hideLabel(barItem: UITabBarItem, hidden: Bool) {
        if let itemView = (barItem.value(forKey: "view") as? UIView) {
            if let titleLabel = itemView.subviews.last {
                titleLabel.isHidden = hidden
            }
        }
    }
}
extension UITabBarController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
extension HomeTabBar : UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            if  selectedIndex == tabBarController.selectedIndex && selectedIndex == 0 {
                selectedIndex = -1
                tabBarController.dismiss(animated: false, completion: nil)
            }
            else {
                selectedIndex = tabBarController.selectedIndex
            }
        }
        else if AppSettings.hasLogin {
            selectedIndex = tabBarController.selectedIndex
        }
        else {
            tabBarController.selectedIndex = 0
            let storyBoard = UIStoryboard(name: "Registration", bundle: .main)
            let VC = storyBoard.instantiateViewController(withIdentifier: "RegistrationNavVC")
            VC.modalPresentationStyle = .custom
            VC.transitioningDelegate = tabBarController
            tabBarController.present(VC, animated: true, completion: nil)
        }
    }
}
