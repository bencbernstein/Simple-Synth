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
    
    let birdButton = UIButton()
    let frogButton = UIButton()
    let timeButton = UIButton()
    
    var isDay: Bool = true
    
    //MARK: Synthesizer Methods
    @IBAction func fingerUp(_ key: Key) {
        keyUpAnimation(key: key)
        
        let MIDINote = conductor.MIDINotes[key.tag]
        conductor.core.stop(noteNumber: MIDINote)
    }
    
    func keyHeld(_ key: Key, currentPressure: CGFloat) {
        keyDownAnimation(key: key, currentPressure: currentPressure)
        conductor.core.amplitude.sustainLevel = Double(currentPressure)
    }
    
    func keyDown(_ key: Key) {
        let MIDINote = conductor.MIDINotes[key.tag]
        conductor.core.play(noteNumber: MIDINote, velocity: 127)
        
    }
    
}

//MARK: UI
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        kiwiMode()
        toggleDayNight()
        setupKeys()
        setupButtons()
    }
}

//MARK: Button Setup
extension ViewController {
    func setupKeys() {
        let keys = [button1, button2, button3, button4, button5, button6, button7, button8, button9]
        var i = 0
        keys.forEach {
            $0?.layer.cornerRadius = 20
            $0?.layer.borderWidth = 5
            $0?.layer.borderColor = UIColor.black.cgColor
            $0?.tag = i
            $0?.delegate = self
            i += 1
        }
        
    }
    func setupButtons() {
        let instrumentButtons = [birdButton, frogButton, timeButton]
        instrumentButtons.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
            $0.widthAnchor.constraint(equalTo: button1.widthAnchor, multiplier: 1).isActive = true
            $0.heightAnchor.constraint(equalTo: button1.heightAnchor, multiplier: 1).isActive = true
           
        }
        
        birdButton.leftAnchor.constraint(equalTo: button3.rightAnchor, constant: 30).isActive = true
        birdButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        birdButton.addTarget(self, action: #selector(kiwiMode), for: .touchUpInside)
        
        frogButton.leftAnchor.constraint(equalTo: button3.rightAnchor, constant: 30).isActive = true
        frogButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60).isActive = true
        frogButton.addTarget(self, action: #selector(frogMode), for: .touchUpInside)
        
        timeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        timeButton.rightAnchor.constraint(equalTo: button4.leftAnchor, constant: -30).isActive = true
        timeButton.addTarget(self, action: #selector(toggleDayNight), for: .touchUpInside)
    }
    
    func frogMode() {
        birdButton.setImage(#imageLiteral(resourceName: "Kiwi Bird-100"), for: .normal)
        frogButton.setImage(#imageLiteral(resourceName: "Frog Filled-100"), for: .normal)
        conductor.core.kiwiMixer.volume = 0
        conductor.core.frogMixer.volume = 0.7
    }
    
    func kiwiMode() {
        birdButton.setImage(#imageLiteral(resourceName: "Kiwi Bird Filled-100"), for: .normal)
        frogButton.setImage(#imageLiteral(resourceName: "Frog-100"), for: .normal)
        conductor.core.kiwiMixer.volume = 1
        conductor.core.frogMixer.volume = 0
    }
    
    func toggleDayNight() {
        if isDay {
            timeButton.setImage(#imageLiteral(resourceName: "Sun"), for: .normal)
            conductor.MIDINotes = conductor.majorPentatonic
            isDay = false
        } else {
            timeButton.setImage(#imageLiteral(resourceName: "Moon"), for: .normal)
            conductor.MIDINotes = conductor.minorPentatonic
            isDay = true
        }
    }
}

//MARK: Key Animations
extension ViewController {
    func keyDownAnimation(key: Key, currentPressure: CGFloat) {
        UIView.animate(withDuration: 0.05, animations: {
            key.backgroundColor = UIColor.black.withAlphaComponent(currentPressure)
        })
    }
    
    func keyUpAnimation(key: Key) {
        UIView.animate(withDuration: 0.05, animations: {
            key.backgroundColor = UIColor.clear
        })
    }
    
    
}

