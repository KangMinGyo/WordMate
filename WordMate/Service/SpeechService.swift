//
//  SpeechService.swift
//  WordMate
//
//  Created by KangMingyo on 11/26/24.
//

import Foundation
import AVFoundation

protocol SpeechServiceDelegate: AnyObject {
    func speechDidStart()
    func speechDidFinish()
}

class SpeechService: NSObject, AVSpeechSynthesizerDelegate {
    weak var delegate: SpeechServiceDelegate?
    private let synthesizer = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func speak(_ text: String, language: String = "en-US") {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.5 // 읽기 속도
        synthesizer.speak(utterance)
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: .allowBluetooth)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        delegate?.speechDidStart()
        print("Start")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.speechDidFinish()
        print("Finish")
    }
}
