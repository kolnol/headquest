//
//  GameAudioPlayer.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 30.07.22.
//

import Foundation
import AVFoundation

// Based on https://developer.apple.com/documentation/avfaudio/avaudioengine
class GameAudioPlayer {
    private let audioEngine :AVAudioEngine
    private let playerNode :AVAudioPlayerNode
    
    init(){
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        
        // Attach the player node to the audio engine.
        audioEngine.attach(playerNode)
    }
    
    func play(fileName: String, loop:Bool, onPlayed: @escaping ()->Void) throws {
        
        let audioFile = try GameAudioUtils.createAudioFile(fileName: fileName)
        let audioBuffer  = try GameAudioUtils.writeFileToBuffer(audioFile: audioFile)
        
        // Connect the player node to the output node.
        audioEngine.connect(playerNode,
                            to: audioEngine.outputNode,
                            format: audioFile.processingFormat)
        
        let options:AVAudioPlayerNodeBufferOptions = loop ? [.interruptsAtLoop, .loops] : []
        
        playerNode.scheduleBuffer(audioBuffer, at: nil, options: options, completionCallbackType: AVAudioPlayerNodeCompletionCallbackType.dataPlayedBack) {_ in
            onPlayed()
        }
        
        do {
            try audioEngine.start()
            playerNode.play()
        } catch let error {
            throw GameAudioPlayerError.playbackError(fileName: fileName, message: "Cannot start audio engine", nestedError:error)
        }
    }
    
    func stop(){
        self.playerNode.stop()
    }
    
    func pause(){
        self.playerNode.pause()
    }
}

class GameAudioPlayerWithMultipleAudios {
    private let audioEngine :AVAudioEngine
    private let audioMixer:AVAudioMixerNode
    private let backgroundAudioNode: AVAudioPlayerNode
    private var soundsPlayerNodes: [AVAudioPlayerNode]
    
    init() {
        audioEngine = AVAudioEngine()
        audioMixer = AVAudioMixerNode()
        backgroundAudioNode = AVAudioPlayerNode()
        soundsPlayerNodes = []
        
        audioEngine.attach(audioMixer)
        audioEngine.connect(audioMixer, to: audioEngine.outputNode, format: nil)
        audioEngine.attach(backgroundAudioNode)
        audioEngine.connect(backgroundAudioNode, to: audioMixer, format: nil)
    }
    
    func startBackgroundMusic(backGroundMusicFileName: String, onPlayed: @escaping ()->Void) throws {
        let audioFile = try GameAudioUtils.createAudioFile(fileName: backGroundMusicFileName)
        let audioBuffer  = try GameAudioUtils.writeFileToBuffer(audioFile: audioFile)
        
        let options:AVAudioPlayerNodeBufferOptions = [.interruptsAtLoop, .loops]
        
        backgroundAudioNode.scheduleBuffer(audioBuffer, at: nil, options: options, completionCallbackType: AVAudioPlayerNodeCompletionCallbackType.dataPlayedBack) {_ in
            onPlayed()
        }
        
        do {
            try audioEngine.start()
            backgroundAudioNode.play()
        } catch let error {
            throw GameAudioPlayerError.playbackError(fileName: backGroundMusicFileName, message: "Cannot start audio engine", nestedError:error)
        }
    }
    
    func playSound(fileName: String, onPlayed: @escaping ()->Void) throws {
        let audioFile = try GameAudioUtils.createAudioFile(fileName: fileName)
        let audioBuffer  = try GameAudioUtils.writeFileToBuffer(audioFile: audioFile)
        
        soundsPlayerNodes.append(AVAudioPlayerNode())
        let playerNode = soundsPlayerNodes.last!
        audioEngine.attach(playerNode)
        
        // Connect the player node to the output node.
        audioEngine.connect(playerNode,
                            to: audioMixer,
                            format: audioFile.processingFormat)
        
        playerNode.scheduleBuffer(audioBuffer, at: nil, options: [], completionCallbackType: AVAudioPlayerNodeCompletionCallbackType.dataPlayedBack) {_ in
            onPlayed()
        }
        
        do {
            try audioEngine.start()
            playerNode.play()
        } catch let error {
            throw GameAudioPlayerError.playbackError(fileName: fileName, message: "Cannot start audio engine", nestedError:error)
        }
    }
    
    func stop(){
        audioEngine.stop()
//        backgroundAudioNode.stop()
//        soundsPlayerNodes.forEach { node in
//                node.stop()
//        }
    }
    
    func pause(){
        audioEngine.pause()
//        backgroundAudioNode.stop()
//        soundsPlayerNodes.forEach { node in
//                node.stop()
//        }
    }
}

enum GameAudioPlayerError: Error {
    case invalidFileFormat(fileName:String, message:String)
    case fileNotFound(fileName:String, messgae:String)
    case cannotReadFile(fileName:String, message:String, nestedError:Error)
    case cannotConvertFileToBuffer(audioFile:AVAudioFile, message:String, nestedError: Error)
    case cannotCreateBuffer(audioFile:AVAudioFile, message:String)
    case playbackError(fileName: String, message:String, nestedError:Error)
}

class GameAudioUtils {
    public static func createAudioFile(fileName:String) throws -> AVAudioFile {
        let audioFileUrl = try getFileUrl(fileName: fileName)

        do{
            let audioFile = try AVAudioFile(forReading: audioFileUrl)
            return audioFile
        }catch let error {
            throw GameAudioPlayerError.cannotReadFile(fileName: fileName, message: "Cannot open file for reading", nestedError: error)
        }
    }
    
    public static func writeFileToBuffer(audioFile:AVAudioFile) throws ->AVAudioPCMBuffer {
        guard let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length)) else {
            throw GameAudioPlayerError.cannotCreateBuffer(audioFile: audioFile, message: "Cannot create buffer for audio file")
        }
        
        do{
            try audioFile.read(into: audioBuffer)
            return audioBuffer
        } catch let error{
            throw GameAudioPlayerError.cannotConvertFileToBuffer(audioFile: audioFile, message: "Cannot convert audio file to buffer.", nestedError: error)
        }
    }
    
    public static func getFileUrl(fileName:String) throws -> URL{
        let audio = try splitFileNameAndFormat(fileName: fileName)
        // Load a sound file URL
        guard let fileURL = Bundle.main.url(
            forResource: audio.name, withExtension: audio.extension
        ) else {
            throw GameAudioPlayerError.fileNotFound(fileName: fileName, messgae: "Cannot create url for the file name.")
        }
        
        return fileURL
    }
    
    public static func  splitFileNameAndFormat(fileName:String) throws -> (name: String, extension: String){
        guard let fileType = fileName.split(separator: ".").last else{
            throw GameAudioPlayerError.invalidFileFormat(fileName: fileName, message: "Cannot parse format of the file.")
        }
        
        guard !fileType.isEmpty else{
            throw GameAudioPlayerError.invalidFileFormat(fileName: fileName, message: "Cannot parse format of the file.")
        }
        
        let name = fileName.replacingOccurrences(of: ".\(fileType)", with: "")
        
        return (name: name, extension: String(fileType))
    }
}
