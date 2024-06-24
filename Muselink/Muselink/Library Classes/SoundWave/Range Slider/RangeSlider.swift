import UIKit
import QuartzCore
protocol RangeSliderDelegate {
    func update()
    func startTracking()
}
class RangeSlider: UIControl {
    let trackLayer = RangeSliderTrackLayer()
    let lowerThumbLayer = RangeSliderThumbLayer_Lower()
    let upperThumbLayer = RangeSliderThumbLayer_Upper()
    var delegate  : RangeSliderDelegate?
    var range_Btn  = UIButton()
    var previousLocation = CGPoint()
    var minimumValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    var maximumValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    var lowerValue: Double = Double(0.5){
        didSet {
            updateLayerFrames()
        }
    }
    var upperValue: Double = Double(0.6) {
        didSet {
            updateLayerFrames()
        }
    }
    var thumbTintColor_Lower: UIColor = UIColor.skyBlue {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    var trackTintColor: UIColor = UIColor.clear {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }

    var trackHighlightTintColor: UIColor = UIColor(red: 0.0, green: 211/255, blue: 1, alpha: 0.3) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    var thumbTintColor_Upper: UIColor = UIColor(red: 247/255, green: 71/255, blue: 208/255, alpha: 1.0) {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    var curvaceousness: CGFloat = 1.0 {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    var thumbWidth: CGFloat {
        return CGFloat(10)
    }
    var thumbHeight: CGFloat {
        return CGFloat(bounds.height)
    }
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.rangeSlider = self
        lowerThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(lowerThumbLayer)

        upperThumbLayer.rangeSlider = self
        upperThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(upperThumbLayer)
        
        range_Btn.setBackgroundImage(#imageLiteral(resourceName: "movingKnot"), for: .normal)
        range_Btn.titleLabel?.font = UIFont.Avenir_Medium(size: 12)
        range_Btn.setTitleColor(.white, for: .normal)
        range_Btn.isUserInteractionEnabled = false
        addSubview(range_Btn)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }

    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        trackLayer.frame = CGRect(x: 0, y: 25, width: bounds.width, height: bounds.height/2 - 25)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(value: lowerValue))

        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 20, width: thumbWidth, height: thumbHeight-40)
        lowerThumbLayer.setNeedsDisplay()

        let upperThumbCenter = CGFloat(positionForValue(value: upperValue))
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 20,
            width: thumbWidth, height: thumbHeight-20)
        upperThumbLayer.setNeedsDisplay()
        
        range_Btn.frame = CGRect(x: upperThumbCenter - thumbWidth, y: thumbHeight-25,
                                 width: thumbWidth*2, height: 25)
        let rangeWidth = Int((upperValue - 0.5)*100)
        range_Btn.setTitle("\(rangeWidth)", for: .normal)
        CATransaction.commit()
    }

    func positionForValue(value: Double) -> Double {
        _ = Double(thumbWidth)
        return Double(bounds.width - thumbWidth) * (value - minimumValue) /
            (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
    }

    // Touch handlers
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)

        // Hit test the thumb layers
        upperThumbLayer.highlighted = true
        delegate?.startTracking()
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }

    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)

        // 1. Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - bounds.height)
        previousLocation = location
        // 2. Update the values
        if upperThumbLayer.highlighted {
            upperValue += deltaValue
            upperValue = boundValue(value: upperValue, toLowerValue: 0.55, upperValue: 0.65)
        }
        return true
    }
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        upperThumbLayer.highlighted = false
        delegate?.update()
    }
}
