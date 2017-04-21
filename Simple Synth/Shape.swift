///
/// Shape.swift
///

import UIKit

enum ShapeType {
    
    case lilypad, flower
    
    var size: CGSize {
        switch self {
        case .lilypad:
            return CGSize(width: 100, height: 100)
        case .flower:
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
            conductorDelegate?.keyHeld(self, currentPressure: currentPressure)
            animationDelegate?.animateSound(self)
        }
    }
    
    weak var animationDelegate: AnimateSoundDelegate?
    weak var conductorDelegate: KeyInteractionDelegate?
    
    init(origin: CGPoint, type: ShapeType) {
        self.type = type
        let size = type.size
        let frame = CGRect(origin: origin, size: size)
        
        super.init(frame: frame)
        
        backgroundColor = Palette.transparent.color
        let random = CGFloat(arc4random_uniform(360))
        transform = CGAffineTransform(rotationAngle: random)
    }
    
    override func draw(_ rect: CGRect) {
        switch self.type {
        case .lilypad:
            drawLilypad()
        case .flower:
            drawFlower()
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
        
        context?.close(fill: type.color)
    }
    
    func drawFlower() {
        let context = UIGraphicsGetCurrentContext()
 
        for i in 0...3 {
            context?.saveGState()
            context?.translateBy(x: 50, y: 50)
            context?.rotate(by: CGFloat(Double.pi / 4 * Double(i)))
            context?.addEllipse(in: CGRect(x: -10, y: -50, width: 20, height: 100))
            context?.close(fill: type.color, stroke: (1, Palette.petal.color))
            context?.drawPath(using: .fillStroke)
            context?.restoreGState()
        }
        
        context?.addEllipse(in: CGRect(x: 35, y: 35, width: 30, height: 30))
        context?.close(fill: Palette.pistal.color, stroke: (4, Palette.pistalRim.color))
        context?.drawPath(using: .fillStroke)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Key Interaction
extension Shape {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        conductorDelegate?.keyDown(self)
        animationDelegate?.animateSound(self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        conductorDelegate?.keyUp(self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { currentPressure = $0.force / $0.maximumPossibleForce }
    }
}
