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
    
    var tones = [AKOscillator()]
    
    
    @IBAction func soundButton(_ sender: UIButton) {
        toggleSound(pad: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...5 {
            let newTone = AKOscillator()
            newTone.frequency = 220 * i
            newTone.add
            tones.append(newTone)
        }
        
        let mixer = AKMixer()
        tones.forEach { mixer.connect($0) }
        
        AudioKit.output = mixer
        AudioKit.start()
        setupButtons()
        
    }
    
    func toggleSound(pad: UIButton) {
        tones[pad.tag].isPlaying ? tones[pad.tag].stop() : tones[pad.tag].start()
    }
    
    func setupButtons() {
        button1.backgroundColor = UIColor.blue
        button1.tag = 1
        
        button2.backgroundColor = UIColor.green
        button2.tag = 2
        
        button3.backgroundColor = UIColor.yellow
        button3.tag = 3
        
        button4.backgroundColor = UIColor.brown
        button4.tag = 4
        
        button5.backgroundColor = UIColor.cyan
        button5.tag = 5
        
        
    }
    
    
}

