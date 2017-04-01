//
//  GeneratorBank.swift
//  Simple Synth
//
//  Created by Benjamin Bernstein on 4/1/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import Foundation
import AudioKit

class GeneratorBank: AKPolyphonicNode {
    
    var osc1: AKOscillatorBank
    var osc2: AKOscillatorBank
    
    var osc1Mixer: AKMixer
    var osc2Mixer: AKMixer
    
    var sourceMixer: AKMixer
    
    override init() {
        let  sine = AKTable(.sine)
        let square = AKTable(.square)
        
        osc1 = AKOscillatorBank(waveform: sine)
        osc2 = AKOscillatorBank(waveform: square)
        
        osc1Mixer = AKMixer(osc1)
        osc1Mixer.start()
        osc2Mixer = AKMixer(osc2)
        osc2Mixer.start()
        
        sourceMixer = AKMixer(osc1Mixer, osc2Mixer)
        sourceMixer.start()
        super.init()
        
        //conncet it out i think?
        avAudioNode = sourceMixer.avAudioNode
    }
    
    override func play(noteNumber: MIDINoteNumber, velocity: MIDIVelocity) {
        osc1.play(noteNumber: noteNumber, velocity: velocity)
        osc2.play(noteNumber: noteNumber, velocity: velocity)
    }
    
    override func stop(noteNumber: MIDINoteNumber) {
        osc1.stop(noteNumber: noteNumber)
        osc2.stop(noteNumber: noteNumber)
    }
    
}
