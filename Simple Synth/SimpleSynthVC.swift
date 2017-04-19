///
///  SimpleSynthVC.swift
///

import UIKit

protocol KeyInteractionDelegate: class {
    func keyDown(_ shape: Shape)
    func keyHeld(_ shape: Shape, currentPressure: CGFloat)
    func keyUp(_ shape: Shape)
}

class SimpleSynthVC: UIViewController, KeyInteractionDelegate {
    
    let conductor = Conductor.sharedInstance
    
    let birdButton = UIButton()
    let frogButton = UIButton()
    let hornetButton = UIButton()
    
    let delayButton = UIButton()
    let timeButton = UIButton()
    
    var environmentType: EnvironmentType = .frog
    var isDay = true
    var is3DTouchAvailable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        is3DTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapability.available
        setupEnvironment()
        frogMode()
        toggleDayNight()
        // setupButtons()
        // addAudioPlot()
    }
    
    func setupEnvironment() {
        let environment = Environment(type: environmentType, frame: view.frame, delegate: self)
        view.addSubview(environment)
    }
    
    func keyDown(_ shape: Shape) {
        let MIDINote = conductor.MIDINotes[shape.tag]
        conductor.core.play(noteNumber: MIDINote, velocity: 127)
    }
    
    func keyHeld(_ key: Shape, currentPressure: CGFloat) {
        if is3DTouchAvailable { conductor.core.amplitude.sustainLevel = Double(currentPressure) }
    }
    
    func keyUp(_ shape: Shape) {
        let MIDINote = conductor.MIDINotes[shape.tag]
        conductor.core.stop(noteNumber: MIDINote)
    }
}

//MARK: - Button Setup
extension SimpleSynthVC {
    
    func setupButtons() {
//        let instrumentButtons = [birdButton, frogButton, hornetButton, timeButton]
//        instrumentButtons.forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            self.view.addSubview($0)
//            $0.widthAnchor.constraint(equalTo: button1.widthAnchor, multiplier: 1).isActive = true
//            $0.heightAnchor.constraint(equalTo: button1.heightAnchor, multiplier: 1).isActive = true
//        }
//        
//        birdButton.leftAnchor.constraint(equalTo: button3.rightAnchor, constant: 30).isActive = true
//        birdButton.centerYAnchor.constraint(equalTo: button3.centerYAnchor).isActive = true
//        birdButton.addTarget(self, action: #selector(birdMode), for: .touchUpInside)
//        
//        frogButton.leftAnchor.constraint(equalTo: button3.rightAnchor, constant: 30).isActive = true
//        frogButton.centerYAnchor.constraint(equalTo: button6.centerYAnchor).isActive = true
//        frogButton.addTarget(self, action: #selector(frogMode), for: .touchUpInside)
//        
//        hornetButton.leftAnchor.constraint(equalTo: button3.rightAnchor, constant: 30).isActive = true
//        hornetButton.centerYAnchor.constraint(equalTo: button9.centerYAnchor).isActive = true
//        hornetButton.addTarget(self, action: #selector(hornetMode), for: .touchUpInside)
//        
//        delayButton.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(delayButton)
//        delayButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
//        delayButton.widthAnchor.constraint(equalTo: button1.widthAnchor, multiplier: 0.9).isActive = true
//        delayButton.heightAnchor.constraint(equalTo: button1.heightAnchor, multiplier: 0.9).isActive = true
//        delayButton.rightAnchor.constraint(equalTo: button1.leftAnchor, constant: -30).isActive = true
//        delayButton.setImage(#imageLiteral(resourceName: "CLOCK-NO"), for: .normal)
//        delayButton.addTarget(self, action: #selector(nextDelayMode), for: .touchUpInside)
//        
//        timeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60).isActive = true
//        timeButton.rightAnchor.constraint(equalTo: button4.leftAnchor, constant: -30).isActive = true
//        timeButton.addTarget(self, action: #selector(toggleDayNight), for: .touchUpInside)
    }
    
    func frogMode() {
//        birdButton.setImage(#imageLiteral(resourceName: "Hummingbird-100"), for: .normal)
//        frogButton.setImage(#imageLiteral(resourceName: "Frog Filled-100"), for: .normal)
//        hornetButton.setImage(#imageLiteral(resourceName: "Hornet-100"), for: .normal)
        conductor.core.birdMixer.volume = 0
        conductor.core.frogMixer.volume = 1.5
        conductor.core.hornetMixer.volume = 0
    }
    
    func birdMode() {
//        birdButton.setImage(#imageLiteral(resourceName: "Hummingbird Filled-100"), for: .normal)
//        frogButton.setImage(#imageLiteral(resourceName: "Frog-100"), for: .normal)
//        hornetButton.setImage(#imageLiteral(resourceName: "Hornet-100"), for: .normal)
        conductor.core.birdMixer.volume = 1.5
        conductor.core.frogMixer.volume = 0
        conductor.core.hornetMixer.volume = 0
    }
    
    func hornetMode() {
//        birdButton.setImage(#imageLiteral(resourceName: "Hummingbird-100"), for: .normal)
//        frogButton.setImage(#imageLiteral(resourceName: "Frog-100"), for: .normal)
//        hornetButton.setImage(#imageLiteral(resourceName: "Hornet Filled-100"), for: .normal)
        conductor.core.birdMixer.volume = 0
        conductor.core.frogMixer.volume = 0
        conductor.core.hornetMixer.volume = 0.8
    }
    
    func nextDelayMode() {
        if conductor.delay.isBypassed {
            conductor.delay.time = conductor.shortDelay
            conductor.delay.start()
            delayButton.setImage(#imageLiteral(resourceName: "CLOCK-SHORT"), for: .normal)
        } else if conductor.delay.time == conductor.shortDelay {
            conductor.delay.time = conductor.mediumDelay
            delayButton.setImage(#imageLiteral(resourceName: "CLOCK-MEDIUM"), for: .normal)
        } else if conductor.delay.time == conductor.mediumDelay {
            conductor.delay.time = conductor.longDelay
            delayButton.setImage(#imageLiteral(resourceName: "CLOCK-LONG"), for: .normal)
        }
        else if conductor.delay.time == conductor.longDelay {
            conductor.delay.bypass()
            delayButton.setImage(#imageLiteral(resourceName: "CLOCK-NO"), for: .normal)
        }
    }
    
    func toggleDayNight() {
        if isDay {
            // timeButton.setImage(#imageLiteral(resourceName: "Sun"), for: .normal)
            conductor.MIDINotes = conductor.majorPentatonic
            isDay = false
        } else {
            // timeButton.setImage(#imageLiteral(resourceName: "Moon"), for: .normal)
            conductor.MIDINotes = conductor.minorPentatonic
            isDay = true
        }
    }
}

// MARK: - Audio Plot
extension SimpleSynthVC {
    
    func addAudioPlot() {
        let audioPlot = AudioPlot(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        audioPlot.alpha = 0.4
        audioPlot.layer.zPosition = -1
        audioPlot.translatesAutoresizingMaskIntoConstraints = false
        audioPlot.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        audioPlot.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        view.addSubview(audioPlot)
    }
}
