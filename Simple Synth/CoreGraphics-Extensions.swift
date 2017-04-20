///
///  CoreGraphics-Extensions.swift
///

import Foundation
import UIKit

extension CGContext {
    
    func addLine(to point: (Int, Int)) {
        return addLine(to: CGPoint(x: point.0, y: point.1))
    }
    
    func addQuadCurve(to point: (Int, Int), control: (Int, Int)) {
        return addQuadCurve(to: CGPoint(x: point.0, y: point.1), control: CGPoint(x: control.0, y: control.1))
    }
    
    func addCurve(to point: (Int, Int), control1: (Int, Int), control2: (Int, Int)) {
        return addCurve(to: CGPoint(x: point.0, y: point.1), control1: CGPoint(x: control1.0, y: control1.1), control2: CGPoint(x: control2.0, y: control2.1))
    }
    
    func close(withFill: UIColor) {
        setFillColor(withFill.cgColor)
        fillPath()
        closePath()
    }
    
    func close(withFill: UIColor, withStroke: (lineWidth: CGFloat, color: UIColor)) {
        setLineWidth(withStroke.lineWidth)
        setStrokeColor(withStroke.color.cgColor)
        strokePath()
        close(withFill: withFill)
    }
    
    func move(to point: (Int, Int)) {
        return move(to: CGPoint(x: point.0, y: point.1))
    }
}
