///
///  SimpleSynthVC.swift
///

import Then
import UIKit

class SimpleSynthVC: UIViewController {
    
    let conductor = Conductor.sharedInstance
    
    let birdButton = UIButton()
    let frogButton = UIButton()
    let hornetButton = UIButton()
    
    let delayButton = UIButton()
    let timeButton = UIButton()
    
    var environmentType: EnvironmentType = .bird
    var environment = Environment(type: .bird) {
        didSet {
            setupSynth()
        }
    }
    var isDay = true {
        didSet {
            conductor.MIDINotes = isDay ? conductor.minorPentatonic : conductor.majorPentatonic
            timeButton.setImage((isDay ? #imageLiteral(resourceName: "Sun") : #imageLiteral(resourceName: "Moon")), for: .normal)
        }
    }
    var no3DTouch = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        no3DTouch = self.traitCollection.forceTouchCapability != UIForceTouchCapability.available
        view.addSubview(environment)
        environment.delegate = self
        environment.layoutView()
        setupSynth()
        isDay = !isDay
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue:"transitionEnvironment"),
            object: nil,
            queue: nil,
            using: transitionEvironment
        )
    }
    
    func transitionEvironment(notification: Notification) {
        guard
            let type = notification.userInfo?["environment"] as? String,
            let environmentType = EnvironmentType(rawValue: type)
        else { return }
        
        let newEnvironment = Environment(type: environmentType)
        newEnvironment.delegate = self
        newEnvironment.layoutView()
        newEnvironment.alpha = 0
        view.addSubview(newEnvironment)
        
        UIView.animate(withDuration: 0.8, animations: {
            self.environment.alpha = 0
            newEnvironment.alpha = 1
        }) { success in
            self.environment.removeFromSuperview()
            self.environment = newEnvironment
        }
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
    
    func setupSynth() {
        switch environment.type {
        case .frog:
            conductor.core.birdMixer.volume = 0
            conductor.core.frogMixer.volume = 1.5
            conductor.core.hornetMixer.volume = 0
        case .bird:
            conductor.core.birdMixer.volume = 1.5
            conductor.core.frogMixer.volume = 0
            conductor.core.hornetMixer.volume = 0
//        case .bee:
//            conductor.core.birdMixer.volume = 0
//            conductor.core.frogMixer.volume = 0
//            conductor.core.hornetMixer.volume = 0.8
        }
    }
}


protocol KeyInteractionDelegate: class {
    func keyDown(_ shape: Shape)
    func keyHeld(_ shape: Shape, currentPressure: CGFloat)
    func keyUp(_ shape: Shape)
}


extension SimpleSynthVC: KeyInteractionDelegate {
    
    func keyDown(_ shape: Shape) {
        let MIDINote = conductor.MIDINotes[shape.tag]
        conductor.core.play(noteNumber: MIDINote, velocity: 127)
    }
    
    func keyHeld(_ shape: Shape, currentPressure: CGFloat) {
        if no3DTouch { return }
        conductor.core.amplitude.sustainLevel = Double(currentPressure)
    }
    
    func keyUp(_ shape: Shape) {
        let MIDINote = conductor.MIDINotes[shape.tag]
        conductor.core.stop(noteNumber: MIDINote)
    }
}
