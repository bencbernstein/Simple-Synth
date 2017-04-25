///
/// Key.swift
///

import UIKit

class Key: UIView {
    
    var animationTimer = Timer()
    var isPressed = false
    var type: KeyType
    var weather: WeatherType
    
    var currentPressure: CGFloat = 0  {
        didSet {
            currentPressure = max(0.2, currentPressure)
            conductorDelegate?.keyHeld(self, currentPressure: currentPressure)
        }
    }
    
    weak var animationDelegate: AnimateSoundDelegate?
    weak var conductorDelegate: KeyInteractionDelegate?
    
    init(origin: CGPoint, type: KeyType, weather: WeatherType) {
        self.type = type
        self.weather = weather
        
        let size = type.size
        let frame = CGRect(origin: origin, size: size)
        
        super.init(frame: frame)

        backgroundColor = Palette.transparent.color
        let random = CGFloat(arc4random_uniform(360))
        transform = CGAffineTransform(rotationAngle: random)
    }
    
    override func draw(_ rect: CGRect) {
        switch self.type {
        case .honeycomb:
            drawHoneycomb()
        case .lilypad:
            drawLilypad()
        case .flower:
            drawFlower()
        }
    }
    
    func drawHoneycomb() {
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: (6.7, 75))
        context?.addLine(to: (6.7, 25))
        context?.addLine(to: (50, 0))
        context?.addLine(to: (93.3, 25))
        context?.addLine(to: (93.3, 75))
        context?.addLine(to: (50, 100))
        context?.addLine(to: (6.7, 75))
        
        context?.fillAndStroke(fill: Palette.honeycomb(weather: weather).color, stroke: (2, Palette.honeycombRim(weather: weather).color))
        context?.drawPath(using: .fillStroke)
    }
    
    func drawLilypad() {
        let context = UIGraphicsGetCurrentContext()
        
        context?.saveGState()
        context?.move(to: (2, 50))
        context?.addLine(to: (30, 50))
        context?.addLine(to: (5, 37))
        context?.addCurve(to: (50, 2), control1: (7, 18), control2: (23, 2))
        context?.addCurve(to: (98, 50), control1: (78, 2), control2: (98, 18))
        context?.addCurve(to: (50, 98), control1: (98, 78), control2: (78, 98))
        context?.addCurve(to: (2, 50), control1: (18, 98), control2: (2, 78))
        
        context?.setShadow(offset: .zero, blur: 2, color: Palette.lilypadRim(weather: weather).color.cgColor)
        context?.fillAndStroke(fill: Palette.lilypad(weather: weather).color, stroke: (width: 2, color: Palette.lilypadRim(weather: weather).color))
        context?.drawPath(using: .fillStroke)
        
        func addGradient() {
            context?.restoreGState()
            let origin = CGPoint(x: 65, y: 50)
            let locations: [CGFloat] = [0.0, 1.0]
            let colors = [Palette.lilypadLight(weather: weather).color.cgColor, Palette.lilypad(weather: weather).color.cgColor]
            let colorspace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorspace, colors: colors as CFArray, locations: locations)
            context?.drawRadialGradient(gradient!, startCenter: origin, startRadius: 0, endCenter: origin, endRadius: 30, options: [])
        }
        addGradient()
    }
    
    func drawFlower() {
        let context = UIGraphicsGetCurrentContext()
 
        for i in 0...3 {
            context?.saveGState()
            context?.translateBy(x: 50, y: 50)
            context?.rotate(by: CGFloat(Double.pi / 4 * Double(i)))
            context?.addEllipse(in: CGRect(x: -10, y: -50, width: 20, height: 100))
            context?.fillAndStroke(fill: Palette.flower(weather: weather).color, stroke: (1, Palette.petal(weather: weather).color))
            context?.drawPath(using: .fillStroke)
            context?.restoreGState()
        }
        
        context?.addEllipse(in: CGRect(x: 35, y: 35, width: 30, height: 30))
        context?.fillAndStroke(fill: Palette.pistal(weather: weather).color, stroke: (4, Palette.pistalRim(weather: weather).color))
        context?.drawPath(using: .fillStroke)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Key Interaction
extension Key {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        conductorDelegate?.keyDown(self)
        let noteFrequency = Conductor.sharedInstance.MIDINotes[self.tag].midiNoteToFrequency()
        self.animationTimer = Timer.scheduledTimer(
            timeInterval: 250 / noteFrequency,
            target: self,
            selector: #selector(animateSound),
            userInfo: nil,
            repeats: true
        )
        self.animationTimer.fire()
        animationDelegate?.toggleFade(self)
    }
    
    func animateSound() {
        animationDelegate?.animateSound(self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        conductorDelegate?.keyUp(self)
        self.animationTimer.invalidate()
        animationDelegate?.toggleFade(self)      
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { currentPressure = $0.force / $0.maximumPossibleForce }
    }
}
