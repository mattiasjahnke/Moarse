//
//  ViewController.swift
//  iOS Example
//
//  Created by Mattias Jähnke on 25/07/16.
//  Copyright © 2016 Mattias Jähnke. All rights reserved.
//

import UIKit
import AVFoundation
import Moarse

class ViewController: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var blinkView: UIView!
    
    private var signal: MorseSignal?
    private var beepPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let morseGesture = MorseGestureRecognizer(target: self, action: #selector(ViewController.handleMorseGesture(_:)))
        morseGesture.dotDuration = 100
        blinkView.addGestureRecognizer(morseGesture)
        beepPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: "\(Bundle.main.resourcePath!)/beep.mp3"))
    }
    
    @IBAction func generateOutput(_ sender: UIButton) {
        let morse = Morse(clearText: inputTextField.text!)
        outputTextField.text = morse.morseString
        
        if let signal = signal {
            signal.stop()
            self.signal = nil
        }
        
        if segmentedControl.selectedSegmentIndex == 2 { // Flash
            signal = MorseSignal(morse: morse, dotDuration: 500) { signal in
                switch signal {
                case .low:
                    self.blinkView.backgroundColor = .gray
                case .high:
                    self.blinkView.backgroundColor = .white
                case .finished:
                    self.blinkView.backgroundColor = .gray
                    self.signal = nil
                }
            }
            signal!.start()
        } else if segmentedControl.selectedSegmentIndex == 1 { // Sound
            signal = MorseSignal(morse: morse, dotDuration: 100) { signal in
                switch signal {
                case .low:
                    self.beepPlayer.stop()
                case .high:
                    self.beepPlayer.play()
                case .finished:
                    self.beepPlayer.stop()
                    self.signal = nil
                }
            }
            signal!.start()
        }
    }
    
    @objc private func handleMorseGesture(_ gesture: MorseGestureRecognizer) {
        switch gesture.state {
        case .ended:
            outputTextField.text = "\(outputTextField.text!)\(gesture.lastResolvedCharacter!)"
        default:
            break
        }
    }
}

