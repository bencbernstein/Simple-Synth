//
//  Conductor.swift
//  Simple Synth
//
//  Created by Benjamin Bernstein on 3/29/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import Foundation
import AudioKit

final class Conductor {
    
    static let sharedInstance = Conductor()
    
    var sawtoothOscillators =  AKOscillatorBank(waveform: AKTable(.sawtooth))
    
    var morphing = AKMorphingOscillator()
    var oscBank = AKOscillatorBank()
    
    let MIDINotes: [UInt8] = [69,71,73,76,78,81,83,85,88]

    var amplitude: AKAmplitudeEnvelope
    var amplitude2: AKAmplitudeEnvelope
    var reverb: AKReverb
    var finalMixer: AKDryWetMixer
    
    var masterVolumeMixer = AKMixer()

    init () {
        
        // Saw
        sawtoothOscillators.attackDuration = 0.1
        sawtoothOscillators.decayDuration = 0.1
        sawtoothOscillators.releaseDuration = 0.1
        sawtoothOscillators.rampTime = 0.1
        
        // Sine
        oscBank.attackDuration = 0.1
        oscBank.decayDuration = 0.1
        oscBank.releaseDuration = 0.1
        oscBank.rampTime = 0.2
        
        amplitude = AKAmplitudeEnvelope(oscBank)
        amplitude.start()
        
        amplitude2 = AKAmplitudeEnvelope(sawtoothOscillators)
        amplitude2.stop()

        reverb = AKReverb(amplitude)
        reverb.addConnectionPoint(amplitude2)
        reverb.loadFactoryPreset(.largeHall)
        reverb.play()
        
    
        finalMixer = AKDryWetMixer(amplitude2, reverb, balance: 0.5)

        AudioKit.output = finalMixer
        AudioKit.start()
        
    }
    

}
