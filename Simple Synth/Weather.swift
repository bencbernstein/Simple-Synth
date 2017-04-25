///
/// Weather.swift
///

import UIKit

class Weather: UIView {
    
    var type: WeatherType
    var environmentType: EnvironmentType
    
    init(origin: CGPoint, type: WeatherType, environmentType: EnvironmentType) {
        self.type = type
        self.environmentType = environmentType
        
        let size = type.size
        let frame = CGRect(origin: origin, size: size)
        
        super.init(frame: frame)
        
        backgroundColor = Palette.transparent.color
    }
    
    override func draw(_ rect: CGRect) {
        switch self.type {
        case .cloudy:
            drawCloud()
        case .dark:
            drawMoon()
        case .sunny:
            drawSun()
        }
    }
    
    func drawCloud() {
        drawSun()
        
        func drawWhiteCircle(x: Int, y: Int) {
            let circle1 = UIGraphicsGetCurrentContext()
            circle1?.addEllipse(in: CGRect(x: x, y: y, width: 35, height: 35))
            circle1?.fill(Palette.cloud.color)
            circle1?.drawPath(using: .fillStroke)
        }
        
        drawWhiteCircle(x: 5, y: 42)
        drawWhiteCircle(x: 25, y: 42)
        drawWhiteCircle(x: 45, y: 42)
        drawWhiteCircle(x: 15, y: 22)
        drawWhiteCircle(x: 35, y: 27)
    }
    
    func drawMoon() {
        let crescentContext = UIGraphicsGetCurrentContext()
        
        crescentContext?.addEllipse(in: CGRect(x: 20.5, y: 2.5, width: 70, height: 70))
        crescentContext?.fillAndStroke(fill: Palette.moon.color, stroke: (width: 2, color: Palette.moon.color ))
        crescentContext?.drawPath(using: .fillStroke)
        
        let maskContext = UIGraphicsGetCurrentContext()
        
        maskContext?.addEllipse(in: CGRect(x: 18, y: 0, width: 65, height: 65))
        maskContext?.fill(Palette.backgroundColor(for: environmentType, weather: type))
        maskContext?.drawPath(using: .fillStroke)
    }
    
    func drawSun() {
        let context = UIGraphicsGetCurrentContext()
        
        context?.saveGState()
        context?.addEllipse(in: CGRect(x: 27.5, y: 2.5, width: 70, height: 70))
        context?.setShadow(offset: .zero, blur: 2, color: Palette.sunRim.color.cgColor)
        context?.fillAndStroke(fill: Palette.sun.color, stroke: (width: 2, color: Palette.sunRim.color))
        context?.drawPath(using: .fillStroke)
        
        func addGradient() {
            context?.restoreGState()
            let origin = CGPoint(x: 62.5, y: 37.5)
            let locations: [CGFloat] = [0.0, 1.0]
            let colors = [Palette.sunCenter.color.cgColor, Palette.sun.color.cgColor]
            let colorspace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorspace, colors: colors as CFArray, locations: locations)
            context?.drawRadialGradient(gradient!, startCenter: origin, startRadius: 0, endCenter: origin, endRadius: 30, options: [])
        }
        addGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
