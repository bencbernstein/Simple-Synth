//
//  Key.swift
//  Simple Synth
//
//  Created by Benjamin Bernstein on 3/29/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import Foundation
import UIKit


class Key : UIButton {
    var currentPressure: CGFloat = 0
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { currentPressure = $0.force/$0.maximumPossibleForce }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //currentPressure = 0
        self.sendActions(for: UIControlEvents.touchUpInside)
    }
    
    
    
}
