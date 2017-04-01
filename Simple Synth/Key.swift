//
//  Key.swift
//  Simple Synth
//
//  Created by Benjamin Bernstein on 3/29/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import Foundation
import UIKit

protocol KeyDelegate: class {
    func keyDown(_ key: Key)
    func keyHeld(_ key: Key, currentPressure: CGFloat)
    
}

class Key: UIButton {
    
    weak var delegate: KeyDelegate?

    var currentPressure: CGFloat = 0  {
        didSet {
            delegate?.keyHeld(self, currentPressure: currentPressure)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.keyDown(self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
   
        touches.forEach { currentPressure = $0.force/$0.maximumPossibleForce }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.sendActions(for: UIControlEvents.touchUpInside)
    }
    
}
