//
//  MorseSignal.swift
//  MorseCode
//
//  Created by Mattias Jähnke on 26/07/16.
//  Copyright © 2016 Mattias Jähnke. All rights reserved.
//

import Foundation

/// `MorseSignal` can emit a more signal (high/low) with a given frequency (ms per dot)
public class MorseSignal {
    public enum Signal {
        case high
        case low
        case finished
    }
    
    private let dotDuration: NSTimeInterval
    private let morse: Morse
    private let change: Signal -> ()
    private let repeating: Bool
    
    private var morseString = ""
    private var timer: NSTimer?
    
    private var currentState = Signal.low {
        didSet {
            if oldValue != currentState {
                change(currentState)
            }
        }
    }
    
    public init(morse: Morse, dotDuration: NSTimeInterval = 50, repeating: Bool = false, change: Signal -> ()) {
        self.morse = morse
        self.dotDuration = dotDuration
        self.change = change
        self.repeating = repeating
    }
    
    public func start() {
        if timer != nil { stop() }
        
        morseString = tickerizeMorseString(morse.morseString)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(dotDuration / 1000,
                                                       target: self,
                                                       selector: #selector(MorseSignal.tick),
                                                       userInfo: nil,
                                                       repeats: true)
    }
    
    public func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func tickerizeMorseString(string: String) -> String {
        return string.componentsSeparatedByString(" / ").map { word in
            return word.componentsSeparatedByString(" ").map { char in
                var s = char.characters.reduce("", combine: {"\($0)\($1)?" })
                s.removeAtIndex(s.endIndex.predecessor())
                return s
            }.joinWithSeparator("%%%")
        }.joinWithSeparator("%%%%%%%").stringByReplacingOccurrencesOfString("-", withString: "---")
    }
    
    @objc
    private func tick() {
        guard !morseString.isEmpty else {
            stop()
            if repeating {
                start()
            } else {
                currentState = .finished
            }
            return
        }
        let char = morseString.removeAtIndex(morseString.startIndex)
        switch char {
        case Character("."), Character("-"):
            currentState = .high
        default:
            currentState = .low
        }
    }
}