//
//  AudioPlot.swift
//  Simple Synth
//
//  Created by Benjamin Bernstein on 4/18/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import Foundation
import AudioKit

class AudioPlot: UIView {
    
    var audioInputPlot = EZAudioPlot()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        audioInputPlot.frame = frame
        audioInputPlot.fadeout = true
        self.addSubview(audioInputPlot)
        setupPlot()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPlot() {
        let plot = AKNodeOutputPlot(Conductor.sharedInstance.tracker, frame: audioInputPlot.bounds)
        plot.plotType = .buffer
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = UIColor.black
        audioInputPlot.addSubview(plot)
        
    }
}
