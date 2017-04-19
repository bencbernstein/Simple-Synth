///
/// Shape.swift
///

import UIKit

enum ShapeType {
    
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

class Shape: UIView {
    
    var type: ShapeType
    
    var currentPressure: CGFloat = 0  {
        didSet {
            currentPressure = max(0.2, currentPressure)
            delegate?.keyHeld(self, currentPressure: currentPressure)
        }
    }
    
    weak var delegate: KeyInteractionDelegate?
    
    init(origin: CGPoint, type: ShapeType) {
        self.type = type
        let size = type.size
        let frame = CGRect(origin: origin, size: size)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 1, alpha: 0.0)
        let random = CGFloat(arc4random_uniform(360))
        transform = CGAffineTransform(rotationAngle: random)
    }
    
    override func draw(_ rect: CGRect) {
        switch self.type {
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
        
        context?.close(withFill: type.color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Key Interaction
extension Shape {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.keyDown(self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.keyUp(self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { currentPressure = $0.force / $0.maximumPossibleForce }
    }
}
