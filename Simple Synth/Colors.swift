//
//  Colors.swift
//  Simple Synth
//
//  Created by Benjamin Bernstein on 3/29/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import UIKit

enum Palette {
    
    case
    blue,
    green,
    orange,
    purple,
    red,
    yellow,
    // Transparent
    transparent,
    // Frog Environment
    grass(weather: WeatherType),
    lilypad(weather: WeatherType),
    lilypadLight(weather: WeatherType),
    lilypadRim(weather: WeatherType),
    pond(weather: WeatherType),
    // Bird Environment
    flower(weather: WeatherType),
    petal(weather: WeatherType),
    pistal(weather: WeatherType),
    pistalLight(weather: WeatherType),
    pistalRim(weather: WeatherType),
    // Bee Environment
    hive(weather: WeatherType),
    honeycomb(weather: WeatherType),
    honeycombLight(weather: WeatherType),
    honeycombRim(weather: WeatherType),
    // Cloudy
    cloud,
    // Night
    moon,
    moonShadow,
    // Sunny
    sunCenter,
    sun,
    sunRim
    
    var color: UIColor {
        switch self {
        case .blue:
            return UIColor(hex: 0x0000FF)
        case .green:
            return UIColor(hex: 0x00FF00)
        case .orange:
            return UIColor(hex: 0xFF7F00)
        case .purple:
            return UIColor(hex: 0x4B0082)
        case .red:
            return UIColor(hex: 0xFF0000)
        case .yellow:
            return UIColor(hex: 0xFFFF00)
        // Transparent
        case .transparent:
            return UIColor(white: 1, alpha: 0.0)
            
        // Bee Environment
            
            // Hive Weather - Colors
        case .hive(weather: .sunny):
            return UIColor(hex: 0xFDB745)
        case .hive(weather: .cloudy):
            return UIColor(hex: 0xD89A34)
        case .hive(weather: .dark):
            return UIColor(hex: 0x593B0C)
            
            // Honeycomb Weather - Colors
        case .honeycomb(weather: .sunny):
            return UIColor(hex: 0xB04705)
        case .honeycomb(weather: .cloudy):
            return UIColor(hex: 0x8C3904)
        case .honeycomb(weather: .dark):
            return UIColor(hex: 0x4C240A)
            
            // Honeycomb Top Light - Weather Colors
        case .honeycombLight(weather: .sunny):
            return UIColor(hex: 0xCA611F)
        case .honeycombLight(weather: .cloudy):
            return UIColor(hex: 0x8C3904)
        case .honeycombLight(weather: .dark):
            return UIColor(hex: 0x4C240A)
            
            // Honeycomb Rim - Weather Colors
        case .honeycombRim(weather: .sunny):
            return UIColor(hex: 0x7F453A)
        case .honeycombRim(weather: .cloudy):
            return UIColor(hex: 0x5F322A)
        case .honeycombRim(weather: .dark):
            return UIColor(hex: 0x441F18)

        // Bird Environment
        case .grass:
            return UIColor(hex: 0x54C502)
        case .flower:
            return UIColor.white
        case .petal:
            return UIColor(hex : 0xD6D2EE)
        case .pistal:
            return UIColor(hex: 0xFC8F68)
        case .pistalLight:
            return UIColor(hex: 0xFFC29B)
        case .pistalRim:
            return UIColor(hex: 0xF3CF3C)
        // Frog Environment
        case .lilypad:
            return UIColor(hex: 0x7BB970)
        case .lilypadLight:
            return UIColor(hex: 0x95C26F)
        case .lilypadRim:
            return UIColor(hex: 0x38654F)
        case .pond:
            return UIColor(hex: 0x3583EA)
        // Cloudy
        case .cloud:
             return UIColor(hex: 0xFFFFFF)
        // Dark
        case .moon:
             return UIColor(hex: 0xFFFFFF)
        case .moonShadow:
            return UIColor(hex: 0x1E1D22)
        // Sun
        case .sunCenter:
            return UIColor(hex: 0xFDFFD4)
        case .sun:
            return UIColor(hex: 0xFEE600)
        case .sunRim:
            return UIColor(hex: 0xFCD202)
        default:
            return UIColor.white

        }
    }
    
    static func backgroundColor(for environmentType: EnvironmentType, weather: WeatherType) -> UIColor {
        switch environmentType {
        case .frog:
            return Palette.pond(weather: weather).color
        case .bird:
            return Palette.grass(weather: weather).color
        case .bee:
            return Palette.hive(weather: weather).color
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
