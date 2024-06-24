//
//  UIVIewExtension.swift
//  WorkUp
//
//  Created by appsdeveloper Developer on 05/09/22.
//

import UIKit
import IBAnimatable

//View
extension UIView {
    
    var isAppeared: Bool { window != nil }

    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromMyView!
    }
    
 
    
    @objc func toImageView() -> UIImageView {
        let tempImageView = UIImageView()
        tempImageView.image = toImage()
        tempImageView.frame = frame
        tempImageView.contentMode = .scaleAspectFit
        return tempImageView
    }
    
    private static let kLayerNameGradientBorder = "GradientBorderLayer"

    func gradientBorder(width: CGFloat,
                        colors: [UIColor],
                        startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
                        endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0),
                        andRoundCornersWithRadius cornerRadius: CGFloat = 0) {

        let existingBorder = gradientBorderLayer()
        let border = existingBorder ?? CAGradientLayer()
        border.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y,
                              width: bounds.size.width + width, height: bounds.size.height + width)
        border.colors = colors.map { return $0.cgColor }
        border.startPoint = startPoint
        border.endPoint = endPoint

        let mask = CAShapeLayer()
        let maskRect = CGRect(x: bounds.origin.x + width/2, y: bounds.origin.y + width/2,
                              width: bounds.size.width - width, height: bounds.size.height - width)
        mask.path = UIBezierPath(roundedRect: maskRect, cornerRadius: cornerRadius).cgPath
        mask.fillColor      = UIColor.clear.cgColor
        mask.strokeColor    = UIColor.white.cgColor
        mask.lineWidth      = width
        border.mask         = mask

        let exists = (existingBorder != nil)
        if !exists {
            layer.addSublayer(border)
        }
    }
    private func gradientBorderLayer() -> CAGradientLayer? {
        let borderLayers = layer.sublayers?.filter { return $0.name == UIView.kLayerNameGradientBorder }
        if borderLayers?.count ?? 0 > 1 {
            fatalError()
        }
        return borderLayers?.first as? CAGradientLayer
    }

    
    
    func addGradientBackground() {
            let random = UIColor.random().cgColor
            let random2 = UIColor.random().cgColor

            let gradient = CAGradientLayer()
            gradient.frame = bounds
            gradient.colors = [random, random2]
            gradient.removeFromSuperlayer()
            layer.insertSublayer(gradient, at: 0)
        }
    
    
    func makeConstraints(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, topMargin: CGFloat, leftMargin: CGFloat, rightMargin: CGFloat, bottomMargin: CGFloat, width: CGFloat, height: CGFloat) {
          
          self.translatesAutoresizingMaskIntoConstraints = false
          if let top = top {
              self.topAnchor.constraint(equalTo: top, constant: topMargin).isActive = true
          }
          
          if let left = left {
              self.leftAnchor.constraint(equalTo: left, constant: leftMargin).isActive = true
          }
          
          if let right = right {
              self.rightAnchor.constraint(equalTo: right, constant: -rightMargin).isActive = true
          }
          
          if let bottom = bottom {
              self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomMargin).isActive = true
          }
          
          if width != 0 {
              self.widthAnchor.constraint(equalToConstant: width).isActive = true
          }
          
          if height != 0 {
              self.heightAnchor.constraint(equalToConstant: height).isActive = true
          }
      }
      
      func addSubviews(_ views: UIView...) {
          views.forEach{ addSubview($0) }
      }
    
    
    
    func makeClearViewWithShadow(
           cornderRadius: CGFloat,
           shadowColor: CGColor,
           shadowOpacity: Float,
           shadowRadius: CGFloat) {

           self.frame = self.frame.insetBy(dx: -shadowRadius * 2,
                                           dy: -shadowRadius * 2)
           self.backgroundColor = .clear
           let shadowView = UIView(frame: CGRect(
               x: shadowRadius * 2,
               y: shadowRadius * 2,
               width: self.frame.width - shadowRadius * 4,
               height: self.frame.height - shadowRadius * 4))
               shadowView.backgroundColor = .clear//.black
           shadowView.layer.cornerRadius = cornderRadius
           shadowView.layer.borderWidth = 1.0
           shadowView.layer.borderColor = UIColor.clear.cgColor

           shadowView.layer.shadowColor = shadowColor
           shadowView.layer.shadowOpacity = shadowOpacity
           shadowView.layer.shadowRadius = shadowRadius
           shadowView.layer.masksToBounds = false
           self.addSubview(shadowView)

           let p:CGMutablePath = CGMutablePath()
           p.addRect(self.bounds)
           p.addPath(UIBezierPath(roundedRect: shadowView.frame, cornerRadius: shadowView.layer.cornerRadius).cgPath)

           let s = CAShapeLayer()
           s.path = p
           s.fillRule = CAShapeLayerFillRule.evenOdd

          self.layer.mask = s
       }
    
    func roundCornersCustom(corners: UIRectCorner, radius: CGFloat, rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        layer.mask?.shadowColor = AppColor.app000000_11.cgColor
        layer.mask?.shadowOpacity = 0.7
        layer.mask?.shadowRadius = 3
        layer.mask?.shadowOffset = CGSize(width: 0, height: -5)
    }
    func takeScreenshot() -> UIImage? {

            // Begin context
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

            // Draw view in that context
            drawHierarchy(in: self.bounds, afterScreenUpdates: true)

            // And finally, get image
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            if (image != nil)
            {
                return image!
            }
            return UIImage()
        }
    
    func comingFromRight(containerView: UIView) {
        let offset = CGPoint(x: containerView.frame.maxX, y: 0)
        let x: CGFloat = 0, y: CGFloat = 0
        self.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        self.isHidden = false
        UIView.animate(
            withDuration: 1, delay: 0, usingSpringWithDamping: 0.47, initialSpringVelocity: 0,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
        })
    }
    
    func addBottomBorderColor(color: UIColor, width: CGFloat,size:CGRect) {
            let border = CALayer()
            border.removeFromSuperlayer()
            border.backgroundColor = color.cgColor
            border.frame = CGRect(x:0, y:self.frame.size.height + 4, width:self.frame.size.width + 20, height:width)
            self.layer.addSublayer(border)
    }

        func subviewsRecursive() -> [UIView] {
            return subviews + subviews.flatMap { $0.subviewsRecursive() }
        }
    
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
           let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           layer.mask = mask
       }
    
    var Border : UIView {
        self.layer.cornerRadius = self.frame.height/2 //2
        self.layer.masksToBounds = true
        return self
    }
    
//    var borderColour : UIView {
//        self.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255   , alpha:1 ).cgColor
//        self.layer.borderWidth = 1
//        return self
//    }
    
    
    @IBInspectable var borderCustomColor: UIColor?{
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get{
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    
    @IBInspectable var cornerInspect: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var cornerProportionalInspect: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = UIScreen.main.bounds.height/newValue
            layer.masksToBounds = UIScreen.main.bounds.height/newValue > 0
        }
    }
    
    @IBInspectable var borderWidInspect: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var shadowCustomColor: UIColor?{
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get{
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    
        @IBInspectable var shadowOpacityCustom: Float{
            set {
                layer.shadowOpacity = newValue
            }
            get{
                return layer.shadowOpacity
            }
        }
        
        @IBInspectable var shadowOffset: CGSize{
            set {
                layer.shadowOffset = newValue
            }
            get{
                return layer.shadowOffset
            }
        }
        
        @IBInspectable var shadowRadiusCustom: CGFloat{
            set {
                layer.shadowRadius = newValue
            }
            get{
                return layer.shadowRadius
            }
        }
        
        @IBInspectable var maskTobound:Bool{
            set {
                layer.masksToBounds = newValue
            }
            get {
                return layer.masksToBounds
            }
        }
 }

extension AnimatableTextView {
func leftSpace() {
    self.textContainerInset = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 4)
 }
    func leftSpaceWith(left:CGFloat) {
        self.textContainerInset = UIEdgeInsets(top: 4, left: left, bottom: 4, right: 4)
     }
}

class CircularProgressViewClock: UIView {
    
     var progressLayer     = CAShapeLayer()
    
    var progressReactLayer = CAShapeLayer()
    
    @IBInspectable var lineHeight: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var lineWidth: CGFloat = 10.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    
    @IBInspectable var lineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var pausePositions: [CGFloat] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    fileprivate var trackLayer = CAShapeLayer()
    
    fileprivate var didConfigureLabel = false
    
    fileprivate var rounded: Bool
    
    fileprivate var filled: Bool
    
    private var dotLayer: CALayer!
    
    var isReact = false
    
    var circleRect = CGRect()

    
    private var segmentViews: [UIView] = []

    
    var timeToFill = 3.43
    
    var progressColor = UIColor.white {
        didSet{
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var progressReactColor = UIColor.red {
        didSet{
            progressReactLayer.strokeColor = progressReactColor.cgColor
        }
    }
    
    var trackColor = UIColor.white {
        didSet{
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    
    var progress: Float {
        didSet{
            var pathMoved = progress - oldValue
            if pathMoved < 0{
                pathMoved = 0 - pathMoved
            }
            setProgress(duration: timeToFill * Double(pathMoved), to: progress)
        }
    }
    
    var newProgress :CGFloat = 0
    
    private var currentPauseProgress: CGFloat = 0.0
    
    var lineThickness: CGFloat = 4
    
    var lineLengthRatio: CGFloat = 0.95
    
    let pausedIndicatorLayer = CAShapeLayer()
    
    private var dashedLineLayer = CAShapeLayer()
    
    @IBInspectable var stepCount: Int = 12 {
          didSet {
              setNeedsDisplay()
          }
      }
      
     
    private var pausedIndicatorLayers: [CAShapeLayer] = []

    fileprivate func createProgressView(){

        self.backgroundColor = .clear

        self.layer.cornerRadius = frame.size.width / 2

        let circularPath = UIBezierPath(arcCenter: center, radius: frame.width / 2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)

        let circularPathReact = UIBezierPath(arcCenter: center, radius: frame.width / 2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)


//      let circularPath = UIBezierPath(arcCenter: center, radius: frame.width / 2, startAngle: CGFloat(1.5 * .pi), endAngle: CGFloat(-0.5 * .pi), clockwise: false)

        trackLayer.fillColor = UIColor.blue.cgColor

        trackLayer.path = circularPath.cgPath

        trackLayer.fillColor   = .none

        trackLayer.strokeColor = trackColor.cgColor
        if filled {
            trackLayer.lineCap = .butt
            trackLayer.lineWidth = frame.width
        }else{
            trackLayer.lineWidth = lineWidth
        }
        trackLayer.strokeEnd = 1
        
        layer.addSublayer(trackLayer)

        progressLayer.path = circularPath.cgPath
        
        progressLayer.fillColor = .none
        
        progressLayer.strokeColor = progressColor.cgColor

       // progressLayer.lineDashPattern = [6,4]

        progressReactLayer.path = circularPathReact.cgPath
        progressReactLayer.fillColor = .none
        progressReactLayer.strokeColor = progressReactColor.cgColor


        if filled {
            progressLayer.lineCap = .butt
            progressLayer.lineWidth = frame.width

            progressReactLayer.lineCap = .butt
            progressReactLayer.lineWidth = frame.width
        }else{
            progressLayer.lineWidth = lineWidth

            progressReactLayer.lineWidth = lineWidth

        }
        progressLayer.strokeEnd = 0

        progressReactLayer.strokeEnd = 0

        if rounded{

            progressLayer.lineCap       = .round

            progressReactLayer.lineCap  = .round
        }

        layer.addSublayer(progressReactLayer)

        layer.addSublayer(progressLayer)

    }
    
    
    func trackColorToProgressColor() -> Void{
        trackColor = progressColor
        trackColor = UIColor(red: progressColor.cgColor.components![0], green: progressColor.cgColor.components![1], blue: progressColor.cgColor.components![2], alpha: 0.2)
    }
    
    func setProgress(duration: TimeInterval = 1, to newProgress: Float) -> Void{
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = newProgress
        progressLayer.strokeEnd = CGFloat(newProgress)
        progressLayer.add(animation, forKey: "animationProgress")
        self.newProgress = CGFloat(newProgress)
        
     //updateDotPosition()
    }
    
    
    func updateLine(){
        
        let rect = self.circleRect
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - lineWidth
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + (2 * CGFloat.pi * CGFloat(newProgress))
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // Draw the pause lines
        for pausePosition in pausePositions {
            
            if pausePosition >= 0.0 && pausePosition <= 1.0 {
                
                let pauseAngle = startAngle + (2 * CGFloat.pi * pausePosition)
                
                let pauseLinePath = UIBezierPath()
                
                let pauseStartPoint = CGPoint(x: center.x + (radius - 2 * lineWidth) * cos(pauseAngle), y: center.y + (radius - 2 * lineWidth) * sin(pauseAngle))
                let pauseEndPoint = CGPoint(x: center.x + (radius + 2 * lineWidth) * cos(pauseAngle), y: center.y + (radius + 2 * lineWidth) * sin(pauseAngle))
                
                pauseLinePath.move(to: pauseStartPoint)
                pauseLinePath.addLine(to: pauseEndPoint)
                
                pauseLinePath.lineWidth = 2.0
                lineColor.setStroke()
                pauseLinePath.stroke()
            }
        }
    }
    
    func setReactProgress(duration: TimeInterval = 1, to newProgress: Float) -> Void {
        
            self.newProgress = CGFloat(newProgress)
        
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            
            animation.duration = duration
            
            animation.fromValue = progressReactLayer.strokeEnd
            
            animation.toValue = newProgress
            
            progressReactLayer.strokeEnd = CGFloat(newProgress)
            
            progressReactLayer.add(animation, forKey: "animationProgress")
        
    }
    
    override init(frame: CGRect){
        progress = 0
        rounded = true
        filled = false
        lineWidth = 15
        super.init(frame: frame)
        filled = false
        createProgressView()
      
        self.circleRect = frame
        
        let rect = frame
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - lineWidth
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + (2 * CGFloat.pi * newProgress)
        
        // Draw the progress arc with the specified line width and color
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        progressPath.lineWidth = lineWidth
        progressColor.setStroke()
        progressPath.stroke()
        
        // Draw the pause lines with the specified line height
        for pausePosition in pausePositions {
            if pausePosition >= 0.0 && pausePosition <= 1.0 {
                let pauseAngle = startAngle + (2 * CGFloat.pi * pausePosition)
                let pauseLinePath = UIBezierPath()
                
                let pauseStartPoint = CGPoint(x: center.x + (radius - lineHeight / 2) * cos(pauseAngle), y: center.y + (radius - lineHeight / 2) * sin(pauseAngle))
                let pauseEndPoint = CGPoint(x: center.x + (radius + lineHeight / 2) * cos(pauseAngle), y: center.y + (radius + lineHeight / 2) * sin(pauseAngle))
                
                pauseLinePath.move(to: pauseStartPoint)
                pauseLinePath.addLine(to: pauseEndPoint)
                
                pauseLinePath.lineWidth = lineHeight // Use the specified line height
                lineColor.setStroke()
                pauseLinePath.stroke()
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        progress = 0
        rounded = true
        filled = false
        lineWidth = 15
        super.init(coder: coder)
        createProgressView()
    }
    
    init(frame: CGRect, lineWidth: CGFloat?, rounded: Bool) {
        progress = 0
        if lineWidth == nil{
            self.filled = true
            self.rounded = false
        }else{
            if rounded{
                self.rounded = true
            }else{
                self.rounded = false
            }
            self.filled = false
        }
        self.lineWidth = lineWidth ?? 0
        super.init(frame: frame)
        createProgressView()
    }
    
    
    
    
//    func setupDotLayer() {
//        let dotSize: CGFloat = 3
//        let radius = min(bounds.width, bounds.height) / 2
//        let center = CGPoint(x: bounds.midX, y: bounds.midY)
//
//        let dotPositionX = center.x + radius * cos(CGFloat(progress) * 2 * .pi - .pi / 2)
//        let dotPositionY = center.y + radius * sin(CGFloat(progress) * 2 * .pi - .pi / 2)
//
//        dotLayer = CALayer()
//        dotLayer.bounds = CGRect(x: 0, y: 0, width: dotSize, height: dotSize)
//        dotLayer.position = CGPoint(x: dotPositionX, y: dotPositionY)
//        dotLayer.backgroundColor = UIColor.white.cgColor
//
//        progressLayer.addSublayer(dotLayer)
//    }
    
    
    func setDotPosition() {
        
        let radius = min(bounds.width, bounds.height) / 2
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let dotPositionX = center.x + radius * cos(CGFloat(newProgress) * 2 * .pi - .pi / 2)
        
        let dotPositionY = center.y + radius * sin(CGFloat(newProgress) * 2 * .pi - .pi / 2)
        
        print("Progress is.." , newProgress)
        
//        if newProgress <= 0.15 && newProgress < 0.16{
//            dotLayer.position = CGPoint(x: dotPositionX, y: dotPositionY+1)
//
//        }
//        else if newProgress <= 0.17 && newProgress > 0.16{
//            dotLayer.position = CGPoint(x: dotPositionX, y: dotPositionY+2)
//
//        }
//
//        else if newProgress <= 0.19 && newProgress > 0.17{
//            dotLayer.position = CGPoint(x: dotPositionX, y: dotPositionY+3)
//
//        }
//
//        else if newProgress <= 0.39 && newProgress > 0.19{
//            dotLayer.position = CGPoint(x: dotPositionX, y: dotPositionY+4.1)
//
//        }
//
//        else if newProgress <= 0.53 && newProgress > 0.39{
//            dotLayer.position = CGPoint(x: dotPositionX, y: dotPositionY+4.3)
//
//        }
//        else if newProgress <= 0.62 && newProgress > 0.53{
//            dotLayer.position = CGPoint(x: dotPositionX, y: dotPositionY+6.7)
//
//        }
//
//        else if newProgress <= 0.70 && newProgress > 0.62{
//            dotLayer.position = CGPoint(x: dotPositionX-3, y: dotPositionY+7.1)
//
//        }
//
//
//
//        else if newProgress <= 0.80 && newProgress > 0.70{
//            dotLayer.position = CGPoint(x: dotPositionX-4, y: dotPositionY+8.1)
//
//        }
//
//        else if newProgress <= 0.85 && newProgress > 0.80{
//            dotLayer.position = CGPoint(x: dotPositionX+4, y: dotPositionY+11)
//
//        }
//
//
//        else{
//            dotLayer.position = CGPoint(x: dotPositionX, y: dotPositionY)
//
//        }
        dotLayer.position = CGPoint(x: dotPositionX, y: dotPositionY)

        rotateDot()
    }
    
    func updateDotPosition() {
        let radius = min(bounds.width, bounds.height) / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let startAngle: CGFloat = -0.5 * .pi
        let endAngle: CGFloat = 1.5 * .pi
        let currentAngle = startAngle + CGFloat(newProgress) * (endAngle - startAngle)
        
        let dotPositionX = center.x + radius * cos(currentAngle)
        let dotPositionY = center.y + radius * sin(currentAngle)
        
        
        dotLayer.position = CGPoint(x: dotPositionX, y: dotPositionY)
    }
    
    private func calculateDotPosition() -> CGPoint {
        
        let radius = min(bounds.width, bounds.height) / 2
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
//        let dotPositionX = center.x + radius * cos(progressLayer.strokeEnd * 2 * CGFloat.pi - CGFloat.pi / 2)
        
//        let dotPositionY = center.y + radius * sin(progressLayer.strokeEnd * 2 * CGFloat.pi - CGFloat.pi / 2)
        
        let dotPositionX = center.x + radius * cos(newProgress * 2 * CGFloat.pi - CGFloat.pi / 2)
        
        let dotPositionY = center.y + radius * sin(newProgress * 2 * CGFloat.pi - CGFloat.pi / 2)
        
        print("newProgress is .",newProgress)
        
//        if newProgress >= 0.13 && newProgress < 0.32{
//            return CGPoint(x: dotPositionX, y: dotPositionY+2)
//
//        }
//
//         if newProgress >= 0.32 && newProgress < 0.39{
//            return CGPoint(x: dotPositionX, y: dotPositionY+3)
//        }
//
//        else if newProgress >= 0.39 && newProgress < 0.43{
//            return CGPoint(x: dotPositionX, y: dotPositionY+4.3)
//        }
//
//        else if newProgress >= 0.42 && newProgress < 0.49 {
//            return CGPoint(x: dotPositionX, y: dotPositionY+4)
//        }
//
//        else if newProgress >= 0.49 || newProgress < 0.53{
//            return CGPoint(x: dotPositionX, y: dotPositionY+6)
//
//        }
//        else if newProgress > 0.53 && newProgress < 0.56 {
//            return CGPoint(x: dotPositionX, y: dotPositionY+10)
//
//
//        }
//        else if newProgress > 0.56 && newProgress < 0.70 {
//            return CGPoint(x: dotPositionX, y: dotPositionY+12)
//        }
//
        return CGPoint(x: dotPositionX, y: dotPositionY)
        

    }
    
    func setupReactDotLayer() {
        
        let dotSize: CGFloat = 3//10
        
        dotLayer = CALayer()
        
        dotLayer.bounds = CGRect(x: 0, y: 0, width: dotSize, height: 6)//CGRect(x: 0, y: 0, width: dotSize, height: dotSize)
        
        dotLayer.position = calculateDotPosition()
        
        dotLayer.backgroundColor = UIColor.white.cgColor
        
        dotLayer.masksToBounds = true
        
        progressReactLayer.addSublayer(dotLayer)
    }
    
    private func calculatereactDotPosition() -> CGPoint {
        let radius = min(bounds.width, bounds.height) / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let dotPositionX = center.x + radius * cos(progressReactLayer.strokeEnd * 2 * CGFloat.pi - CGFloat.pi / 2)
        let dotPositionY = center.y + radius * sin(progressReactLayer.strokeEnd * 2 * CGFloat.pi - CGFloat.pi / 2)
        

        return CGPoint(x: dotPositionX, y: dotPositionY)
    }
    
    func setReactDotPosition(){
         dotLayer.position = calculatereactDotPosition()
        
         rotateDot()
    }
    
    func setupDotLayer() {
        let dotSize: CGFloat = 5
        dotLayer = CALayer()
        dotLayer.bounds = CGRect(x: 0, y: 0, width: dotSize, height: dotSize)
        dotLayer.backgroundColor = UIColor.white.cgColor
       // self.layer.addSublayer(dotLayer)
        progressLayer.addSublayer(dotLayer)
    }
    
    func rotateDot(){
        // Rotate the dot view based on the progress
        print(newProgress)
        let dotRotation = .pi * 2 * newProgress
        print("dotRotation is",dotRotation)
        dotLayer.transform = CATransform3DMakeRotation(CGFloat(dotRotation), 0, 0, 1)

    }
    
    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
           let x = center.x + radius * cos(angle)
           let y = center.y + radius * sin(angle)
           return CGPoint(x: x, y: y)
       }

}
extension UIColor {
    static func random() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}


public extension CGPoint {

    enum CoordinateSide {
        case topLeft, top, topRight, right, bottomRight, bottom, bottomLeft, left
    }

    static func unitCoordinate(_ side: CoordinateSide) -> CGPoint {
        switch side {
        case .topLeft:      return CGPoint(x: 0.0, y: 0.0)
        case .top:          return CGPoint(x: 0.5, y: 0.0)
        case .topRight:     return CGPoint(x: 1.0, y: 0.0)
        case .right:        return CGPoint(x: 0.0, y: 0.5)
        case .bottomRight:  return CGPoint(x: 1.0, y: 1.0)
        case .bottom:       return CGPoint(x: 0.5, y: 1.0)
        case .bottomLeft:   return CGPoint(x: 0.0, y: 1.0)
        case .left:         return CGPoint(x: 1.0, y: 0.5)
        }
    }
}


import UIKit

enum ChatBubbleStyle {
    
    case incoming
    
    case outgoing
    
}

class CustomChatBubbleView: UIView {
    
    var bubbleStyle: ChatBubbleStyle = .incoming {
        didSet {
            setNeedsLayout()
        }
    }
    
    private let bubbleLayer     = CAShapeLayer()
    
    private let gradientLayer   = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        layer.addSublayer(gradientLayer)
        gradientLayer.mask = bubbleLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureBubbleLayer()
    }
    

    private func configureBubbleLayer() {
        let path = UIBezierPath()
        let cornerRadius: CGFloat = 16.0
        let tailWidth: CGFloat = 10.0
        let tailHeight: CGFloat = 20.0
        
        switch bubbleStyle {
        case .incoming:
            path.move(to: CGPoint(x: tailWidth, y: bounds.height - cornerRadius))
            path.addLine(to: CGPoint(x: tailWidth, y: bounds.height - tailHeight))
            path.addLine(to: CGPoint(x: tailWidth + tailHeight, y: bounds.height - cornerRadius))
        case .outgoing:
            path.move(to: CGPoint(x: bounds.width - tailWidth, y: bounds.height - cornerRadius))
            path.addLine(to: CGPoint(x: bounds.width - tailWidth, y: bounds.height - tailHeight))
            path.addLine(to: CGPoint(x: bounds.width - tailWidth - tailHeight, y: bounds.height - cornerRadius))
        }
        
        path.addArc(withCenter: CGPoint(x: bounds.width - cornerRadius, y: bounds.height - cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi * 0.5), endAngle: 0.0, clockwise: true)
        path.addArc(withCenter: CGPoint(x: bounds.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: 0.0, endAngle: CGFloat(Double.pi * 1.5), clockwise: true)
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi * 1.5), endAngle: CGFloat(Double.pi), clockwise: true)
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: bounds.height - cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi * 0.5), clockwise: true)
        
        path.close()
        bubbleLayer.path = path.cgPath
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0).cgColor,
                                UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1.0).cgColor]
    }
}

import UIKit

@IBDesignable
class CircularProgressBarView: UIView {
    @IBInspectable var progress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var reactProgress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var stepCount: Int = 12 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineHeight: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 10.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var progressLineWidth: CGFloat = 10.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineColor: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var pausePositions: [CGFloat] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var pauseReactPositions: [CGFloat] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var trackColor: UIColor = UIColor.lightGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var progressColor: UIColor = UIColor.green {
        didSet {
            setNeedsDisplay()
        }
    }
    
//    @IBInspectable var progressReactColor: UIColor = UIColor.red {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
    
    @IBInspectable var progressReactColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
   var circleRect = CGRect()
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let radius = min(rect.width, rect.height) / 2 - lineWidth
        
        let startAngle = -CGFloat.pi / 2
        
        let endAngle = startAngle + (2 * CGFloat.pi * progress)
        
        // Draw the track arc with the specified line width and color
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackPath.lineWidth = progressLineWidth
        
        trackColor.setStroke()
        
        trackPath.stroke()
        
        // Calculate the progress end angle for the first progress layer
        let firstProgressEndAngle = startAngle + (2 * CGFloat.pi * progress)
        
        // Draw the first progress arc with the specified line width and color
        let firstProgressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: firstProgressEndAngle, clockwise: true)
        
        firstProgressPath.lineWidth = progressLineWidth
        
        progressColor.setStroke()
        
        firstProgressPath.stroke()
        
        // Check if the reactProgress is greater than 0 and less than or equal to 1
        if reactProgress > 0 && reactProgress <= 1 {
            // Calculate the progress end angle for the second progress layer
//            let secondProgressEndAngle = startAngle + (2 * CGFloat.pi * (progress + reactProgress))
            
            let secondProgressEndAngle = startAngle + (2 * CGFloat.pi * (reactProgress))
            
            // Draw the second progress arc with the specified line width and color
            let secondProgressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: firstProgressEndAngle, endAngle: secondProgressEndAngle, clockwise: true)
            
            secondProgressPath.lineWidth = progressLineWidth
            
            progressReactColor.setStroke()
            
            secondProgressPath.stroke()
        }
        
        // Draw the pause lines with the specified line height
        for pausePosition in pausePositions {
            if pausePosition >= 0.0 && pausePosition <= 1.0 {
                let pauseAngle = startAngle + (2 * CGFloat.pi * pausePosition)
                let pauseLinePath = UIBezierPath()
                
                let pauseStartPoint = CGPoint(x: center.x + (radius - lineHeight / 2) * cos(pauseAngle), y: center.y + (radius - lineHeight / 2) * sin(pauseAngle))
                let pauseEndPoint = CGPoint(x: center.x + (radius + lineHeight / 2) * cos(pauseAngle), y: center.y + (radius + lineHeight / 2) * sin(pauseAngle))
                
                pauseLinePath.move(to: pauseStartPoint)
                pauseLinePath.addLine(to: pauseEndPoint)
                
                pauseLinePath.lineWidth = lineHeight
                lineColor.setStroke()
                pauseLinePath.stroke()
            }
        }
    }

}

