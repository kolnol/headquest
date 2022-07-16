//
//  AudioSynthes.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 17.05.22.
//

import Foundation
import AVFoundation

class Utils{
    static func synth(text:String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}
