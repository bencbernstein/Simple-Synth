///
/// ShapeView.swift
///

import UIKit

enum EnvironmentType {
    case frog
    
    var key: Shape {
        switch self {
        case .frog:
            return .lilypad
        }
    }
    
    var backroundColor: UIColor {
        return Palette.backgroundColor(for: self)
    }
}

class Environment: UIView {
    
    let type: EnvironmentType
    var keyType: Shape { return type.key }
    
    init(type: EnvironmentType, frame: CGRect) {
        self.type = type
        super.init(frame: frame)
        
        self.backgroundColor = type.backroundColor
        
        layoutKeys()
    }
    
    func layoutKeys() {
        keyOrigins.forEach { origin in
            let key = ShapeGenerator(origin: origin, shape: keyType)
            self.addSubview(key)
        }
    }
    
    var keyOrigins: [CGPoint] {
        var origins: [CGPoint] = []
        let displacements: [CGFloat] = [-130, 0, 130]
        let centerOrigin = (frame.width / 2 - 50, frame.height / 2 - 50)
        displacements.forEach { xDisplacement in
            displacements.forEach { yDisplacement in
                let origin = CGPoint(x: centerOrigin.0 + CGFloat(xDisplacement), y: centerOrigin.1 + yDisplacement)
                origins.append(origin)
            }
        }
        return origins
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum Shape {
    case lilypad
    
    var size: CGSize {
        switch self {
        case .lilypad:
            return CGSize(width: 100, height: 100)
        }
    }
    
    var color: UIColor {
        return Palette.color(for: self)
    }
}

class ShapeGenerator: UIView {
    
    var shape: Shape
    
    init(origin: CGPoint, shape: Shape) {
        self.shape = shape
        let size = shape.size
        let frame = CGRect(origin: origin, size: size)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 1, alpha: 0.0)
        let random = CGFloat(arc4random_uniform(360))
        transform = CGAffineTransform(rotationAngle: random)
    }

    override func draw(_ rect: CGRect) {
        switch self.shape {
        case .lilypad:
            drawLilypad()
        }
    }
    
    func drawLilypad() {
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: (0, 50))
        context?.addLine(to: (30, 50))
        context?.addLine(to: (5, 35))
        context?.addCurve(to: (50, 0), control1: (5, 20), control2: (25, 0))
        context?.addCurve(to: (100, 50), control1: (80, 0), control2: (100, 20))
        context?.addCurve(to: (50, 100), control1: (100, 80), control2: (80, 100))
        context?.addCurve(to: (0, 50), control1: (20, 100), control2: (0, 80))

        context?.close(withFill: shape.color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
