///
/// Environment.swift
///

import UIKit

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
        return [1,2,3,4].map { UIImage(named: "\(rawValue)\($0)")! }
    }
    
    func backgroundColor(for weather: WeatherType) -> UIColor {
        return Palette.backgroundColor(for: self, weather: weather)
    }
}


// MARK: - Key Type
enum KeyType {
    
    case honeycomb, lilypad, flower
    
    var size: CGSize { return CGSize(width: 100, height: 100) }
}


// MARK: - Weather Type
enum WeatherType: String {
    
    case cloudy, dark, sunny
    
    var size: CGSize { return CGSize(width: 100, height: 100 ) }
}
