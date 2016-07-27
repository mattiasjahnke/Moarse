# MorseCode app in Swift
My solution to a Swift challenge https://medium.com/@adamontherun/swift-roll-1-build-a-morse-code-app-7e26cbaebb11#.cl1dcx57s

## The solution
### Morse
`Morse` is a type that can be initialised by either
* Clean text `String` ("hello world")
* A morse `String` ("... --- ... / ... --- ...")

### MorseGestureRecognizer
A UIGestureRecognizer subclass that takes taps or presses as morse input and produces clear text

### MorseSignal
An object that can produce a signal from a given `Morse`. Consumers of this signal can produce output (see `ViewController.swift` for examples on sound or flashes, produced by this signal)

## Todo
* Error handling for unrecognized strings
* Transform morse string -> clean text via the input text field
* Make the gesture recognizer better (it's a hack at the moment)
