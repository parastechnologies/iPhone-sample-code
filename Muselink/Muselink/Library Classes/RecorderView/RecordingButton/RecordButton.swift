//
//  RecordButton.swift
//  RecordButtonTest
//
//  Created by Mark Alldritt on 2016-12-19.
//  Copyright © 2016 Late Night Software Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import TweenKit

@IBDesignable
class RecordButton: UIButton {
    
    
    private var startPlayer : AVAudioPlayer?
    private var stopPlayer : AVAudioPlayer?
    private var isRecordingScale : CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    @IBInspectable open var playSounds = true
    
    @IBInspectable open var frameColor : UIColor = RecordButtonKit.recordFrameColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable open var isRecording : Bool = false {
        didSet {
            InterpolationAction(from: 0,
                                to: 1,
                                duration: 0.5,
                                easing: .exponentialInOut) {
                                 [unowned self] in
                if isRecording {
                    isRecordingScale = CGFloat($0)
                }
            }
            isRecordingScale = isRecording ? 0.0 : 1.0
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let result = super.beginTracking(touch, with: event)
        
        if playSounds && startPlayer == nil {
            DispatchQueue.main.async { [weak self] in
                let startURL = Bundle.main.url(forResource: "StartRecording", withExtension: "aiff")!
                let stopURL = Bundle.main.url(forResource: "StopRecording", withExtension: "aiff")!
                
                self?.startPlayer = try? AVAudioPlayer(contentsOf: startURL)
                self?.startPlayer?.prepareToPlay()
                self?.stopPlayer = try? AVAudioPlayer(contentsOf: stopURL)
                self?.stopPlayer?.prepareToPlay()
            }
        }
        return result
    }
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if playSounds {
            if isRecording {
                stopPlayer?.play()
            }
            else {
                startPlayer?.play()
            }
        }
        isRecording = !isRecording
        super.sendAction(action, to: target, for: event)
    }
    
    override func draw(_ rect: CGRect) {
        let buttonFrame = bounds
        let pressed = isHighlighted || isTracking
        
        RecordButtonKit.drawRecordButton(frame: buttonFrame,
                                         recordButtonFrameColor:frameColor,
                                         isRecording: isRecordingScale,
                                         isPressed: pressed)
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            super.isHighlighted = isHighlighted
            setNeedsDisplay()
        }
    }
}
