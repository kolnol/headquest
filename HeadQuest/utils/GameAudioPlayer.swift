//
//  GameAudioPlayer.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 30.07.22.
//

import AVFoundation
import Foundation

// Based on https://developer.apple.com/documentation/avfaudio/avaudioengine
class GameAudioPlayer {
    private let audioEngine: AVAudioEngine
    private let playerNode: AVAudioPlayerNode

    init() {
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()

        // Attach the player node to the audio engine.
        audioEngine.attach(playerNode)
    }

    func play(fileName: String, loop: Bool, onPlayed: @escaping () -> Void) throws {
        let audioFile = try GameAudioUtils.createAudioFile(fileName: fileName)
        let audioBuffer = try GameAudioUtils.writeFileToBuffer(audioFile: audioFile)

        // Connect the player node to the output node.
        audioEngine.connect(playerNode,
                            to: audioEngine.outputNode,
                            format: audioFile.processingFormat)

        let options: AVAudioPlayerNodeBufferOptions = loop ? [.interruptsAtLoop, .loops] : []

        playerNode.scheduleBuffer(audioBuffer, at: nil, options: options, completionCallbackType: AVAudioPlayerNodeCompletionCallbackType.dataPlayedBack) { _ in
            onPlayed()
        }

        do {
            try audioEngine.start()
            playerNode.play()
        } catch {
            throw GameAudioPlayerError.playbackError(fileName: fileName, message: "Cannot start audio engine", nestedError: error)
        }
    }

    func stop() {
        playerNode.stop()
    }

    func pause() {
        playerNode.pause()
    }
}

class GameAudioPlayerWithMultipleAudios {
    private let audioEngine: AVAudioEngine
    private let audioMixer: AVAudioMixerNode
    private var backgroundAudioNode: AVAudioPlayerNode?
    private var soundsPlayerNodes: [String: AVAudioPlayerNode?]

    init(backGroundMusicFileName: String?, soundsFileNames: [String?]) throws {
        audioEngine = AVAudioEngine()
        audioMixer = AVAudioMixerNode()
        audioEngine.attach(audioMixer)
        audioEngine.connect(audioMixer, to: audioEngine.outputNode, format: nil)
        soundsPlayerNodes = [:]

        if backGroundMusicFileName == nil {
            print("No Background music is provided")
        } else {
            backgroundAudioNode = AVAudioPlayerNode()
            soundsPlayerNodes.updateValue(backgroundAudioNode, forKey: backGroundMusicFileName!)
            audioEngine.attach(backgroundAudioNode!)
            audioEngine.connect(backgroundAudioNode!, to: audioMixer, format: nil)
        }

        for soundFileName in soundsFileNames {
            if soundFileName == nil {
                continue
            }

            soundsPlayerNodes.updateValue(AVAudioPlayerNode(), forKey: soundFileName!)
            guard let playerNode = soundsPlayerNodes[soundFileName!]
            else {
                throw GameAudioPlayerError.playerNodeCreationError(fileName: soundFileName!, message: "Cannot create an empty palyer node", nestedError: nil)
            }
            audioEngine.attach(playerNode!)
            audioEngine.connect(playerNode!,
                                to: audioMixer,
                                format: nil)
        }

        try startEngine()
    }

    func startBackgroundMusic(backGroundMusicFileName: String, onPlayed: @escaping () -> Void) throws {
        try play(fileName: backGroundMusicFileName, onPlayed: onPlayed, loop: true)
    }

    func startEngine() throws {
        do {
            print("Starting Engine...")
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)

            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            throw GameAudioPlayerError.playbackError(fileName: "", message: "Cannot start audio engine", nestedError: error)
        }
    }

    func playSound(fileName: String, onPlayed: @escaping () -> Void) throws {
        try play(fileName: fileName, onPlayed: onPlayed, loop: false)
    }

    func play(fileName: String, onPlayed: @escaping () -> Void, loop: Bool) throws {
        guard let playerNode = soundsPlayerNodes[fileName] else {
            throw GameAudioPlayerError.playerNodeCreationError(fileName: fileName, message: "No player node with this file is found", nestedError: nil)
        }

        let audioFile = try GameAudioUtils.createAudioFile(fileName: fileName)
        let audioBuffer = try GameAudioUtils.writeFileToBuffer(audioFile: audioFile)

        let options: AVAudioPlayerNodeBufferOptions = loop ? [.loops] : []

        playerNode!.scheduleBuffer(audioBuffer, at: nil, options: options, completionCallbackType: AVAudioPlayerNodeCompletionCallbackType.dataPlayedBack) { _ in
            onPlayed()
        }

        if !audioEngine.isRunning {
            try startEngine()
        }

        playerNode!.play()
    }

    func stop() {
        backgroundAudioNode?.stop()
        soundsPlayerNodes.values.forEach { node in
            node?.stop()
        }

        audioEngine.stop()
        // try! AVAudioSession.sharedInstance().setActive(false)
    }

    func pause() {
        audioEngine.pause()
//        backgroundAudioNode.stop()
//        soundsPlayerNodes.forEach { node in
//                node.stop()
//        }
    }
}

class GameAudioPlayerWithMultipleAudiosWithAsync {
    private let audioEngine: AVAudioEngine
    private let audioMixer: AVAudioMixerNode
    private var backgroundAudioNode: AVAudioPlayerNode?
    private var soundsPlayerNodes: [String: AVAudioPlayerNode?]
    private var speechAudioNode: AVAudioPlayerNode

    init(backGroundMusicFileName: String?, soundsFileNames: [String?]) throws {
        audioEngine = AVAudioEngine()
        audioMixer = AVAudioMixerNode()
        audioEngine.attach(audioMixer)
        audioEngine.connect(audioMixer, to: audioEngine.outputNode, format: nil)
        soundsPlayerNodes = [:]

        if backGroundMusicFileName == nil {
            print("No Background music is provided")
        } else {
            backgroundAudioNode = AVAudioPlayerNode()
            soundsPlayerNodes.updateValue(backgroundAudioNode, forKey: backGroundMusicFileName!)
            audioEngine.attach(backgroundAudioNode!)
            audioEngine.connect(backgroundAudioNode!, to: audioMixer, format: nil)
        }

        speechAudioNode = AVAudioPlayerNode()
        audioEngine.attach(speechAudioNode)
        audioEngine.connect(speechAudioNode, to: audioMixer, format: nil)

        for soundFileName in soundsFileNames {
            if soundFileName == nil {
                continue
            }

            soundsPlayerNodes.updateValue(AVAudioPlayerNode(), forKey: soundFileName!)
            guard let playerNode = soundsPlayerNodes[soundFileName!]
            else {
                throw GameAudioPlayerError.playerNodeCreationError(fileName: soundFileName!, message: "Cannot create an empty palyer node", nestedError: nil)
            }
            audioEngine.attach(playerNode!)
            audioEngine.connect(playerNode!,
                                to: audioMixer,
                                format: nil)
        }

        try startEngine()
    }

    func startEngine() throws {
        do {
            print("Starting Engine...")
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)

            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            throw GameAudioPlayerError.playbackError(fileName: "", message: "Cannot start audio engine", nestedError: error)
        }
    }

    func startBackgroundMusicAsync(backGroundMusicFileName: String) async throws {
        try await playAsync(fileName: backGroundMusicFileName, loop: true)
    }

    func playSoundAsync(fileName: String) async throws {
        try await playAsync(fileName: fileName, loop: false)
    }

    func playSpeech(speechAudioBuffer: AVAudioBuffer) async throws {
        guard let speechPcmBuffer = speechAudioBuffer as? AVAudioPCMBuffer else {
            print("unknow buffer type: \(speechAudioBuffer)")
            return
        }

        try await playBufferAsync(audioBuffer: speechPcmBuffer, loop: false, playerNode: speechAudioNode)
    }

    func playAsync(fileName: String, loop: Bool) async throws {
        guard let playerNode = soundsPlayerNodes[fileName] else {
            throw GameAudioPlayerError.playerNodeCreationError(fileName: fileName, message: "No player node with this file is found", nestedError: nil)
        }

        let audioFile = try GameAudioUtils.createAudioFile(fileName: fileName)
        let audioBuffer = try GameAudioUtils.writeFileToBuffer(audioFile: audioFile)

        try await playBufferAsync(audioBuffer: audioBuffer, loop: loop, playerNode: playerNode!)
    }

    func playBufferAsync(audioBuffer: AVAudioPCMBuffer, loop: Bool, playerNode: AVAudioPlayerNode) async throws {
        let options: AVAudioPlayerNodeBufferOptions = loop ? [.interruptsAtLoop, .loops] : []

        let t = Task { await playerNode.scheduleBuffer(audioBuffer, at: nil, options: options, completionCallbackType: AVAudioPlayerNodeCompletionCallbackType.dataPlayedBack) }

        if !audioEngine.isRunning {
            try startEngine()
        }

        // todo does this needs to be async and awaitable as well?
        // no the played callback is in scheduleBuffer task
        playerNode.play()

        await t.result
    }

    func stop() {
        backgroundAudioNode?.stop()
        soundsPlayerNodes.values.forEach { node in
            node?.stop()
        }

        audioEngine.stop()
        // try! AVAudioSession.sharedInstance().setActive(false)
    }

    func pause() {
        audioEngine.pause()
//        backgroundAudioNode.stop()
//        soundsPlayerNodes.forEach { node in
//                node.stop()
//        }
    }
}

enum GameAudioPlayerError: Error {
    case invalidFileFormat(fileName: String, message: String)
    case fileNotFound(fileName: String, message: String)
    case cannotReadFile(fileName: String, message: String, nestedError: Error)
    case cannotConvertFileToBuffer(audioFile: AVAudioFile, message: String, nestedError: Error)
    case cannotCreateBuffer(audioFile: AVAudioFile, message: String)
    case playbackError(fileName: String, message: String, nestedError: Error)
    case playerNodeCreationError(fileName: String, message: String, nestedError: Error?)
}

enum GameAudioUtils {
    public static func createAudioFile(fileName: String) throws -> AVAudioFile {
        let audioFileUrl = try getFileUrl(fileName: fileName)

        do {
            let audioFile = try AVAudioFile(forReading: audioFileUrl)
            return audioFile
        } catch {
            throw GameAudioPlayerError.cannotReadFile(fileName: fileName, message: "Cannot open file for reading", nestedError: error)
        }
    }

    public static func writeFileToBuffer(audioFile: AVAudioFile) throws -> AVAudioPCMBuffer {
        guard let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length)) else {
            throw GameAudioPlayerError.cannotCreateBuffer(audioFile: audioFile, message: "Cannot create buffer for audio file")
        }

        do {
            try audioFile.read(into: audioBuffer)
            return audioBuffer
        } catch {
            throw GameAudioPlayerError.cannotConvertFileToBuffer(audioFile: audioFile, message: "Cannot convert audio file to buffer.", nestedError: error)
        }
    }

    public static func getFileUrl(fileName: String) throws -> URL {
        let audio = try splitFileNameAndFormat(fileName: fileName)
        // Load a sound file URL
        guard let fileURL = Bundle.main.url(
            forResource: audio.name, withExtension: audio.extension
        ) else {
            throw GameAudioPlayerError.fileNotFound(fileName: fileName, message: "Cannot create url for the file name.")
        }

        return fileURL
    }

    public static func splitFileNameAndFormat(fileName: String) throws -> (name: String, extension: String) {
        guard let fileType = fileName.split(separator: ".").last else {
            throw GameAudioPlayerError.invalidFileFormat(fileName: fileName, message: "Cannot parse format of the file.")
        }

        guard !fileType.isEmpty else {
            throw GameAudioPlayerError.invalidFileFormat(fileName: fileName, message: "Cannot parse format of the file.")
        }

        let name = fileName.replacingOccurrences(of: ".\(fileType)", with: "")

        return (name: name, extension: String(fileType))
    }
}
