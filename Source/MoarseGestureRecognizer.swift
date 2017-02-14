//
//  MoarseGestureRecognizer.swift
//
//  Created by Mattias Jähnke on 26/07/16.
//  Copyright © 2016 Mattias Jähnke. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

public class MorseGestureRecognizer: UIGestureRecognizer {
    public var dotDuration: TimeInterval = 50
    public var lastResolvedCharacter: String?
    
    private var lastPress: Date?
    private var currentTapBegan: Date!
    private var currentMorseString = ""
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        
        if currentMorseString.isEmpty {
            state = .began
        }
        
        currentTapBegan = Date()
        
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                                         selector: #selector(MorseGestureRecognizer.resolveCharacter),
                                                         object: nil)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        
        let length = Date().timeIntervalSince(currentTapBegan)
        
        // Decide if dot or dash
        if abs(dotDuration / 1000 - length) <= abs(dotDuration * 3 / 1000 - length) {
            currentMorseString += "."
        } else {
            currentMorseString += "-"
        }
        
        self.perform(#selector(MorseGestureRecognizer.resolveCharacter),
                             with: nil,
                             afterDelay: dotDuration / 1000 * 7)
    }
    
    @objc private func resolveCharacter() {
        // Add fail when Morse init is optional
        lastResolvedCharacter = Morse(morseString: currentMorseString).clearText
        state = .ended
        currentMorseString = ""
    }
}
