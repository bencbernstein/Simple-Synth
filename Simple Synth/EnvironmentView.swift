///
/// EnvironmentView.swift
///

import UIKit

enum EnvironmentType: String {
    
    case bird, frog
    
    static var all = [bird, frog]
    
    var key: ShapeType {
        switch self {
        case .bird:
            return .lilypad
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
        let revealAllAnimalsPress = UILongPressGestureRecognizer(target: self, action: #selector(revealAllAnimals))
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
    
    func revealAllAnimals(_:UILongPressGestureRecognizer) {
        animalImageViewButtons.forEach { $0.alpha = 0.3 }
        aboutToSwitchEnvironment = true
    }
    
    func transition(to environmentType: EnvironmentType) {
        let newEnvironment = Environment(type: environmentType)
        newEnvironment.layoutView()
        newEnvironment.alpha = 0
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else { return }
        vc.view.addSubview(newEnvironment)
        UIView.animate(withDuration: 0.8, animations: {
            self.alpha = 0
            newEnvironment.alpha = 1
        }) { success in
            self.removeFromSuperview()
        }
    }
    
    func transitionEnvironment(_ sender: UITapGestureRecognizer) {
        if !aboutToSwitchEnvironment { return }
        guard
            let t = sender.view?.accessibilityIdentifier,
            let transitionType = EnvironmentType(rawValue: t)
        else { return }
        transitionType == type ? returnToCurrentEnvironment() : transition(to: transitionType)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol AnimateSoundDelegate: class {
    func animateSound(_ shape: Shape)
}


extension Environment: AnimateSoundDelegate {
    
    func animationShouldBeThrottled(_ shape: Shape) -> Bool {
        if animationThrottle.tag != shape.tag || animationThrottle.counter == ANIMATION_THROTTLE_COUNT {
            animationThrottle = (shape.tag, 0)
        }
        animationThrottle.counter += 1
        return animationThrottle.counter != 1
    }
    
    func animateSound(_ shape: Shape) {
        
        if animationShouldBeThrottled(shape) { return }
        
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
        
        //
        // Ben TODO:
        //
        // Change ripple speed based on frequency
        // - probably will need to make animation durations a factor of the note frequency
        // - might need a delegate, but if we know what these values are, probably easier / more efficient to hard code them here
        //
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeColor")
        strokeAnimation.toValue = Palette.pond.color.cgColor
        strokeAnimation.duration = 6
        
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, circleOrigin.x, circleOrigin.y, 0)
        transform = CATransform3DScale(transform, 10, 10, 1)
        transform = CATransform3DTranslate(transform, -circleOrigin.x, -circleOrigin.y, 0)
        
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.toValue = NSValue(caTransform3D: transform)
        transformAnimation.duration = 6
        
        circleLayer.add(animations: [strokeAnimation, transformAnimation]) { _ in
            let delay = DispatchTime.now() + 5.5
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
