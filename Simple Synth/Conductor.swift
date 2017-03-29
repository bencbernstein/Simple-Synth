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
    
    let osc1 = AKOscillator()
    let osc2 = AKOscillator()
    let osc3 = AKOscillator()
    let osc4 = AKOscillator()
    let osc5 = AKOscillator()
    var tones = [AKAmplitudeEnvelope]()
    
    var envelope1: AKAmplitudeEnvelope
    var envelope2: AKAmplitudeEnvelope
    var envelope3: AKAmplitudeEnvelope
    var envelope4: AKAmplitudeEnvelope
    var envelope5: AKAmplitudeEnvelope
    
    var reverb: AKCostelloReverb
    var reverbMixer: AKDryWetMixer
    
    var masterVolume = AKMixer()
    
    init () {
        
        // oscillators
        let baseFreq = 300.0
        osc1.frequency = baseFreq
        osc2.frequency = baseFreq * 27/24
        osc3.frequency = baseFreq * 30/24
        osc4.frequency = baseFreq * 36/24
        osc5.frequency = baseFreq * 40/24
        
        let oscillators = [osc1, osc2, osc3, osc4, osc5]
        oscillators.forEach {$0.amplitude = 0.5; $0.start() }
        
        // wrap them in amplitude envelopes
        envelope1 = AKAmplitudeEnvelope(osc1)
        envelope2 = AKAmplitudeEnvelope(osc2)
        envelope3 = AKAmplitudeEnvelope(osc3)
        envelope4 = AKAmplitudeEnvelope(osc4)
        envelope5 = AKAmplitudeEnvelope(osc5)
        
        let envelopes = [envelope1, envelope2, envelope3, envelope4, envelope5]
        
        tones = envelopes

        tones.forEach {
            $0.attackDuration = 0.01
            $0.decayDuration = 0.1
            $0.sustainLevel = 0.3
            $0.releaseDuration = 0.3
        }

        masterVolume = AKMixer(envelope1, envelope2, envelope3, envelope4, envelope5)

        reverb = AKCostelloReverb(masterVolume)
        reverb.play()
        
        reverbMixer = AKDryWetMixer(masterVolume, reverb, balance: 2.0)

        AudioKit.output = reverbMixer
        AudioKit.start()
        
        
    }
    
    
    
}
