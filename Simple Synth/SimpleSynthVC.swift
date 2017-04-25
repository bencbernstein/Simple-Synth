///
///  SimpleSynthVC.swift
///

import Then
import UIKit

class SimpleSynthVC: UIViewController {
    
    let beeButton = UIButton()
    let birdButton = UIButton()
    let frogButton = UIButton()
    
    let conductor = Conductor.sharedInstance

    var environment = Environment() {
        didSet { setupSynth() }
    }
    var no3DTouch = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        // Check if iPhone has force touch
        no3DTouch = self.traitCollection.forceTouchCapability != UIForceTouchCapability.available
        
        // Setup UI
        view.addSubview(environment)
        environment.delegate = self
        environment.layoutView()
        
        // Setup conductor
        setupSynth()
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue:"transitionEnvironment"),
            object: nil,
            queue: nil,
            using: transitionEvironment
        )
    }
    
    func transitionEvironment(notification: Notification) {
        guard
            let environmentString = notification.userInfo?["environment"] as? String,
            let environmentType = EnvironmentType(rawValue: environmentString),
            let weatherString = notification.userInfo?["weather"] as? String,
            let weatherType = WeatherType(rawValue: weatherString)
        else { return }
        
        let newEnvironment = Environment(type: environmentType, weather: weatherType)
        newEnvironment.delegate = self
        newEnvironment.layoutView()
        newEnvironment.alpha = 0
        view.addSubview(newEnvironment)
        
        UIView.animate(withDuration: 0.8, animations: {
            self.environment.alpha = 0
            newEnvironment.alpha = 1
        }) { _ in
            self.environment.removeFromSuperview()
            self.environment = newEnvironment
        }
    }
    
    func setupSynth() {
        switch environment.type {
        case .frog:
            conductor.core.birdMixer.volume = 0
            conductor.core.frogMixer.volume = 1.5
            conductor.core.beeMixer.volume = 0
        case .bird:
            conductor.core.birdMixer.volume = 1.5
            conductor.core.frogMixer.volume = 0
            conductor.core.beeMixer.volume = 0
        case .bee:
            conductor.core.birdMixer.volume = 0
            conductor.core.frogMixer.volume = 0
            conductor.core.beeMixer.volume = 0.8
        }
        
        switch environment.weather {
        case .sunny:
            conductor.MIDINotes = conductor.minorPentatonic
        case .cloudy:
            conductor.MIDINotes = conductor.bluesMinor
        case .dark:
            conductor.MIDINotes = conductor.majorPentatonic
        }
    }
}


protocol KeyInteractionDelegate: class {
    func keyDown(_ key: Key)
    func keyHeld(_ key: Key, currentPressure: CGFloat)
    func keyUp(_ key: Key)
}


extension SimpleSynthVC: KeyInteractionDelegate {
    
    func keyDown(_ key: Key) {
        let MIDINote = conductor.MIDINotes[key.tag]
        conductor.core.play(noteNumber: MIDINote, velocity: 127)
    }
    
    func keyHeld(_ key: Key, currentPressure: CGFloat) {
        if no3DTouch { return }
        conductor.core.amplitude.sustainLevel = Double(currentPressure)
    }
    
    func keyUp(_ key: Key) {
        let MIDINote = conductor.MIDINotes[key.tag]
        conductor.core.stop(noteNumber: MIDINote)
    }
}
