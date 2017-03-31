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
    
    @IBAction func fingerUp(_ sender: Key) {
        UIView.animate(withDuration: 0.05, animations: {
            sender.backgroundColor = UIColor.clear
        })
        let tone = conductor.tones[sender.tag]
        tone.stop()
    }
    
    
    func key(_ key: Key, didChangePressure: CGFloat) {
        
        UIView.animate(withDuration: 0.05, animations: {
            key.backgroundColor = UIColor.lightGray
            //key.backgroundColor = UIColor(red: 128, green: 128, blue: 128, alpha: 0.3)
        })
        
        let tone = conductor.tones[key.tag]
        let oscillator = conductor.oscillators[key.tag]
        
        oscillator.amplitude = Double(key.currentPressure)
        
        if oscillator.amplitude < 0.1 {
            oscillator.amplitude = 0.1
        }
        if oscillator.amplitude > 1 {
            oscillator.amplitude = 1
        }
        
        print("oscillator amplitude:", oscillator.amplitude)
        tone.play()
    }
   
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

