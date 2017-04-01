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

//    var amplitude: AKAmplitudeEnvelope
//    var reverb: AKReverb
//    var finalMixer: AKDryWetMixer
//    
//    var masterVolumeMixer = AKMixer()

    private init () {
//
//        amplitude = AKAmplitudeEnvelope(core)
//        amplitude.start()
//
//        reverb = AKReverb(amplitude)
//        reverb.loadFactoryPreset(.largeHall)
//        reverb.play()
//    
//        finalMixer = AKDryWetMixer(amplitude, reverb, balance: 0.5)

        AudioKit.output = core
        AudioKit.start()
        
        //self.core.osc1.play(noteNumber: 27, velocity: 127)

    }
    
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        print("received midi in conductor")
        core.play(noteNumber: noteNumber, velocity: velocity)
    }
    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        core.stop(noteNumber: noteNumber)
    }
    

}
