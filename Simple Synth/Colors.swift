//
//  Colors.swift
//  Simple Synth
//
//  Created by Benjamin Bernstein on 3/29/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import UIKit

enum Palette {
    case purple, blue, green, yellow, orange, red
    
    var color: UIColor {
        switch self {
        case .purple: return UIColor(hex: 0x4B0082)
        case .blue: return UIColor(hex: 0x0000FF)
        case .green: return UIColor(hex: 0x00FF00)
        case .yellow: return UIColor(hex: 0xFFFF00)
        case .orange: return UIColor(hex: 0xFF7F00)
        case .red: return UIColor(hex: 0xFF0000)
        }
    }

}

extension UIColor {
    
    static let colors = [Palette.purple.color, Palette.blue.color, Palette.green.color, Palette.yellow.color, Palette.orange.color, Palette.red.color, Palette.purple.color, Palette.blue.color, Palette.green.color ]
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    class func forGradient(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
}

