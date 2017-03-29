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
    
    @IBAction func soundButton(_ sender: UIButton) {
        let tone = conductor.tones[sender.tag]
        
        if tone.isPlaying {
            tone.stop()
        }
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            
            tone.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                tone.stop()
                
                UIView.animate(withDuration: 0.2, animations: {
                    sender.backgroundColor = self.colors[sender.tag]
                })
            }
            UIView.animate(withDuration: 0.05) {
                sender.backgroundColor = UIColor.lightGray
            }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        setupButtons()
    }
    
    
    //MARK: Button Setup
    let colors = [0: UIColor.blue, 1: UIColor.green, 2:UIColor.yellow, 3:UIColor.brown, 4:UIColor.cyan, 5: UIColor.purple]
    
    func setupButtons() {
        button1.backgroundColor = UIColor.blue
        button1.tag = 0
        
        button2.backgroundColor = UIColor.green
        button2.tag = 1
        
        button3.backgroundColor = UIColor.red
        button3.tag = 2
        
        button4.backgroundColor = UIColor.yellow
        button4.tag = 3
        
        button5.backgroundColor = UIColor.cyan
        button5.tag = 4
        
        button6.backgroundColor = UIColor.purple
        button6.tag = 5
        
        
    }
    
    
}

