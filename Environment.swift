///
/// Environment.swift
///

import UIKit

struct EnvironmentPresets {
    let type: EnvironmentType
    let weather: WeatherType
}

// MARK: - Environment Type
enum EnvironmentType: String {
    
    case bee, bird, frog
    
    static var all = [bee, bird, frog]
    
    var key: KeyType {
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


// MARK: - Key Type
enum KeyType {
    
    case honeycomb, lilypad, flower
    
    var size: CGSize { return CGSize(width: 100, height: 100) }
}


// MARK: - Weather Type
enum WeatherType {
    
    case cloudy, dark, sunny
    
    var size: CGSize { return CGSize(width: 75, height: 75) }
}
