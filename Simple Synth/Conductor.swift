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
    
    var core = GeneratorBank()
    
    var MIDINotes: [UInt8]
    let minorPentatonic: [UInt8] = [69,72,74,76,79,81,84,86,88]
    let majorPentatonic: [UInt8] = [69,71,73,76,78,81,83,85,88]
    
    var reverb: AKReverb
    var delay: AKDelay
    
    let shortDelay = 0.3
    let mediumDelay = 0.6
    let longDelay = 1.2
    
    var finalMixer: AKDryWetMixer
    
    private init () {

        MIDINotes = majorPentatonic
        
        delay = AKDelay(core)
        delay.feedback = 0.8
        delay.time = shortDelay
        delay.bypass()
        
        reverb = AKReverb(core)
        reverb.loadFactoryPreset(.largeHall)
        reverb.play()
        
        finalMixer = AKDryWetMixer(delay, reverb, balance: 0.4)
        
        AudioKit.output = finalMixer
        AudioKit.start()
        
    }
    
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        core.play(noteNumber: noteNumber, velocity: velocity)
    }
    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        core.stop(noteNumber: noteNumber)
    }
    

}
