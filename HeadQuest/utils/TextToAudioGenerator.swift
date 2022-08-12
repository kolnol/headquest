//
//  TextToAudioGenerator.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 11.08.22.
//

import AVFoundation
import Foundation

protocol TextToAudioFileGeneratorProtocol {
    func generateAudio(_ text: String, outputFilePath: String) async
}

class TextToAudioFileGenerator: TextToAudioFileGeneratorProtocol {
    let synthesizer = AVSpeechSynthesizer()

    func generateAudio(_ text: String, outputFilePath: String) async {
        let outputFileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(outputFilePath)
        await generateAudio(text, outputFilePathUrl: outputFileUrl)
    }

    func generateAudio(_ text: String, outputFilePathUrl: URL) async {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        var output: AVAudioFile?
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            synthesizer.write(utterance) { (buffer: AVAudioBuffer) in
                guard let pcmBuffer = buffer as? AVAudioPCMBuffer else {
                    fatalError("unknown buffer type: \(buffer)")
                }
                if pcmBuffer.frameLength == 0 {
                    // done
                    print("[TextToAudioFileGenerator] Done converting text to audio file \(outputFilePathUrl)")
                    continuation.resume()
                } else {
                    // append buffer to file
                    // print("[TextToAudioFileGenerator] Appending buffer to file \(outputFilePathUrl)")
                    if output == nil {
                        do {
                            try output = AVAudioFile(
                                forWriting: outputFilePathUrl,
                                settings: pcmBuffer.format.settings,
                                commonFormat: .pcmFormatInt16,
                                interleaved: false
                            )

                        } catch {
                            print("[TextToAudioFileGenerator] cannot create output file with error \(error)")
                            continuation.resume()
                        }
                    }
                    do {
                        try output?.write(from: pcmBuffer)
                    } catch {
                        print("[TextToAudioFileGenerator] cannot append audio to output file with error \(error)")
                        continuation.resume()
                    }
                }
            }
        }
    }
}
