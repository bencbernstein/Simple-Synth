///
/// Weather.swift
///

import UIKit

class Weather: UIView {
    
    var type: WeatherType
    
    init(origin: CGPoint, type: WeatherType) {
        self.type = type
        
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
        let shadowContext = UIGraphicsGetCurrentContext()
        
        shadowContext?.addEllipse(in: CGRect(x: 2.5, y: 2.5, width: 70, height: 70))
        shadowContext?.fill(Palette.moonShadow.color)
        shadowContext?.closePath()
        
        let moonContext = UIGraphicsGetCurrentContext()
        moonContext?.move(to: (55, 7.19))
        // https://math.stackexchange.com/questions/873224/calculate-control-points-of-cubic-bezier-curve-approximating-a-part-of-a-circle
        moonContext?.addCurve(to: (55, 67.81), control1: (78.33, 20.667), control2: (78.33, 54.333))
        moonContext?.addCurve(to: (55, 7.19), control1: (63.33, 54.333), control2: (63.33, 20.667))
        moonContext?.fill(Palette.moon.color)
        moonContext?.closePath()
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
