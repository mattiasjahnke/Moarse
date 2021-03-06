//
//  MorseSignal.swift
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
    
    private let dotDuration: TimeInterval
    private let morse: Morse
    private let change: (Signal) -> ()
    private let repeating: Bool
    
    private var morseString = ""
    private var timer: Timer?
    
    private var currentState = Signal.low {
        didSet {
            if oldValue != currentState {
                change(currentState)
            }
        }
    }
    
    public init(morse: Morse, dotDuration: TimeInterval = 50, repeating: Bool = false, change: @escaping (Signal) -> ()) {
        self.morse = morse
        self.dotDuration = dotDuration
        self.change = change
        self.repeating = repeating
    }
    
    public func start() {
        if timer != nil { stop() }
        
        morseString = tickerizeMorseString(morse.morseString)
        
        timer = Timer.scheduledTimer(timeInterval: dotDuration / 1000,
                                                       target: self,
                                                       selector: #selector(MorseSignal.tick),
                                                       userInfo: nil,
                                                       repeats: true)
    }
    
    public func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func tickerizeMorseString(_ string: String) -> String {
        return string.components(separatedBy: " / ").map { word in
            return word.components(separatedBy: " ").map { char in
                var s = char.characters.reduce("", {"\($0)\($1)?" })
                s.remove(at: s.characters.index(before: s.endIndex))
                return s
            }.joined(separator: "%%%")
        }.joined(separator: "%%%%%%%").replacingOccurrences(of: "-", with: "---")
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
        let char = morseString.remove(at: morseString.startIndex)
        switch char {
        case Character("."), Character("-"):
            currentState = .high
        default:
            currentState = .low
        }
    }
}
