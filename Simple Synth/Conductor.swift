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
    let osc6 = AKOscillator()
        
    var tones = [AKAmplitudeEnvelope]()
    var oscillators = [AKOscillator]()
    
    var envelope1: AKAmplitudeEnvelope
    var envelope2: AKAmplitudeEnvelope
    var envelope3: AKAmplitudeEnvelope
    var envelope4: AKAmplitudeEnvelope
    var envelope5: AKAmplitudeEnvelope
    var envelope6: AKAmplitudeEnvelope

    
    var reverb: AKCostelloReverb
    var reverbMixer: AKDryWetMixer
    
    var masterVolumeMixer = AKMixer()
    
    init () {
        // oscillators
        let baseFreq = 400.0
        osc1.frequency = baseFreq
        osc2.frequency = baseFreq * 27/24
        osc3.frequency = baseFreq * 30/24
        osc4.frequency = baseFreq * 36/24
        osc5.frequency = baseFreq * 40/24
        osc6.frequency = baseFreq * 48/24
        
        oscillators = [osc1, osc2, osc3, osc4, osc5, osc6]
        oscillators.forEach {$0.amplitude = 0.5; $0.rampTime = 0.1; $0.start() }
        
        // wrap them in amplitude envelopes
        envelope1 = AKAmplitudeEnvelope(osc1)
        envelope2 = AKAmplitudeEnvelope(osc2)
        envelope3 = AKAmplitudeEnvelope(osc3)
        envelope4 = AKAmplitudeEnvelope(osc4)
        envelope5 = AKAmplitudeEnvelope(osc5)
        envelope6 = AKAmplitudeEnvelope(osc6)

        tones = [envelope1, envelope2, envelope3, envelope4, envelope5, envelope6]
        
        tones.forEach {
            $0.attackDuration = 0.1
            $0.decayDuration = 0.3
            $0.sustainLevel = 0.25
            $0.releaseDuration = 0.4
        }

        masterVolumeMixer = AKMixer(envelope1, envelope2, envelope3, envelope4, envelope5, envelope6)

        reverb = AKCostelloReverb(masterVolumeMixer)
        reverb.cutoffFrequency = 300
        reverb.feedback = 0.4
        reverb.play()
        
        reverbMixer = AKDryWetMixer(masterVolumeMixer, reverb, balance: 0.7)

        AudioKit.output = reverbMixer
        AudioKit.start()
        
        
    }
    
    
    
}
