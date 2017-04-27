///
/// EnvironmentView.swift
///

import Foundation
import UIKit

class Environment: UIView {
    
    var animalImageViews = [(EnvironmentType, UIImageView)]()
    var mistImageViews = [UIImageView]()
    var changeEnvironmentView = UIImageView()
    
    let DISPLACEMENTS: [CGFloat] = [-130, 0, 130]
    
    var aboutToSwitchEnvironment = false
    let conductor = Conductor.sharedInstance
    var cloudyWeather: Bool { return weather == .cloudy }
    lazy var keyOrigins: [CGPoint] = { return self.calculateOrigins() }()
    var keyType: KeyType { return type.key }
    var mistCounter = 0
    let type: EnvironmentType
    var weather: WeatherType
    
    weak var delegate: KeyInteractionDelegate?
    
    init(type: EnvironmentType = .frog, weather: WeatherType = .cloudy) {
        
        self.type =  type
        self.weather =  weather
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = self.type.backgroundColor(for: self.weather)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(Environment.didEnterBackground),
            name: NSNotification.Name.UIApplicationDidEnterBackground,
            object: nil
        )
    }
    
    func didEnterBackground() {
        UserDefaults.standard.setValue(type.rawValue, forKey: "environment")
        UserDefaults.standard.setValue(weather.rawValue, forKey: "weather")
        removeFromSuperview()
    }
    
    // Determines the origin for each key
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
    
    func changeWeather(_:UITapGestureRecognizer) {
        switch weather {
        case .sunny:
            transition(to: type, weather: .cloudy)
        case .cloudy:
            transition(to: type, weather: .dark)
        case .dark:
            transition(to: type, weather: .sunny)
        }
    }
    
    override func removeFromSuperview() {
        weather = .dark
        super.removeFromSuperview()
    }
    
    func returnToCurrentEnvironment() {
        aboutToSwitchEnvironment = false
        for (i, v) in animalImageViews.map({ $0.1 }).enumerated() {
            UIView.animate(withDuration: 0.2) { v.alpha = i == 1 ? 1 : 0 }
        }
        UIView.animate(withDuration: 0.2) {
            self.changeEnvironmentView.alpha = 0.7
        }
    }
    
    func tappedChangedEnvironment(_ sender:UITapGestureRecognizer) {
        if aboutToSwitchEnvironment {
            returnToCurrentEnvironment()
        } else {
            aboutToSwitchEnvironment = true
            animalImageViews.map({ $0.1 }).forEach { (animal) in
                UIView.animate(withDuration: 0.2, animations: { animal.alpha = 0.7 })
            }
            UIView.animate(withDuration: 0.2) {
                self.changeEnvironmentView.alpha = 0
            }
        }
    }
    
    func tappedAnimal(_ sender:UITapGestureRecognizer) {
        aboutToSwitchEnvironment ? transitionEvironment(sender) : nextDelay()
    }
    
    func transitionEvironment(_ sender:UITapGestureRecognizer) {
        guard
            let accessId = sender.view?.accessibilityIdentifier,
            let transitionType = EnvironmentType(rawValue: accessId)
            else { return }
        transitionType == type ? returnToCurrentEnvironment() : transition(to: transitionType, weather: weather)
    }
    
    func transition(to environmentType: EnvironmentType, weather: WeatherType) {
        NotificationCenter.default.post(
            name: Notification.Name(rawValue:"transitionEnvironment"),
            object: nil,
            userInfo: ["environment" : environmentType.rawValue, "weather" : weather.rawValue]
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Environment Setup
private typealias EnvironmentSetup = Environment
extension EnvironmentSetup {
    
    func addTappedAnimalGestureRecognizer(view: UIImageView) {
        let animalTap = UITapGestureRecognizer(target: self, action: #selector(tappedAnimal))
        view.addGestureRecognizer(animalTap)
    }
    
    func addChangeEnvironmentGestureRecognizer(view: UIImageView) {
        let environmentTap = UITapGestureRecognizer(target: self, action: #selector(tappedChangedEnvironment))
        view.addGestureRecognizer(environmentTap)
    }
    
    func mist() {
        
        var mistConstraint: NSLayoutConstraint!
        
        _ = UIImageView().then {
            $0.image = (mistCounter % 2 == 0) ? #imageLiteral(resourceName: "mist_inverted") : #imageLiteral(resourceName: "mist")
            $0.alpha = 0.45
            addSubview($0)
            
            // Anchors
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            $0.widthAnchor.constraint(equalTo: widthAnchor, constant: 2.25).isActive = true
            $0.topAnchor.constraint(equalTo: topAnchor).isActive = true
            mistConstraint = $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width * (mistCounter == 0 ? 0 : -1))
            mistConstraint.isActive = true
            
            layoutIfNeeded()
            
            // Blur mist edges
            let maskLayer = CAGradientLayer()
            maskLayer.frame = $0.bounds
            maskLayer.shadowRadius = 0.5
            maskLayer.shadowPath = CGPath(roundedRect: $0.bounds.insetBy(dx: 1, dy: 0), cornerWidth: 0, cornerHeight: 0, transform: nil)
            maskLayer.shadowOpacity = 1
            maskLayer.shadowOffset = .zero
            maskLayer.shadowColor = UIColor.white.cgColor
            $0.layer.mask = maskLayer
            
            animateMist($0, leadingConstraint: mistConstraint)
        }
        
        mistCounter += 1
    }
    
    
    func animateMist(_ mist: UIImageView, leadingConstraint: NSLayoutConstraint) {
        leadingConstraint.constant += frame.width * (mistCounter == 0 ? 1 : 2)
        UIView.animate(withDuration: (mistCounter == 0 ? 30 : 60), delay: 0, options: .curveLinear, animations: {
            self.layoutIfNeeded()
        }) { _ in
            mist.removeFromSuperview()
            self.mist()
        }
    }
    
    func layoutView() {
        layoutAnimals()
        layoutKeys()
        layoutWeather()
        
        changeEnvironmentView = UIImageView(frame: CGRect(origin: CGPoint(x: 15, y: 15), size: CGSize(width: 50, height: 50))).then {
            $0.image = #imageLiteral(resourceName: "hiker").withRenderingMode(.alwaysTemplate)
            $0.tintColor = hikerTintColor()
            $0.alpha = 0.8
            addSubview($0)
            // Change environment gesture recognizer
            $0.isUserInteractionEnabled = true
            addChangeEnvironmentGestureRecognizer(view: $0)
        }
        
        if cloudyWeather {
            mist()
            mist()
        }
    }
    
    func hikerTintColor() -> UIColor {
        switch type {
        case .bee:
            return Palette.honeycomb(weather: weather).color
        case .bird:
            return Palette.flower(weather: weather).color
        case .frog:
            return Palette.lilypad(weather: weather).color
        }
    }
    
    func layoutAnimals() {
        var types = EnvironmentType.all.filter { $0 != type }
        // Ensure the current EnvironentType's Animal is in the middle
        types.insert(type, at: 1)
        for (index, t) in types.enumerated() { layoutAnimal(t, index: index) }
    }
    
    func layoutAnimal(_ t: EnvironmentType, index: Int) {
        
        let isCurrentType = index == 1
        
        _ = UIImageView().then {
            $0.image = isCurrentType ? animalImageForDelay() : t.animalImages[0]
            $0.tag = index
            $0.accessibilityIdentifier = t.rawValue
            addSubview($0)
            animalImageViews.append((t, $0))
            $0.alpha = isCurrentType ? 1 : 0
            // Delay and change environment gesture recognizer
            $0.isUserInteractionEnabled = true
            addTappedAnimalGestureRecognizer(view: $0)
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
            _ = Key(origin: origin, type: keyType, weather: weather).then {
                $0.tag = index
                $0.conductorDelegate = delegate
                $0.animationDelegate = self
                addSubview($0)
            }
        }
    }
    
    func layoutWeather() {
        let origin = CGPoint(x: frame.width - 125, y: 25)
        let changeWeatherTap = UITapGestureRecognizer(target: self, action: #selector(changeWeather))
        _ = Weather(origin: origin, type: weather, environmentType: type).then {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(changeWeatherTap)
            addSubview($0)
        }
    }
}


// MARK: - Environment Delay
extension Environment {
    
    func animalImageForDelay() -> UIImage {
        if conductor.delay.isBypassed { return type.animalImages[0] }
        switch conductor.delay.time {
        case conductor.shortDelay:
            return type.animalImages[1]
        case conductor.mediumDelay:
            return type.animalImages[2]
        default:
            return type.animalImages[3]
        }
    }
    
    func nextDelay() {
        conductor.nextDelay()
        animalImageViews.filter({ $0.0 == type }).first?.1.image = animalImageForDelay()
    }
}


// MARK: - Animal Sound Delegate
protocol AnimateSoundDelegate: class {
    func animateSound(_ key: Key)
    func toggleFade(_ key: Key)
}

extension Environment: AnimateSoundDelegate {
    
    func toggleFade(_ key: Key) {
        key.alpha = key.isPressed ? 1 : 0.7
        key.isPressed = !key.isPressed
    }
    
    func animateSound(_ key: Key) {
        
        let noteFrequency = Conductor.sharedInstance.MIDINotes[key.tag].midiNoteToFrequency()
        let animationDuration = noteFrequency / 50
        let keyOrigin = keyOrigins[key.tag]
        
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
        strokeAnimation.toValue = Palette.pond(weather: weather).color.cgColor
        strokeAnimation.duration = animationDuration
        
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, circleOrigin.x, circleOrigin.y, 0)
        transform = CATransform3DScale(transform, 10, 10, 1)
        transform = CATransform3DTranslate(transform, -circleOrigin.x, -circleOrigin.y, 0)
        
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.toValue = NSValue(caTransform3D: transform)
        transformAnimation.duration = animationDuration
        
        circleLayer.add(animations: [strokeAnimation, transformAnimation]) { _ in
            let delay = DispatchTime.now() + animationDuration - 2
            DispatchQueue.main.asyncAfter(deadline: delay) {
                circleLayer.removeFromSuperlayer()
            }
        }
    }
}
