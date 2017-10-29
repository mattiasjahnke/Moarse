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
    @IBOutlet weak var textSwitch: UISwitch!
    @IBOutlet weak var flashSwitch: UISwitch!
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var blinkView: UIView!
    @IBOutlet weak var dotLengthSlider: UISlider!
    @IBOutlet weak var dotLengthLabel: UILabel!
    
    private var signal: MorseSignal?
    private var beepPlayer: AVAudioPlayer!
    
    var flashDevice: AVCaptureDevice? = {
        guard let device = AVCaptureDevice.default(for: .video),
            device.hasTorch,
            device.hasFlash else { return nil }
        return device
    }()
    
    var dotLength: Int = 0 {
        didSet {
            dotLengthLabel.text = "\(dotLength)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let morseGesture = MorseGestureRecognizer(target: self, action: #selector(ViewController.handleMorseGesture(_:)))
        morseGesture.dotDuration = 100
        blinkView.addGestureRecognizer(morseGesture)
        blinkView.backgroundColor = .black
        beepPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: "\(Bundle.main.resourcePath!)/beep.mp3"))
        
        dotLength = 600
        dotLengthSlider.value = Float(dotLength)
    }
    
    @IBAction func generateOutput(_ sender: UIButton) {
        let morse = Morse(clearText: inputTextField.text!)
        
        if textSwitch.isOn {
            outputTextField.text = morse.morseString
        }
        
        view.resignFirstResponder()
        
        if let signal = signal {
            signal.stop()
            self.signal = nil
        }
        
        let flashOperation: ((Bool) -> ())? = flashSwitch.isOn ? {
            self.turnTorch(on: $0)
            self.blinkView.backgroundColor = $0 ? .white : .black
            } : nil
        
        let soundOperation: ((Bool) -> ())? = soundSwitch.isOn ? {
            guard $0 else { self.beepPlayer.stop(); return }
            self.beepPlayer.play()
            } : nil
        
        signal = MorseSignal(morse: morse, dotDuration: TimeInterval(dotLength)) { signal in
            flashOperation?(signal == .high)
            soundOperation?(signal == .high)
            if signal == .finished { self.signal = nil }
        }
        
        signal!.start()
    }
    
    @objc private func handleMorseGesture(_ gesture: MorseGestureRecognizer) {
        switch gesture.state {
        case .ended:
            outputTextField.text = "\(outputTextField.text!)\(gesture.lastResolvedCharacter!)"
        default:
            break
        }
    }
    
    @IBAction func dotLengthSliderChanged(_ sender: Any) {
        dotLength = Int(dotLengthSlider.value)
    }
    
    func turnTorch(on: Bool) {
        guard let device = flashDevice else { return }
        
        try! device.lockForConfiguration()
        
        device.torchMode = on ? .on : .off
        device.flashMode = on ? .on : .off
        
        device.unlockForConfiguration()
    }
}
