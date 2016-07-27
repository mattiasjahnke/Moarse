//
//  MorseGestureRecognizer.swift
//  MorseCode
//
//  Created by Mattias Jähnke on 26/07/16.
//  Copyright © 2016 Mattias Jähnke. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

public class MorseGestureRecognizer: UIGestureRecognizer {
    public var dotDuration: NSTimeInterval = 50
    public var lastResolvedCharacter: String?
    
    private var lastPress: NSDate?
    private var currentTapBegan: NSDate!
    private var currentMorseString = ""
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        if currentMorseString.isEmpty {
            state = .Began
        }
        
        currentTapBegan = NSDate()
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self,
                                                         selector: #selector(MorseGestureRecognizer.resolveCharacter),
                                                         object: nil)
    }
    
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        let length = NSDate().timeIntervalSinceDate(currentTapBegan)
        
        // Decide if dot or dash
        if abs(dotDuration / 1000 - length) <= abs(dotDuration * 3 / 1000 - length) {
            currentMorseString += "."
        } else {
            currentMorseString += "-"
        }
        
        self.performSelector(#selector(MorseGestureRecognizer.resolveCharacter),
                             withObject: nil,
                             afterDelay: dotDuration / 1000 * 7)
    }
    
    @objc
    private func resolveCharacter() {
        // Add fail when Morse init is optional
        lastResolvedCharacter = Morse(morseString: currentMorseString).clearText
        state = .Ended
        currentMorseString = ""
    }
}
