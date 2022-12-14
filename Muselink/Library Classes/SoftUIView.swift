//
//  SoftUIView.swift
//
import UIKit

enum SoftUIViewType: Int {
    case pushButton
    case toggleButton
    case normal
}
class SoftUIView: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubLayers()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createSubLayers()
    }
    func setContentView(_ contentView: UIView?) {
        resetContentView(contentView)
    }
    func setContentView(_ contentView: UIView?,
                              selectedContentView: UIView?) {
        resetContentView(contentView,
                         selectedContentView: selectedContentView,
                         selectedTransform: nil)
    }
    func setContentView(_ contentView: UIView?,
                             selectedTransform: CGAffineTransform) {
        resetContentView(contentView,
                         selectedContentView: nil,
                         selectedTransform: selectedTransform)
    }
    func setContentView(_ contentView: UIView?,
                             selectedContentView: UIView? = nil,
                             selectedTransform: CGAffineTransform? = CGAffineTransform.init(scaleX: 0.95, y: 0.95)) {

        resetContentView(contentView,
                         selectedContentView: selectedContentView,
                         selectedTransform: selectedTransform)
    }
    var type: SoftUIViewType = .pushButton {
        didSet { updateShadowLayers() }
    }

    var mainColor: CGColor = SoftUIView.defalutMainColorColor {
        didSet { updateMainColor() }
    }

    var darkShadowColor: CGColor = SoftUIView.defalutDarkShadowColor {
        didSet { updateDarkShadowColor() }
    }

    var lightShadowColor: CGColor = SoftUIView.defalutLightShadowColor {
        didSet { updateLightShadowColor() }
    }

    var shadowOffset: CGSize = SoftUIView.defalutShadowOffset {
        didSet { updateShadowOffset() }
    }

    var shadowOpacity: Float = SoftUIView.defalutShadowOpacity {
        didSet { updateShadowOpacity() }
    }

    var shadowRadius: CGFloat = SoftUIView.defalutShadowRadius {
        didSet { updateShadowRadius() }
    }
    var cornerRadius: CGFloat = SoftUIView.defalutCornerRadius {
        didSet { updateSublayersShape() }
    }
    var borderColor: CGColor = SoftUIView.defalutBorderColor {
        didSet { updateBackgroundLayerBorder() }
    }
    var borderWidth: CGFloat = SoftUIView.defalutBorderWidth {
        didSet { updateBackgroundLayerBorder() }
    }
    override var bounds: CGRect {
        didSet { updateSublayersShape() }
    }
    override var isSelected: Bool {
        didSet {
            updateShadowLayers()
            updateContentView()
        }
    }
    override var backgroundColor: UIColor? {
        get { .clear }
        set { }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .pushButton:
            isSelected = true
        case .toggleButton:
            isSelected = !isSelected
        case .normal:
            break
        }
        super.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .pushButton:
            isSelected = isTracking
        case .normal, .toggleButton:
            break
        }
        super.touchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .pushButton:
            isSelected = false
        case .normal, .toggleButton:
            break
        }
        super.touchesEnded(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .pushButton:
            isSelected = false
        case .normal, .toggleButton:
            break
        }
        super.touchesCancelled(touches, with: event)
    }

    private var backgroundLayer: CALayer!
    private var darkOuterShadowLayer: CAShapeLayer!
    private var lightOuterShadowLayer: CAShapeLayer!
    private var darkInnerShadowLayer: CAShapeLayer!
    private var lightInnerShadowLayer: CAShapeLayer!

    private var contentView: UIView?
    private var selectedContentView: UIView?
    private var selectedTransform: CGAffineTransform?
}

extension SoftUIView {
    public static let defalutMainColorColor: CGColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    public static let defalutDarkShadowColor: CGColor = #colorLiteral(red: 0.8196078431, green: 0.8039215686, blue: 0.7803921569, alpha: 1)
    public static let defalutLightShadowColor: CGColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    public static let defalutShadowOffset: CGSize = .init(width: 6, height: 6)
    public static let defalutShadowOpacity: Float = 1
    public static let defalutShadowRadius: CGFloat = 5
    public static let defalutCornerRadius: CGFloat = 10
    public static let defalutBorderWidth: CGFloat = 0
    public static let defalutBorderColor: CGColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
}

extension SoftUIView {
    func createSubLayers() {
        lightOuterShadowLayer = {
            let shadowLayer = createOuterShadowLayer(shadowColor: lightShadowColor, shadowOffset: shadowOffset.inverse)
            layer.addSublayer(shadowLayer)
            return shadowLayer
        }()
        darkOuterShadowLayer = {
            let shadowLayer = createOuterShadowLayer(shadowColor: darkShadowColor, shadowOffset: shadowOffset)
            layer.addSublayer(shadowLayer)
            return shadowLayer
        }()
        backgroundLayer = {
            let backgroundLayer = CALayer()
            layer.addSublayer(backgroundLayer)
            backgroundLayer.frame = bounds.insetBy(dx: -2, dy: -2)
            backgroundLayer.cornerRadius = cornerRadius
            backgroundLayer.backgroundColor = mainColor
            backgroundLayer.borderColor = borderColor
            backgroundLayer.borderWidth  = borderWidth
            return backgroundLayer
        }()
        darkInnerShadowLayer = {
            let shadowLayer = createInnerShadowLayer(shadowColor: darkShadowColor, shadowOffset: shadowOffset)
            layer.addSublayer(shadowLayer)
            shadowLayer.isHidden = true
            return shadowLayer
        }()
        lightInnerShadowLayer = {
            let shadowLayer = createInnerShadowLayer(shadowColor: lightShadowColor, shadowOffset: shadowOffset.inverse)
            layer.addSublayer(shadowLayer)
            shadowLayer.isHidden = true
            return shadowLayer
        }()
        updateSublayersShape()
    }
    func createOuterShadowLayer(shadowColor: CGColor, shadowOffset: CGSize) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = mainColor
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        return layer
    }
    func createOuterShadowPath() -> CGPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
    func createInnerShadowLayer(shadowColor: CGColor, shadowOffset: CGSize) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = mainColor
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.fillRule = .evenOdd
        return layer
    }
    func createInnerShadowPath() -> CGPath {
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: -100, dy: -100), cornerRadius: cornerRadius)
        path.append(UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius))
        return path.cgPath
    }
    func createInnerShadowMask() -> CALayer {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        return layer
    }
    func updateSublayersShape() {
        backgroundLayer.frame = bounds.insetBy(dx: -2, dy: -2)
        backgroundLayer.cornerRadius = cornerRadius
        darkOuterShadowLayer.path = createOuterShadowPath()
        lightOuterShadowLayer.path = createOuterShadowPath()
        darkInnerShadowLayer.path = createInnerShadowPath()
        darkInnerShadowLayer.mask = createInnerShadowMask()
        lightInnerShadowLayer.path = createInnerShadowPath()
        lightInnerShadowLayer.mask = createInnerShadowMask()
    }
    func resetContentView(_ contentView: UIView?,
                          selectedContentView: UIView? = nil,
                          selectedTransform: CGAffineTransform? = CGAffineTransform.init(scaleX: 0.95, y: 0.95)) {

        self.contentView.map {
            $0.transform = .identity
            $0.removeFromSuperview()
        }
        self.selectedContentView.map { $0.removeFromSuperview() }
        contentView.map {
            $0.isUserInteractionEnabled = false
            addSubview($0)
        }
        selectedContentView.map {
            $0.isUserInteractionEnabled = false
            addSubview($0)
        }
        self.contentView = contentView
        self.selectedContentView = selectedContentView
        self.selectedTransform = selectedTransform
        updateContentView()
    }
    func updateContentView() {
        if isSelected, selectedContentView != nil {
            showSelectedContentView()
        } else if isSelected, selectedTransform != nil {
            showSelectedTransform()
        } else {
            showContentView()
        }
    }
    func showContentView() {
        contentView?.isHidden = false
        contentView?.transform = .identity
        selectedContentView?.isHidden = true
    }
    func showSelectedContentView() {
        contentView?.isHidden = true
        contentView?.transform = .identity
        selectedContentView?.isHidden = false
    }
    func showSelectedTransform() {
        contentView?.isHidden = false
        selectedTransform.map { contentView?.transform = $0 }
        selectedContentView?.isHidden = true
    }
    func updateMainColor() {
        backgroundLayer.backgroundColor = mainColor
        darkOuterShadowLayer.fillColor = mainColor
        lightOuterShadowLayer.fillColor = mainColor
        darkInnerShadowLayer.fillColor = mainColor
        lightInnerShadowLayer.fillColor = mainColor
    }
    func updateDarkShadowColor() {
        darkOuterShadowLayer.shadowColor = darkShadowColor
        darkInnerShadowLayer.shadowColor = darkShadowColor
    }
    func updateLightShadowColor() {
        lightOuterShadowLayer.shadowColor = lightShadowColor
        lightInnerShadowLayer.shadowColor = lightShadowColor
    }
    func updateShadowOffset() {
        darkOuterShadowLayer.shadowOffset = shadowOffset
        lightOuterShadowLayer.shadowOffset = shadowOffset.inverse
        darkInnerShadowLayer.shadowOffset = shadowOffset
        lightInnerShadowLayer.shadowOffset = shadowOffset.inverse
    }
    func updateShadowOpacity() {
        darkOuterShadowLayer.shadowOpacity = shadowOpacity
        lightOuterShadowLayer.shadowOpacity = shadowOpacity
        darkInnerShadowLayer.shadowOpacity = shadowOpacity
        lightInnerShadowLayer.shadowOpacity = shadowOpacity
    }
    func updateShadowRadius() {
        darkOuterShadowLayer.shadowRadius = shadowRadius
        lightOuterShadowLayer.shadowRadius = shadowRadius
        darkInnerShadowLayer.shadowRadius = shadowRadius
        lightInnerShadowLayer.shadowRadius = shadowRadius
    }
    func updateShadowLayers() {
        darkOuterShadowLayer.isHidden = isSelected
        lightOuterShadowLayer.isHidden = isSelected
        darkInnerShadowLayer.isHidden = !isSelected
        lightInnerShadowLayer.isHidden = !isSelected
    }
    func updateBackgroundLayerBorder() {
        backgroundLayer.borderColor = borderColor
        backgroundLayer.borderWidth = borderWidth
    }
}
extension CGSize {
    var inverse: CGSize {
        .init(width: -1 * width, height: -1 * height)
    }
}
