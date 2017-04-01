//
//  Colors.swift
//  Simple Synth
//
//  Created by Benjamin Bernstein on 3/29/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import UIKit

enum Palette {
    case gray, lightGray, lightBlue, darkGrey, blue, pink
    
    var color: UIColor {
        switch self {
        case .gray: return UIColor(hex: 0x3F3F3F)
        case .lightGray: return UIColor(hex: 0xABABAB)
        case .blue: return UIColor(hex: 0xC0EBFC)
        case .lightBlue: return UIColor(hex: 0xc0ebfc)
        case .darkGrey: return UIColor(hex: 0x8d8d8d)
        case .pink: return UIColor(hex: 0xFCC2C2)
        }
    }
}

extension UIColor {
    
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

