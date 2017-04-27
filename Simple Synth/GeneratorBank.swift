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
    
    var hummingbirdOscillator: AKOscillatorBank
    var frogOsccillator: AKOscillatorBank
    var beeOscillator: AKOscillatorBank
    
    var frogMixer: AKMixer
    var birdMixer: AKMixer
    var beeMixer: AKMixer
    
    var sourceMixer: AKMixer
    var amplitude: AKAmplitudeEnvelope
    
    override init() {
        let sine = AKTable(.sine)
        let triangle = AKTable(.triangle)
        let square = AKTable(.square)
        
        hummingbirdOscillator = AKOscillatorBank(waveform: sine)
        hummingbirdOscillator.rampTime = 0.1
        hummingbirdOscillator.attackDuration = 0.1
        hummingbirdOscillator.sustainLevel = 0.8
        hummingbirdOscillator.decayDuration = 0.3
        hummingbirdOscillator.releaseDuration = 0.2
        
        frogOsccillator = AKOscillatorBank(waveform: triangle)
        frogOsccillator.rampTime = 0.1
        frogOsccillator.attackDuration = 0.1
        frogOsccillator.sustainLevel = 0.8
        frogOsccillator.decayDuration = 0.3
        frogOsccillator.releaseDuration = 0.2
        
        beeOscillator = AKOscillatorBank(waveform: square)
        beeOscillator.rampTime = 0.1
        beeOscillator.attackDuration = 0.1
        beeOscillator.sustainLevel = 0.8
        beeOscillator.decayDuration = 0.3
        beeOscillator.releaseDuration = 0.2
        
        birdMixer = AKMixer(hummingbirdOscillator)
        birdMixer.start()
        
        frogMixer = AKMixer(frogOsccillator)
        frogMixer.start()
        
        beeMixer = AKMixer(beeOscillator)
        beeMixer.start()
        
        sourceMixer = AKMixer(birdMixer, frogMixer, beeMixer)
        sourceMixer.start()
        
        amplitude = AKAmplitudeEnvelope(sourceMixer)
        amplitude.rampTime = 0.1
        amplitude.start()
       
        super.init()

        //connect to the top
        avAudioNode = amplitude.avAudioNode
    }
    
    override func play(noteNumber: MIDINoteNumber, velocity: MIDIVelocity) {
        hummingbirdOscillator.play(noteNumber: noteNumber, velocity: velocity)
        frogOsccillator.play(noteNumber: noteNumber, velocity: velocity)
        beeOscillator.play(noteNumber: noteNumber, velocity: velocity)
    }
    
    override func stop(noteNumber: MIDINoteNumber) {
        hummingbirdOscillator.stop(noteNumber: noteNumber)
        frogOsccillator.stop(noteNumber: noteNumber)
        beeOscillator.stop(noteNumber: noteNumber)
    }
}
