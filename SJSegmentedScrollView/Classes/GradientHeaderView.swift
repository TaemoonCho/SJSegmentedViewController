
import UIKit

struct GradientAttribute {
    var startLocation: Float
    var endLocation: Float
    var startColor: UIColor
    var endColor: UIColor

    var colors: [CGColor] {
        get {
            return [startColor.CGColor, endColor.CGColor]
        }
    }
    
    var locations: [NSNumber] {
        get {
            return [NSNumber(float: startLocation), NSNumber(float: endLocation)]
        }
    }
    
    init() {
        startLocation = 0.0
        endLocation = 1.0
        startColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        endColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.0)
    }
    
}

final class GradientHeaderView: UIView {
    
    var gradientLayer = CAGradientLayer()
        {
        willSet {
            gradientLayer.removeFromSuperlayer()
        }
        didSet {
            self.layer.insertSublayer(gradientLayer, atIndex: 0)
            reloadLayers()
        }
    }
    
    var attribute: GradientAttribute = GradientAttribute()
        {
        didSet {
            reloadLayers()
        }
    }
    
    override var frame: CGRect {
        didSet {
            gradientLayer.frame = frame
            reloadLayers()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        attribute = GradientAttribute()
        gradientLayer = gradientLayerWithAttribute(attribute)
        self.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func gradientLayerWithAttribute(attribute: GradientAttribute) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.locations = attribute.locations
        layer.colors = attribute.colors
        return layer
    }
    
    private func reloadLayers() {
        setNeedsDisplay()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func changeStartColor(startColor: UIColor) {
        attribute.startColor = startColor
        gradientLayer.colors = attribute.colors
        reloadLayers()
    }
    
    func changeEndColor(endColor: UIColor) {
        attribute.endColor = endColor
        gradientLayer.colors = attribute.colors
        reloadLayers()
    }
    
    func changeEndLocation(endLocation: Float) {
        attribute.endLocation = endLocation
        gradientLayer.locations = attribute.locations
        reloadLayers()
    }
}
