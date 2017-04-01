//
//  ViewController.swift
//  Simple Synth
//
//  Created by Benjamin Bernstein on 3/28/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, KeyDelegate {
    
    let conductor = Conductor.sharedInstance
    
    @IBOutlet weak var button9: Key!
    @IBOutlet weak var button8: Key!
    @IBOutlet weak var button7: Key!
    @IBOutlet weak var button6: Key!
    @IBOutlet weak var button5: Key!
    @IBOutlet weak var button4: Key!
    @IBOutlet weak var button3: Key!
    @IBOutlet weak var button2: Key!
    @IBOutlet weak var button1: Key!
    
    //MARK: Synthesizer Methods
    @IBAction func fingerUp(_ key: Key) {
        keyUpAnimation(key: key)

        let MIDINote = conductor.MIDINotes[key.tag]
        conductor.oscBank.stop(noteNumber: MIDINote)
    }
    
    func keyHeld(_ key: Key, currentPressure: CGFloat) {
        keyDownAnimation(key: key, currentPressure: currentPressure)
        conductor.amplitude.sustainLevel = Double(currentPressure)

    }
    
    func keyDown(_ key: Key) {
        let MIDINote = conductor.MIDINotes[key.tag]
        conductor.oscBank.play(noteNumber: MIDINote, velocity: 127)

    }
    
}

//MARK: UI
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //makeSlider()
        setupButtons()
    }
}

//MARK: Button Setup
extension ViewController {
    func setupButtons() {
        let buttons = [button1, button2, button3, button4, button5, button6, button7,button8,button9]
        var i = 0
        buttons.forEach {
            $0?.layer.cornerRadius = 20
            $0?.layer.borderWidth = 5
            $0?.layer.borderColor = UIColor.lightGray.cgColor
            $0?.tag = i
            $0?.delegate = self
            i += 1
        }
        
    }
    
}

//MARK: Key Animations
extension ViewController {
    func keyDownAnimation(key: Key, currentPressure: CGFloat) {
        UIView.animate(withDuration: 0.05, animations: {
            key.backgroundColor = UIColor.lightGray.withAlphaComponent(currentPressure * 1.2)
        })
    }
    
    func keyUpAnimation(key: Key) {
        UIView.animate(withDuration: 0.05, animations: {
            key.backgroundColor = UIColor.clear
        })
    }
 
    
}

//MARK: Slider
extension ViewController {
    func makeSlider() {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(slider)
        slider.tintColor = UIColor.lightGray
        
        //slider.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        
        slider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        slider.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        slider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        slider.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
}

