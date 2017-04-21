///
/// EnvironmentView.swift
///

import Foundation
import UIKit
import AudioKit

enum EnvironmentType {
    
    case frog
    
    var key: ShapeType {
        switch self {
        case .frog:
            return .lilypad
        }
    }
    
    var backgroundColor: UIColor {
        return Palette.backgroundColor(for: self)
    }
}

class Environment: UIView {
    
    let ANIMATION_THROTTLE_COUNT = 40
    
    var animationThrottle = (tag: 0, counter: 0)
    let type: EnvironmentType
    lazy var keyOrigins: [CGPoint] = { return self.calculateOrigins() }()
    var keyType: ShapeType { return type.key }
    
    weak var delegate: KeyInteractionDelegate?
    
    init(type: EnvironmentType) {
        self.type = type
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = type.backgroundColor
    }
    
    func layoutKeys() {
        for (index, origin) in keyOrigins.enumerated() {
            let key = Shape(origin: origin, type: keyType)
            key.tag = index
            key.conductorDelegate = delegate
            key.animationDelegate = self
            self.addSubview(key)
        }
    }
    
    func calculateOrigins() -> [CGPoint] {
        var origins: [CGPoint] = []
        let displacements: [CGFloat] = [-130, 0, 130]
        let centerOrigin = (frame.width / 2 - 50, frame.height / 2 - 50)
        displacements.forEach { yDisplacement in
            displacements.forEach {  xDisplacement in
                let origin = CGPoint(x: centerOrigin.0 + xDisplacement, y: centerOrigin.1 + yDisplacement)
                origins.append(origin)
            }
        }
        return origins
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol AnimateSoundDelegate: class {
    func toggleAnimateSound(_ shape: Shape)
}

extension Environment: AnimateSoundDelegate {
    
    func animationShouldBeThrottled(_ shape: Shape) -> Bool {
        if animationThrottle.tag != shape.tag || animationThrottle.counter == ANIMATION_THROTTLE_COUNT {
            animationThrottle = (shape.tag, 0)
        }
        animationThrottle.counter += 1
        return animationThrottle.counter != 1
    }
    
    func toggleAnimateSound(_ shape: Shape) {
        
        if shape.isAnimating { shape.isAnimating = false; return } else { shape.isAnimating = true }
        
        if animationShouldBeThrottled(shape) { return }
        
        let noteFrequency = Conductor.sharedInstance.MIDINotes[shape.tag].midiNoteToFrequency()
        
        let keyOrigin = keyOrigins[shape.tag]
        let circleOrigin = CGPoint(x: keyOrigin.x + 50, y: keyOrigin.y + 50)
        
        let circlePath = UIBezierPath(
            arcCenter: circleOrigin,
            radius: CGFloat(50),
            startAngle: CGFloat(0),
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true
        )
        
        let circleLayer = CAShapeLayer().then {
            $0.path = circlePath.cgPath
            $0.lineWidth = 1.0
            $0.strokeColor = UIColor(red:0.31, green:0.53, blue:0.87, alpha:1.0).cgColor
            $0.fillColor = Palette.transparent.color.cgColor
            self.layer.insertSublayer($0, at: 0)
        }
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeColor")
        strokeAnimation.toValue = Palette.pond.color.cgColor
        strokeAnimation.duration = Double(1000 / noteFrequency)
        
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, circleOrigin.x, circleOrigin.y, 0)
        transform = CATransform3DScale(transform, 10, 10, 1)
        transform = CATransform3DTranslate(transform, -circleOrigin.x, -circleOrigin.y, 0)
        
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.toValue = NSValue(caTransform3D: transform)
        transformAnimation.duration = Double(1000 / noteFrequency)
        
        Timer.scheduledTimer(timeInterval: noteFrequency / 100, target: self, selector: Selector(("executeAnimation")), userInfo: nil, repeats: true)
        
        func executeAnimation() {
            circleLayer.add(animations: [strokeAnimation, transformAnimation]) { _ in
                let delay = DispatchTime.now() + 5.5
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    circleLayer.removeFromSuperlayer()
                }
            }
        }
    }
}

extension CAShapeLayer {
    
    func add(animations: [CABasicAnimation], cb: @escaping () -> ()) {
        animations.forEach { add($0, forKey: $0.keyPath) }
        cb()
    }
}
