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
    
    var animalImages: [UIImage] {
        var images = [UIImage]()
        for i in 1...4 {
            images.append(UIImage(named: self.rawValue + "\(i)")!)
        }
        return images
    }
    
    
    var backgroundColor: UIColor {
        return Palette.backgroundColor(for: self)
    }
}

class Environment: UIView {
    
    var animalImageViews = [UIImageView]()
    var currentAnimalHasBeenTappedOnce = false
    
    let ANIMATION_THROTTLE_COUNT = 40
    let DISPLACEMENTS: [CGFloat] = [-130, 0, 130]
    
    var animationThrottle = (tag: 0, counter: 0)
    var aboutToSwitchEnvironment = false
    let type: EnvironmentType
    lazy var keyOrigins: [CGPoint] = { return self.calculateOrigins() }()
    var keyType: ShapeType { return type.key }
    var weatherType: WeatherType {
        didSet {
            layoutWeather()
        }
    }
    
    weak var delegate: KeyInteractionDelegate?
    
    init(type: EnvironmentType, weatherType: WeatherType = .cloudy) {
        self.type = type
        self.weatherType = weatherType
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = type.backgroundColor
    }
    
    func addChangeEnvironmentGestureRecognizer(view: UIImageView) {
        let transitionEnvironmentPress = UITapGestureRecognizer(target: self, action: #selector(transitionEnvironment))
        view.addGestureRecognizer(transitionEnvironmentPress)
    }
    
    func addChangeDelaySwipeRecognizers(view: UIImageView) {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(nextDelay))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(previousDelay))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeLeft)

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
        layoutWeather()
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
        
        let animalImageView = UIImageView().then {
            $0.image = t.animalImages[0]
            $0.tag = index
            $0.accessibilityIdentifier = t.rawValue
            self.addSubview($0)
            animalImageViews.append($0)
            $0.alpha = isCurrentType ? 1 : 0
            // Gesture Recognizers
            $0.isUserInteractionEnabled = true
            addChangeEnvironmentGestureRecognizer(view: $0)
            addChangeDelaySwipeRecognizers(view: $0)
            if index == 1 { addRevealAllAnimalsGestureRecognizer(view: $0); $0.image = determineAnimalImageForDelay(type) }
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
            addSubview(key)
        }
    }
    
    func layoutWeather() {
        let origin = CGPoint(x: frame.width - 100, y: 25)
        let changeWeatherTap = UITapGestureRecognizer(target: self, action: #selector(changeWeather))
        let weatherObject = Weather(origin: origin, type: weatherType)
        weatherObject.isUserInteractionEnabled = true
        weatherObject.addGestureRecognizer(changeWeatherTap)
        addSubview(weatherObject)
    }
    
    func changeWeather(_:UITapGestureRecognizer) {
        guard let weatherObj = subviews.filter({ $0 is Weather }).first else { return }
        weatherObj.removeFromSuperview()
        weatherType = {
            switch weatherType {
            case .sunny:
                return .dark
            case .dark:
                return .cloudy
            case .cloudy:
                return .sunny
            }
        }()
    }
    
    func returnToCurrentEnvironment() {
        for (i, v) in animalImageViews.enumerated() {
            UIView.animate(withDuration: 0.2) {
                v.alpha = i == 1 ? 1 : 0
            }
        }
    }
    
    func nextDelay(_ sender: UISwipeGestureRecognizer) {
        guard !currentAnimalHasBeenTappedOnce else { return }
        Conductor.sharedInstance.nextDelay()
        guard
            let accessId = sender.view?.accessibilityIdentifier,
            let animalType = EnvironmentType(rawValue: accessId)
            else { return }
        animalImageViews[1].image = determineAnimalImageForDelay(animalType)
    }
    
    func previousDelay(_ sender: UISwipeGestureRecognizer) {
        guard !currentAnimalHasBeenTappedOnce else { return }
        Conductor.sharedInstance.previousDelay()
        guard
            let accessId = sender.view?.accessibilityIdentifier,
            let animalType = EnvironmentType(rawValue: accessId)
            else { return }
        animalImageViews[1].image = determineAnimalImageForDelay(animalType)
    }
    
    func determineAnimalImageForDelay(_ t: EnvironmentType) -> UIImage {
        let conductor = Conductor.sharedInstance
        if conductor.delay.isBypassed {
            return t.animalImages[0]
        }
        switch conductor.delay.time {
        case conductor.shortDelay:
            return t.animalImages[1]
        case conductor.mediumDelay:
            return t.animalImages[2]
        case conductor.longDelay:
            return t.animalImages[3]
        default:
            return t.animalImages[3]
        }
    }
    
    func revealAllAnimals(_:UITapGestureRecognizer) {
        animalImageViews.forEach { (animal) in
            UIView.animate(withDuration: 0.2, animations: {
                animal.alpha = 0.7
            })
        }
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
        // this method now doesn't get called if index is 1 because we have two of the same tap gesture recognizers
        if !aboutToSwitchEnvironment { return }
        guard
            let accessId = sender.view?.accessibilityIdentifier,
            let transitionType = EnvironmentType(rawValue: accessId)
            else { return }
        transitionType == type ? returnToCurrentEnvironment() : transition(to: transitionType)
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
    
    // TODO: remove, currently unused
    func animationShouldBeThrottled(_ shape: Shape) -> Bool {
        if animationThrottle.tag != shape.tag || animationThrottle.counter == ANIMATION_THROTTLE_COUNT {
            animationThrottle = (shape.tag, 0)
        }
        animationThrottle.counter += 1
        return animationThrottle.counter != 1
    }
    
    
    func toggleFade(_ shape: Shape) {
        UIView.animate(withDuration: 0.1) { shape.alpha = shape.isPressed ? 1 : 0.7 }
        shape.isPressed = !shape.isPressed
    }
    
    func animateSound(_ shape: Shape) {
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
            layer.insertSublayer($0, at: 0)
        }
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeColor")
        strokeAnimation.toValue = Palette.pond.color.cgColor
        strokeAnimation.duration = noteFrequency / 50
        
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, circleOrigin.x, circleOrigin.y, 0)
        transform = CATransform3DScale(transform, 10, 10, 1)
        transform = CATransform3DTranslate(transform, -circleOrigin.x, -circleOrigin.y, 0)
        
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.toValue = NSValue(caTransform3D: transform)
        transformAnimation.duration = noteFrequency / 50
        
        circleLayer.add(animations: [strokeAnimation, transformAnimation]) { _ in
            let delay = DispatchTime.now() + noteFrequency / 50
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
