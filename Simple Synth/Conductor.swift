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
    var reverb: AKReverb
    var finalMixer: AKDryWetMixer
    
    let minorPentatonic: [UInt8] = [69,72,74,76,79,81,84,86,88]
    let majorPentatonic: [UInt8] = [69,71,73,76,78,81,83,85,88]
    
    //var compressor: AKCompressor
    
    var masterVolumeMixer = AKMixer()

    private init () {

        MIDINotes = majorPentatonic
        
        reverb = AKReverb(core)
        reverb.loadFactoryPreset(.largeHall)
        reverb.play()
    
        finalMixer = AKDryWetMixer(core, reverb, balance: 0.4)
        
//        compressor = AKCompressor(finalMixer)
//        compressor.threshold = 0
//        compressor.attackTime = 1
//        compressor.releaseTime = 2
//        compressor.masterGain = 3

        AudioKit.output = finalMixer
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
