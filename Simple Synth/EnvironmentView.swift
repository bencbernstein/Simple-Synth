///
/// EnvironmentView.swift
///

import Foundation
import UIKit
import AudioKit

enum EnvironmentType: String {
    
    case bee, bird, frog
    
    static var all = [bee, bird, frog]
    
    var key: ShapeType {
        switch self {
        case .bee:
            return .honeycomb
        case .bird:
            return .flower
        case .frog:
            return .lilypad
        }
    }
    
    var animalImage: UIImage {
        return UIImage(named: self.rawValue)!
    }
    
    var backgroundColor: UIColor {
        return Palette.backgroundColor(for: self)
    }
}

class Environment: UIView {
    
    var animalImageViewButtons = [UIImageView]()
    var currentAnimalHasBeenTappedOnce = false
    
    let ANIMATION_THROTTLE_COUNT = 40
    let DISPLACEMENTS: [CGFloat] = [-130, 0, 130]
    
    var animationThrottle = (tag: 0, counter: 0)
    var aboutToSwitchEnvironment = false
    let type: EnvironmentType
    lazy var keyOrigins: [CGPoint] = { return self.calculateOrigins() }()
    var keyType: ShapeType { return type.key }
    
    weak var delegate: KeyInteractionDelegate?
    
    init(type: EnvironmentType) {
        self.type = type
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = type.backgroundColor
    }
    
    func addChangeEnvironmentGestureRecognizer(view: UIImageView) {
        let transitionEnvironmentPress = UITapGestureRecognizer(target: self, action: #selector(transitionEnvironment))
        view.addGestureRecognizer(transitionEnvironmentPress)
    }
    
    func addRevealAllAnimalsGestureRecognizer(view: UIImageView) {
        let revealAllAnimalsPress = UITapGestureRecognizer(target: self, action: #selector(revealAllAnimals))
        view.addGestureRecognizer(revealAllAnimalsPress)
    }
    
    func calculateOrigins() -> [CGPoint] {
        var origins: [CGPoint] = []
        let centerOrigin = (frame.width / 2 - 50, frame.height / 2 - 50)
        
        DISPLACEMENTS.forEach { yDisplacement in
            DISPLACEMENTS.forEach {  xDisplacement in
                let origin = CGPoint(
                    x: centerOrigin.0 + xDisplacement,
                    y: centerOrigin.1 + yDisplacement
                )
                origins.append(origin)
            }
        }
        return origins
    }
    
    func layoutView() {
        layoutAnimals()
        layoutKeys()
    }
    
    func layoutAnimals() {
        var types = EnvironmentType.all.filter { $0 != type }
        types.insert(type, at: 1)
        for (index, t) in types.enumerated() {
            layoutAnimal(t, index: index)
        }
    }
    
    func layoutAnimal(_ t: EnvironmentType, index: Int) {
        let isCurrentType = index == 1
        _ = UIImageView().then {
            $0.image = t.animalImage
            $0.tag = index
            $0.accessibilityIdentifier = t.rawValue
            self.addSubview($0)
            animalImageViewButtons.append($0)
            $0.alpha = isCurrentType ? 1 : 0
            // Gesture Recognizers
            $0.isUserInteractionEnabled = true
            addChangeEnvironmentGestureRecognizer(view: $0)
            if index == 1 { addRevealAllAnimalsGestureRecognizer(view: $0) }
            // Anchors
            $0.heightAnchor.constraint(equalToConstant: 100).isActive = true
            $0.widthAnchor.constraint(equalTo: $0.heightAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: centerYAnchor, constant: DISPLACEMENTS[index]).isActive = true
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
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
    
    func returnToCurrentEnvironment() {
        for (i, v) in animalImageViewButtons.enumerated() { v.alpha = i == 1 ? 1 : 0 }
    }
    
    func revealAllAnimals(_:UITapGestureRecognizer) {
        animalImageViewButtons.forEach { $0.alpha = 1.0 }
        aboutToSwitchEnvironment = true
        if currentAnimalHasBeenTappedOnce {
            returnToCurrentEnvironment()
        }
        currentAnimalHasBeenTappedOnce = !currentAnimalHasBeenTappedOnce
    }
    
    func transition(to environmentType: EnvironmentType) {
        NotificationCenter.default.post(
            name: Notification.Name(rawValue:"transitionEnvironment"),
            object: nil,
            userInfo:["environment" : environmentType.rawValue]
        )
    }
    
    func transitionEnvironment(_ sender: UITapGestureRecognizer) {
        if !aboutToSwitchEnvironment { return }
        guard
            let accessId = sender.view?.accessibilityIdentifier,
            let transitionType = EnvironmentType(rawValue: accessId)
            else { return }
        transitionType == type ? returnToCurrentEnvironment() : transition(to: transitionType)
        // this is always returning false...
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol AnimateSoundDelegate: class {
    func animateSound(_ shape: Shape)
    func toggleFade(_ shape: Shape)
    
}


extension Environment: AnimateSoundDelegate {
    
    func animationShouldBeThrottled(_ shape: Shape) -> Bool {
        if animationThrottle.tag != shape.tag || animationThrottle.counter == ANIMATION_THROTTLE_COUNT {
            animationThrottle = (shape.tag, 0)
        }
        animationThrottle.counter += 1
        return animationThrottle.counter != 1
    }
    
    
    func toggleFade(_ shape: Shape) {
        if !shape.isPressed {
            UIView.animate(withDuration: 0.1) {
                shape.alpha = 0.7
            }
            shape.isPressed = true
        } else {
            UIView.animate(withDuration: 0.1) {
                shape.alpha = 1
            }
            shape.isPressed = false
        }
    }
    
    func animateSound(_ shape: Shape) {
        
        //if animationShouldBeThrottled(shape) { return }
        
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
        strokeAnimation.duration = noteFrequency / 100
        
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, circleOrigin.x, circleOrigin.y, 0)
        transform = CATransform3DScale(transform, 10, 10, 1)
        transform = CATransform3DTranslate(transform, -circleOrigin.x, -circleOrigin.y, 0)
        
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.toValue = NSValue(caTransform3D: transform)
        transformAnimation.duration = noteFrequency / 100
        
        circleLayer.add(animations: [strokeAnimation, transformAnimation]) { _ in
            let delay = DispatchTime.now() + noteFrequency / 100
            DispatchQueue.main.asyncAfter(deadline: delay) {
                circleLayer.removeFromSuperlayer()
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
