//
//  AudioSynthes.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 17.05.22.
//

import AVFoundation
import Foundation

internal class SpeechSynthesizer: NSObject, ObservableObject {
    internal var errorDescription: String?
    private let synthesizer: AVSpeechSynthesizer = .init()
    private var OnFinish: (() -> Void)?


    override init() {
        super.init()
        synthesizer.delegate = self
    }

    internal func speak(_ text: String, language: String = "en-GB", OnFinish: (() -> Void)? = nil) {
        do {
            self.OnFinish = OnFinish
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: language)

            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            synthesizer.speak(utterance)
        } catch {
            errorDescription = error.localizedDescription
            print("Cannot speak \(String(describing: errorDescription))")
        }
    }

    internal func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_: AVSpeechSynthesizer, didFinish _: AVSpeechUtterance) {
        if OnFinish != nil {
            OnFinish!()
        }
    }
}



internal class SpeechSynthesizerAsync: NSObject, ObservableObject {
    private typealias SpeechContinuation = CheckedContinuation<Void, Never>

    private var speechContinuation: SpeechContinuation?
    internal var errorDescription: String?
    private let synthesizer: AVSpeechSynthesizer = .init()


    override init() {
        super.init()
        synthesizer.delegate = self
    }

    internal func speak(_ text: String, language: String = "en-GB") async {
        do {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: language)

            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            synthesizer.speak(utterance)
            await withCheckedContinuation({ (continuation: SpeechContinuation) in
                self.speechContinuation = continuation
            })
        } catch {
            errorDescription = error.localizedDescription
            print("Cannot speak \(String(describing: errorDescription))")
        }
    }

    internal func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

extension SpeechSynthesizerAsync: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_: AVSpeechSynthesizer, didFinish _: AVSpeechUtterance) {
        speechContinuation?.resume()
        speechContinuation = nil
    }
}
