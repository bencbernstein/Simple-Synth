//
//  ViewController.swift
//  Simple Synth
//
//  Created by Benjamin Bernstein on 3/28/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button1: UIButton!
    
    let osc1 = AKOscillator()
    let osc2 = AKOscillator()
    let osc3 = AKOscillator()
    let osc4 = AKOscillator()
    var tones = [AKAmplitudeEnvelope]()
    var envelope1: AKAmplitudeEnvelope?
    var envelope2: AKAmplitudeEnvelope?
    var envelope3: AKAmplitudeEnvelope?
    var envelope4: AKAmplitudeEnvelope?
    var mixer: AKMixer?
    
    @IBAction func soundButton(_ sender: UIButton) {
        toggleSound(pad: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        osc1.frequency = 220
        osc1.amplitude = 0.5
        osc1.start()
        
        osc2.frequency = 440
        osc2.amplitude = 0.5
        osc2.start()
        
        osc3.frequency = 660
        osc3.amplitude = 0.5
        osc3.start()
        
        osc4.frequency = 840
        osc4.amplitude = 0.5
        osc4.start()
        
        envelope1 = AKAmplitudeEnvelope(osc1)
        envelope2 = AKAmplitudeEnvelope(osc2)
        envelope3 = AKAmplitudeEnvelope(osc3)
        envelope4 = AKAmplitudeEnvelope(osc4)
        
        tones.append(envelope1!)
        tones.append(envelope2!)
        tones.append(envelope3!)
        tones.append(envelope4!)
        
        if let envelope = envelope1 {
            envelope.attackDuration = 0.01
            envelope.decayDuration = 0.1
            envelope.sustainLevel = 0.4
            envelope.releaseDuration = 0.5

        }

        mixer = AKMixer(envelope1, envelope2, envelope3, envelope4)

        AudioKit.output = mixer
        AudioKit.start()
        
        setupButtons()
      
    }
    
    func toggleSound(pad: UIButton) {
        tones[pad.tag].isPlaying ? tones[pad.tag].stop() : tones[pad.tag].start()

    }
    
    func setupButtons() {
        button1.backgroundColor = UIColor.blue
        button1.tag = 0
        
        button2.backgroundColor = UIColor.green
        button2.tag = 1
        
        button3.backgroundColor = UIColor.yellow
        button3.tag = 2
        
        button4.backgroundColor = UIColor.brown
        button4.tag = 3
        
        button5.backgroundColor = UIColor.cyan
        button5.tag = 4
        
        
    }
    
    
}

