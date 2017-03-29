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
    let osc5 = AKOscillator()
    var tones = [AKAmplitudeEnvelope]()
    var envelope1: AKAmplitudeEnvelope?
    var envelope2: AKAmplitudeEnvelope?
    var envelope3: AKAmplitudeEnvelope?
    var envelope4: AKAmplitudeEnvelope?
    var envelope5: AKAmplitudeEnvelope?
    var mixer: AKMixer?
    
    @IBAction func soundButton(_ sender: UIButton) {
        toggleSound(pad: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Minor pentatonic just intation 24:27:30:36:40:48
        
        let baseFreq = 200.0
        osc1.frequency = baseFreq
        osc1.rampTime = 0.2
        osc1.amplitude = 0.5
        osc1.start()
        
        osc2.frequency = baseFreq * 27/24
        osc2.amplitude = 0.5
        osc2.start()
        
        osc3.frequency = baseFreq * 30/24
        osc3.amplitude = 0.5
        osc3.start()
        
        osc4.frequency = baseFreq * 36/24
        osc4.amplitude = 0.5
        osc4.start()
        
        osc5.frequency = baseFreq * 40/24
        osc5.amplitude = 0.5
        osc5.start()
        
        envelope1 = AKAmplitudeEnvelope(osc1)
        envelope2 = AKAmplitudeEnvelope(osc2)
        envelope3 = AKAmplitudeEnvelope(osc3)
        envelope4 = AKAmplitudeEnvelope(osc4)
        envelope5 = AKAmplitudeEnvelope(osc5)
        
        tones.append(envelope1!)
        tones.append(envelope2!)
        tones.append(envelope3!)
        tones.append(envelope4!)
        tones.append(envelope5!)
        
            envelope1?.attackDuration = 0.01
            envelope1?.decayDuration = 0.1
            envelope1?.sustainLevel = 0.4
            envelope1?.releaseDuration = 0.5


        mixer = AKMixer(envelope1, envelope2, envelope3, envelope4, envelope5)

        AudioKit.output = mixer
        AudioKit.start()
        
        setupButtons()
      
    }
    
    func toggleSound(pad: UIButton) {
        self.tones[pad.tag].start()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.tones[pad.tag].stop()
            
        }
        

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

