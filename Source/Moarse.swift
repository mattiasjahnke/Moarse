//
//  Moarse.swift
//
//  Created by Mattias Jähnke on 25/07/16.
//  Copyright © 2016 Mattias Jähnke. All rights reserved.
//

import Foundation

private let alphabet = ["a" : [0, 1],
                        "b" : [1, 0, 0, 0],
                        "c" : [1, 0, 1, 0],
                        "d" : [1, 0, 0],
                        "e" : [0],
                        "f" : [0, 0, 1, 0],
                        "g" : [1, 1, 0],
                        "h" : [0, 0, 0, 0],
                        "i" : [0, 0],
                        "j" : [0, 1, 1, 1],
                        "k" : [1, 0, 1],
                        "l" : [0, 1, 0, 0],
                        "m" : [1, 1],
                        "n" : [1, 0],
                        "o" : [1, 1, 1],
                        "p" : [0, 1, 1, 0],
                        "q" : [1, 1, 0, 1],
                        "r" : [0, 1, 0],
                        "s" : [0, 0, 0],
                        "t" : [1],
                        "u" : [0, 0, 1],
                        "v" : [0, 0, 0, 1],
                        "w" : [0, 1, 1],
                        "x" : [1, 0, 0, 1],
                        "y" : [1, 0, 1, 1],
                        "z" : [1, 1, 0, 0],
                        "1" : [0, 1, 1, 1, 1],
                        "2" : [0, 0, 1, 1, 1],
                        "3" : [0, 0, 0, 1, 1],
                        "4" : [0, 0, 0, 0, 1],
                        "5" : [0, 0, 0, 0, 0],
                        "6" : [1, 0, 0, 0, 0],
                        "7" : [1, 1, 0, 0, 0],
                        "8" : [1, 1, 1, 0, 0],
                        "9" : [1, 1, 1, 1, 0],
                        "0" : [1, 1, 1, 1, 1]]

private let charAlpha = alphabet.reduce([:], { (r, x) -> [Character : [Bool]] in
    var e = r
    e[Character(x.0)] = x.1.map { $0 == 0 ? false : true }
    return e
})

/// Represents a Morse code sentence
public struct Morse {
    fileprivate struct Word {
        fileprivate struct Char {
            fileprivate let pattern: [Bool] // true = high, false = low
        }
        fileprivate let characters: [Char?]
    }
    fileprivate let words: [Word]
}

// MARK: Input
public extension Morse {
    /// Initialize a `Morse` with a clear text string, like "SOS SOS"
    init(clearText string: String) {
        words = string.lowercased().components(separatedBy: " ").map { Word(clearText: $0) }
    }
    
    /// Initialize a `Morse` with a string like "... --- ... / ..-"
    init(morseString string: String) {
        words = string.components(separatedBy: " / ").map { Word(morseString: $0) }
    }
}

private extension Morse.Word {
    /// Create a `Word` from clear text
    init(clearText string: String) {
        characters = string.characters.map { Char(clearTextCharacter: $0) }
    }
    
    /// Create a `Word` from a morse string
    init(morseString string: String) {
        characters = string.components(separatedBy: " ").map { c in
            return Char(morsePattern: c.characters.map { $0 == Character("-") })
        }
    }
}

private extension Morse.Word.Char {
    /// Create a `Char` from clear text character
    init?(clearTextCharacter char: Character) {
        guard let pattern = charAlpha[char] else { return nil }
        self.pattern = pattern
    }
    
    /// Create a `Char` from a morse pattern
    init?(morsePattern: [Bool]) {
        guard !charAlpha.filter({ $0.1 == morsePattern }).isEmpty else { return nil }
        self.pattern = morsePattern
    }
}

// =============

// MARK: Output
public extension Morse {
    /// Return a clear text representation of a `Morse` type
    var clearText: String {
        return words.map { word -> String in
            return word.characters.map { char in
                guard let c = charAlpha.filter({
                    guard let char = char else { return false }
                    return $0.1 == char.pattern
                }).first?.0 else { return "?" }
                return String(c)
                }.joined(separator: "")
            }.joined(separator: " ")
    }
    
    /// Return a morse string representation of a `Morse` type
    var morseString: String {
        return words.map { word -> String in
            word.characters.map { char in
                guard let char = char else { return "?" }
                return char.pattern.map { $0 ? "-" : "." }.joined(separator: "")
            }.joined(separator: " ")
        }.joined(separator: " / ")
    }
}
