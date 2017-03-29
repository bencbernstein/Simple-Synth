//
//  Tone.swift
//  Simple Synth
//
//  Created by Benjamin Bernstein on 3/28/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import Foundation
import AudioKit

class Tone: AKOscillator {
    var storedFreq: Double
    init(frequency: Double) {
        super.init()
        self.storedFreq = frequency
    }
    
    
}
