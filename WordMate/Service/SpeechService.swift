//
//  SpeechService.swift
//  WordMate
//
//  Created by KangMingyo on 11/26/24.
//

import Foundation
import AVFoundation

class SpeechService: NSObject, AVSpeechSynthesizerDelegate {
    
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
}
