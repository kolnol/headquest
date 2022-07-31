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
        
        let audioFile = try self.createAudioFile(fileName: fileName)
        let audioBuffer  = try self.writeFileToBuffer(audioFile: audioFile)
        
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
    
    private func createAudioFile(fileName:String) throws -> AVAudioFile {
        let audioFileUrl = try self.getFileUrl(fileName: fileName)

        do{
            let audioFile = try AVAudioFile(forReading: audioFileUrl)
            return audioFile
        }catch let error {
            throw GameAudioPlayerError.cannotReadFile(fileName: fileName, message: "Cannot open file for reading", nestedError: error)
        }
    }
    
    private func writeFileToBuffer(audioFile:AVAudioFile) throws ->AVAudioPCMBuffer {
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
    
    private func getFileUrl(fileName:String) throws -> URL{
        let audio = try self.splitFileNameAndFormat(fileName: fileName)
        // Load a sound file URL
        guard let fileURL = Bundle.main.url(
            forResource: audio.name, withExtension: audio.extension
        ) else {
            throw GameAudioPlayerError.fileNotFound(fileName: fileName, messgae: "Cannot create url for the file name.")
        }
        
        return fileURL
    }
    
    private func  splitFileNameAndFormat(fileName:String) throws -> (name: String, extension: String){
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

class GameAudioPlayerWithMultipleAudios {
    private let audioEngine :AVAudioEngine
    private let audioMixer:AVAudioMixerNode
    
    init() {
        audioEngine = AVAudioEngine()
        audioMixer = AVAudioMixerNode()
        
        audioEngine.attach(audioMixer)
        audioEngine.connect(audioMixer, to: audioEngine.outputNode, format: nil)
    }
    
    func play(fileNames:[String], fileNamesToLoop:[String]){
        
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

