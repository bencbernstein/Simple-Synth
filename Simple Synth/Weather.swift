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
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: (2.5, 52.5))
        context?.addCurve(to: (25, 30), control1: (5, 20), control2: (20, 20))
        context?.addCurve(to: (72.5, 52.5), control1: (40, 5), control2: (60, 5))
        context?.addCurve(to: (2.5, 52.5), control1: (70, 57.5), control2: (15, 57.5))
        
        context?.fill(Palette.cloud.color)
        context?.closePath()
    }
    
    func drawMoon() {
        
        //crescent moon
        let moonContext = UIGraphicsGetCurrentContext()
        moonContext?.move(to: (55, 7.19))
        moonContext?.addEllipse(in: CGRect(x: 2.5, y: 2.5, width: 70, height: 70))
        
        moonContext?.fillAndStroke(fill: Palette.moon.color, stroke: (width: 2, color: Palette.moon.color ))
        moonContext?.drawPath(using: .eoFillStroke)
        
        //mask color
        let maskContext = UIGraphicsGetCurrentContext()
        maskContext?.move(to: (55, 7.19))
        maskContext?.addEllipse(in: CGRect(x: 1, y: 1, width: 63, height: 63))
        maskContext?.fill(Palette.backgroundColor(for: environmentType))
        maskContext?.drawPath(using: .fillStroke)

    }
    
    func drawSun() {
        let context = UIGraphicsGetCurrentContext()
        
        context?.saveGState()
        context?.addEllipse(in: CGRect(x: 2.5, y: 2.5, width: 70, height: 70))
        context?.setShadow(offset: .zero, blur: 2, color: Palette.sunRim.color.cgColor)
        context?.fillAndStroke(fill: Palette.sun.color, stroke: (width: 2, color: Palette.sunRim.color))
        context?.drawPath(using: .fillStroke)
        
        func addGradient() {
            context?.restoreGState()
            let origin = CGPoint(x: 37.5, y: 37.5)
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
