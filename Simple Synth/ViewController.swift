//
//  ViewController.swift
//  Simple Synth
//
//  Created by Benjamin Bernstein on 3/28/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import UIKit
import AudioKit
import AudioToolbox

class ViewController: UIViewController {
    
    let conductor = Conductor.sharedInstance
    
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button1: UIButton!
    
    @IBAction func fingerUp(_ sender: Key) {
        UIView.animate(withDuration: 0.05, animations: {
            sender.backgroundColor = UIColor.clear
        })
        let tone = conductor.tones[sender.tag]
        tone.stop()
    }
   
    
    @IBAction func fingerDown(_ sender: Key) {

        UIView.animate(withDuration: 0.05, animations: {
            sender.backgroundColor = UIColor.lightGray
        })
        let tone = conductor.tones[sender.tag]
        let oscillator = conductor.oscillators[sender.tag]
        
        oscillator.amplitude = Double(sender.currentPressure)
        
        if oscillator.amplitude < 0.1 {
            oscillator.amplitude = 0.1
        }
        print("osc amplitude", oscillator.amplitude)
        tone.play()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        setupButtons()
    }
    
    //MARK: Button Setup
    func setupButtons() {
        let buttons = [button1, button2, button3, button4, button5, button6]
        buttons.forEach {
            $0?.layer.cornerRadius = 20
            $0?.layer.borderWidth = 5
            $0?.layer.borderColor = UIColor.lightGray.cgColor
        }
        

        button1.tag = 0
        button2.tag = 1
        button3.tag = 2
        button4.tag = 3
        button5.tag = 4
        button6.tag = 5
        
        
    }
    
    
}

