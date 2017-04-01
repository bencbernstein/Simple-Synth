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
    
    let MIDINotes: [UInt8] = [69,71,73,76,78,81,83,85,88]
    var reverb: AKReverb
    var finalMixer: AKDryWetMixer
    var compressor: AKCompressor
    
    var masterVolumeMixer = AKMixer()

    private init () {

        reverb = AKReverb(core)
        reverb.loadFactoryPreset(.mediumRoom)
        reverb.play()
    
        finalMixer = AKDryWetMixer(core, reverb, balance: 0.5)
        
        compressor = AKCompressor(finalMixer)
        compressor.threshold = -10
        compressor.headRoom = 5
        compressor.attackTime = 0.01
        compressor.masterGain = 5

        AudioKit.output = compressor
        AudioKit.start()
        
    }
    
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        print("received midi in conductor")
        core.play(noteNumber: noteNumber, velocity: velocity)
    }
    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        core.stop(noteNumber: noteNumber)
    }
    

}
