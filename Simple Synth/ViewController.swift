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
    
    let conductor = Conductor.sharedInstance
    
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button1: UIButton!
    
    @IBAction func soundButton(_ sender: UIButton) {
        toggleSound(pad: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    func toggleSound(pad: UIButton) {
        // TODO: maybe make a new tone, play it, remove it ...
        
        conductor.tones[pad.tag].start()
        pad.backgroundColor = UIColor.lightGray
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.conductor.tones[pad.tag].stop()
            pad.backgroundColor = self.colors[pad.tag]
        }
    }
    
    let colors = [0: UIColor.blue, 1: UIColor.green, 2:UIColor.yellow, 3:UIColor.brown, 4:UIColor.cyan]
    
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

