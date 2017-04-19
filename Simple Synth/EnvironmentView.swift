///
/// EnvironmentView.swift
///

import UIKit

enum EnvironmentType {
    
    case frog
    
    var key: ShapeType {
        switch self {
        case .frog:
            return .lilypad
        }
    }
    
    var backgroundColor: UIColor {
        return Palette.backgroundColor(for: self)
    }
}

class Environment: UIView {
    
    let type: EnvironmentType
    var keyType: ShapeType { return type.key }
    
    weak var delegate: KeyInteractionDelegate?
    
    init(type: EnvironmentType, frame: CGRect, delegate: KeyInteractionDelegate) {
        self.type = type
        self.delegate = delegate
        super.init(frame: frame)
        
        self.backgroundColor = type.backgroundColor
        layoutKeys()
    }
    
    func layoutKeys() {
        for (index, origin) in keyOrigins.enumerated() {
            let key = Shape(origin: origin, type: keyType)
            key.tag = index
            key.delegate = delegate
            self.addSubview(key)
        }
    }
    
    var keyOrigins: [CGPoint] {
        var origins: [CGPoint] = []
        let displacements: [CGFloat] = [-130, 0, 130]
        let centerOrigin = (frame.width / 2 - 50, frame.height / 2 - 50)
        displacements.forEach { xDisplacement in
            displacements.forEach { yDisplacement in
                let origin = CGPoint(x: centerOrigin.0 + CGFloat(xDisplacement), y: centerOrigin.1 + yDisplacement)
                origins.append(origin)
            }
        }
        return origins
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
