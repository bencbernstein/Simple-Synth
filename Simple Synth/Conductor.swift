//
//  Conductor.swift
//  Simple Synth
//
//  Created by Benjamin Bernstein on 3/29/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import AudioKit

final class Conductor: AKMIDIListener {
    
    static let sharedInstance = Conductor()
    
    var tracker = AKFrequencyTracker(nil)
    var core = GeneratorBank()
    
    var MIDINotes: [UInt8]
    let minorPentatonic: [UInt8] = [69,72,74,76,79,81,84,86,88]
    let majorPentatonic: [UInt8] = [69,71,73,76,78,81,83,85,88]
    
    var reverb: AKReverb
    var delay: AKDelay
    
    let shortDelay = 0.15
    let mediumDelay = 0.3
    let longDelay = 0.6
    
    var audioInputPlot: EZAudioPlot!
    
    var finalMixer: AKDryWetMixer
    
    private init () {
        
        //major... 440. 600, 880, 1240 roughly
        
        MIDINotes = majorPentatonic
        
        delay = AKDelay(core)
        delay.feedback = 0.8
        delay.time = shortDelay
        delay.dryWetMix = 0.3
        delay.bypass()
        
        reverb = AKReverb(core)
        reverb.loadFactoryPreset(.largeHall)
        reverb.play()
        
        finalMixer = AKDryWetMixer(delay, reverb, balance: 0.4)
        
        tracker = AKFrequencyTracker(finalMixer, hopSize: 100, peakCount: 500)
        
        AudioKit.output = tracker
        AKSettings.playbackWhileMuted = true
        try? AKSettings.setSession(category: .playback)
        try? AKSettings.session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        AudioKit.start()
    }
    
    func nextDelay() {
        
        if delay.isBypassed {
            delay.time = shortDelay
            delay.start()
        } else if delay.time == shortDelay {
            delay.time = mediumDelay
        } else if delay.time ==  mediumDelay {
            delay.time = longDelay
        }
        else if delay.time == longDelay {
            delay.bypass()
        }
        
    }
    
    func previousDelay() {
        
        if delay.isBypassed {
            delay.time = longDelay
            delay.start()
        } else if delay.time == shortDelay {
            delay.bypass()
        } else if delay.time ==  mediumDelay {
            delay.time = shortDelay
        }
        else if delay.time == longDelay {
            delay.time = mediumDelay
        }
        
    }
    
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        core.play(noteNumber: noteNumber, velocity: velocity)
    }
    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        core.stop(noteNumber: noteNumber)
    }
}
