//
//  Synthesizer.swift
//  Simple Synth
//
//  Created by Benjamin Bernstein on 3/31/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import AudioKit
import AudioToolbox

class Synthesizer: AKMIDIInstrument {
    
    class Note: AKNote {
        var frequency = AKNoteProperty()
    }
    
}
