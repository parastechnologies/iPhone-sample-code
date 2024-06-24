//
//  UISliderExtension.swift
//  WorkUp
//
//  Created by appsdeveloper Developer on 26/09/22.
//

import UIKit
import IBAnimatable
@IBDesignable
class CustomSlider: AnimatableSlider {
    /// custom slider track height
    @IBInspectable var trackHeight: CGFloat = 3

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Use properly calculated rect
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
    
    override func awakeFromNib() {
        self.setThumbImage(UIImage(named: "slider_img"), for: .normal)
        super.awakeFromNib()
    }
    
    
    
//    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
//        let unadjustedThumbrect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
//        let thumbOffsetToApplyOnEachSide:CGFloat = unadjustedThumbrect.size.width / 2.0
//        let minOffsetToAdd = -thumbOffsetToApplyOnEachSide
//        let maxOffsetToAdd = thumbOffsetToApplyOnEachSide
//        let offsetForValue = minOffsetToAdd + (maxOffsetToAdd - minOffsetToAdd) * CGFloat(value / (self.maximumValue - self.minimumValue))
//        var origin = unadjustedThumbrect.origin
//        origin.x += offsetForValue
//        return CGRect(origin: origin, size: unadjustedThumbrect.size)
//    }
    
    
//    func tapAndSlide(gesture: UILongPressGestureRecognizer) {
//        let pt           = gesture.location(in: self)
//        let thumbWidth   = self.thumbRect().size.width
//        var value: Float = 0
//
//        if (pt.x <= self.thumbRect().size.width / 2)
//        {
//            value = self.minimumValue
//        }
//        else if (pt.x >= self.bounds.size.width - thumbWidth / 2)
//        {
//            value = self.maximumValue
//        }
//        else
//        {
//            let percentage = Float((pt.x - thumbWidth / 2) / (self.bounds.size.width - thumbWidth))
//            let delta      = percentage * (self.maximumValue - self.minimumValue)
//
//            value          = self.minimumValue + delta
//        }
//
//        if (gesture.state == UIGestureRecognizer.State.began)
//        {
//            UIView.animate(withDuration: 0.35, delay: 0, options: UIView.AnimationOptions.curveEaseInOut,
//                                       animations:
//                                        {
//                self.setValue(value, animated: true)
//                super.sendActions(for: UIControl.Event.valueChanged)
//            },
//                                       completion: nil)
//        }
//        else
//        {
//            self.setValue(value, animated: false)
//        }
//    }
//    
//    func thumbRect() -> CGRect
//    {
//        return self.thumbRect(forBounds: self.bounds, trackRect: self.bounds, value: self.value)
//    }
    
    
    ///EZSE: Slider moving to value with animation duration
//    public func setValueWithAnimation(value: Float, duration: Double) {
//
//
//        self.setValue(value, animated: true)
//
//
//        //           UIView.animate(withDuration: duration, animations: { () -> Void in
//        //             //  self.setValue(self.value, animated: true)
//        //
//        //           }) { (bol) -> Void in
//        //               UIView.animate(withDuration: duration, animations: { () -> Void in
//        //                   self.setValue(value, animated: true)
//        //               }, completion: nil)
//        //           }
//    }
}

