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
    var osc1EQ: AKEqualizerFilter
    
    var frogMixer: AKMixer
    var kiwiMixer: AKMixer
    
    var sourceMixer: AKMixer
    var amplitude: AKAmplitudeEnvelope
    
    override init() {
        let sine = AKTable(.sine)
        let square = AKTable(.square)
        
        // kiwi
        osc1 = AKOscillatorBank(waveform: sine)
        osc1.rampTime = 0.1
        osc1.attackDuration = 0.1
        osc1.sustainLevel = 0.8
        osc1.decayDuration = 0.1
        osc1.releaseDuration = 0.01
        
        osc1EQ = AKEqualizerFilter(osc1)
        osc1EQ.centerFrequency = 3000
        osc1EQ.gain = -30
        
        //frog
        osc2 = AKOscillatorBank(waveform: square)
        osc2.rampTime = 0.1
        osc2.attackDuration = 0.1
        osc2.sustainLevel = 0.8
        osc2.decayDuration = 0.2
        osc2.releaseDuration = 0.2
        
        kiwiMixer = AKMixer(osc1EQ)
        kiwiMixer.start()
        
        frogMixer = AKMixer(osc2)
        frogMixer.start()
        
        sourceMixer = AKMixer(kiwiMixer, frogMixer)
        sourceMixer.start()
        
        amplitude = AKAmplitudeEnvelope(sourceMixer)
        amplitude.rampTime = 0.1
        amplitude.start()
       
        super.init()

        //connect to the top
        avAudioNode = amplitude.avAudioNode
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
