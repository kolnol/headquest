//
//  AudioSynthes.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 17.05.22.
//

import Foundation
import AVFoundation

internal class SpeechSynthesizer: NSObject, ObservableObject {
    internal var errorDescription: String? = nil
    private let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    private var OnFinish: (() -> Void)? = nil

    override init() {
        super.init()
        self.synthesizer.delegate = self
    }

    internal func speak(_ text: String, language: String = "en-GB", OnFinish:(() -> Void)? = nil) {
        do {
            self.OnFinish = OnFinish
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: language)
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            self.synthesizer.speak(utterance)
        } catch let error {
            self.errorDescription = error.localizedDescription
            print("Cannot speak \(String(describing: errorDescription))")
        }
    }
    
    internal func stop() {
        self.synthesizer.stopSpeaking(at: .immediate)
    }
}

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if self.OnFinish != nil {
            self.OnFinish!()
        }
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}
