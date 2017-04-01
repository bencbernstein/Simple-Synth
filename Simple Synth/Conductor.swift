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
    let osc18 = AKOscillator()
    let osc183 = AKOscillator()
    let osc2 = AKOscillator()
    let osc3 = AKOscillator()
    let osc4 = AKOscillator()
    let osc5 = AKOscillator()
    let osc6 = AKOscillator()
    let osc7 = AKOscillator()
    let osc8 = AKOscillator()
    let osc9 = AKOscillator()
    

    var tones = [AKAmplitudeEnvelope]()
    var oscillators = [AKOscillator]()
    
    var envelope1: AKAmplitudeEnvelope
    var envelope2: AKAmplitudeEnvelope
    var envelope3: AKAmplitudeEnvelope
    var envelope4: AKAmplitudeEnvelope
    var envelope5: AKAmplitudeEnvelope
    var envelope6: AKAmplitudeEnvelope
    var envelope7: AKAmplitudeEnvelope
    var envelope8: AKAmplitudeEnvelope
    var envelope9: AKAmplitudeEnvelope
    
    let envelopeMixer = AKMixer()
    
    var reverb: AKReverb
    var finalMixer: AKDryWetMixer
    
    //var compressor: AKCompressor
    
    var masterVolumeMixer = AKMixer()
    
    func testOsc(frequency: Double, rate: Double) -> AKOperation {
        let metro = AKOperation.metronome(frequency: rate)
        let tone = AKOperation.sineWave(frequency: frequency, amplitude: 0.2)
        return tone.triggeredWithEnvelope(trigger: metro, attack: 0.01, hold: 0.1, release: 0.1)
    }
    
    init () {
        // oscillators
        let baseFreq = 400.0
        osc1.frequency = baseFreq
        osc18.frequency = baseFreq * 2/1
        osc18.amplitude = 0.5
        osc18.rampTime = 0.1
        osc18.start()
        
        osc183.frequency = baseFreq * 3/1
        osc183.amplitude = 0.5
        osc183.rampTime = 0.1
        osc183.start()
        
        osc2.frequency = baseFreq * 27/24
        osc3.frequency = baseFreq * 30/24
        osc4.frequency = baseFreq * 36/24
        osc5.frequency = baseFreq * 40/24
        osc6.frequency = baseFreq * 48/24 // 2
        osc7.frequency = baseFreq * 2 * 27/24
        osc8.frequency = baseFreq * 2 * 30/24
        osc9.frequency = baseFreq * 2 * 36/24
        
        oscillators = [osc1, osc2, osc3, osc4, osc5, osc6, osc7, osc8, osc9]
        oscillators.forEach {
            $0.amplitude = 1
            $0.rampTime = 0.1
            $0.start()
        }

        // wrap them in amplitude envelopes
        
        envelopeMixer.connect(osc1)
        envelopeMixer.connect(osc18)
        envelopeMixer.connect(osc183)
        envelopeMixer.start()
        
        envelope1 = AKAmplitudeEnvelope(envelopeMixer)
        
        envelope2 = AKAmplitudeEnvelope(osc2)
        envelope3 = AKAmplitudeEnvelope(osc3)
        envelope4 = AKAmplitudeEnvelope(osc4)
        envelope5 = AKAmplitudeEnvelope(osc5)
        envelope6 = AKAmplitudeEnvelope(osc6)
        envelope7 = AKAmplitudeEnvelope(osc7)
        envelope8 = AKAmplitudeEnvelope(osc8)
        envelope9 = AKAmplitudeEnvelope(osc9)

        tones = [envelope1, envelope2, envelope3, envelope4, envelope5, envelope6, envelope7, envelope8, envelope9]
        
        tones.forEach {
            $0.attackDuration = 0.1
            $0.decayDuration = 0.3
            $0.sustainLevel = 0.8
            $0.releaseDuration = 0.4
        }
        
        // new sound test
        tones[0].attackDuration = 0.1
        tones[0].decayDuration = 0.1
        tones[0].sustainLevel = 0.2
        tones[0].releaseDuration = 0.01
        
        masterVolumeMixer = AKMixer(envelope1, envelope2, envelope3, envelope4, envelope5, envelope6, envelope7, envelope8, envelope9)
        

        reverb = AKReverb(masterVolumeMixer)
        reverb.loadFactoryPreset(.largeHall)
        reverb.play()
        
        finalMixer = AKDryWetMixer(masterVolumeMixer, reverb, balance: 0.5)

        
        AudioKit.output = finalMixer
        AudioKit.start()
        
        
    }
    
   
    
    
    
}
