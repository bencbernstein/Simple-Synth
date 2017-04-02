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
    var osc3: AKOscillatorBank
    
    var frogMixer: AKMixer
    var kiwiMixer: AKMixer
    var hornetMixer: AKMixer
    
    var sourceMixer: AKMixer
    var amplitude: AKAmplitudeEnvelope
    
    override init() {
        let sine = AKTable(.sine)
        let triangle = AKTable(.triangle)
        let square = AKTable(.square)
        
        // kiwi
        osc1 = AKOscillatorBank(waveform: sine)
        osc1.rampTime = 0.1
        osc1.attackDuration = 0.1
        osc1.sustainLevel = 0.8
        osc1.decayDuration = 0.1
        osc1.releaseDuration = 0.01
        
        //frog
        osc2 = AKOscillatorBank(waveform: triangle)
        osc2.rampTime = 0.1
        osc2.attackDuration = 0.1
        osc2.sustainLevel = 0.8
        osc2.decayDuration = 0.1
        osc2.releaseDuration = 0.01
        
        //hornet
        osc3 = AKOscillatorBank(waveform: square)
        osc3.rampTime = 0.1
        osc3.attackDuration = 0.1
        osc3.sustainLevel = 0.8
        osc3.decayDuration = 0.1
        osc3.releaseDuration = 0.01
        
        kiwiMixer = AKMixer(osc1)
        kiwiMixer.start()
        
        frogMixer = AKMixer(osc2)
        frogMixer.start()
        
        hornetMixer = AKMixer(osc3)
        hornetMixer.start()
        
        sourceMixer = AKMixer(kiwiMixer, frogMixer, hornetMixer)
        sourceMixer.volume = 1
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
        osc3.play(noteNumber: noteNumber, velocity: velocity)

    }
    
    override func stop(noteNumber: MIDINoteNumber) {
        osc1.stop(noteNumber: noteNumber)
        osc2.stop(noteNumber: noteNumber)
        osc3.stop(noteNumber: noteNumber)

    }
    
}
