//
//  GameStateMachine.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 16.07.22.
//

import Foundation
import AVFoundation

class GameStateMachineImplementation{
    var gameGraph:QuestGraphSG
    var currentNode:QuestGraphNodeSG
    let synthesizer: SpeechSynthesizer
    let audioPlayer : GameAudioPlayerWithMultipleAudios
    
    init() {
        self.gameGraph = QuestGraphFixtures.SimpleQuest()
        self.currentNode = self.gameGraph.vertexAtIndex(0)
        self.synthesizer = SpeechSynthesizer()
        self.audioPlayer = GameAudioPlayerWithMultipleAudios()
    }
    
    func reactToMediaKey(mediaAction: MediaActions) {
        self.OnPreReact()
        
        // Find new current node
        if let edge = self.actionToEdge(mediaAction: mediaAction, node: self.currentNode, graph: gameGraph){
            let nextNode = self.gameGraph.traverse(questNode: self.currentNode, action: edge)!
            if nextNode.isSkipable {
                self.synthesizer.speak(nextNode.description, OnFinish: {
                    let e = self.actionToEdge(mediaAction: MediaActions.PreviousTrack, node: nextNode, graph: self.gameGraph)! //TODO fix this workaround
                    self.currentNode = self.gameGraph.traverse(questNode: nextNode, action: e)!
                    
                    self.OnReactToNode()
                    self.OnPostReact()
                })
            }else{
                self.currentNode = nextNode
                
                self.OnReactToNode()
                self.OnPostReact()
            }
        }// TODO add action if no edges found
    }
    
    func OnPreReact(){
        self.synthesizer.stop()
    }
    
    func OnPostReact(){
        
    }
    
    func OnReactToEdge(){
        
    }
    
    func OnReactToNode(){
        do {
            try self.playAudio(OnAudioPlayed: {
                self.synthesizer.speak(self.currentNode.description)
            })
        } catch GameAudioPlayerError.invalidFileFormat(let fileName, let message){
            print("Cannot play audio because of invalid file format in \(fileName) with message \(message)")
        } catch let error {
                print(error)
        }
    }
    
    func playAudio(OnAudioPlayed: @escaping ()->Void) throws {
        if let backgroundMusicFile = self.currentNode.backgroundMusicFile {
                try self.audioPlayer.startBackgroundMusic(backGroundMusicFileName: backgroundMusicFile, onPlayed: {})
        }
        
        if let preVoiceSound = self.currentNode.preVoiceSound {
            try self.audioPlayer.playSound(fileName: preVoiceSound, onPlayed: {
                OnAudioPlayed()
            })
        }
        //TODO add possibility to play several audios
    }
    
    func startGame(){
        OnReactToNode()
    }
    
    // TODO make it better
    private func actionToEdge(mediaAction: MediaActions, node:QuestGraphNodeSG, graph: QuestGraphSG)-> QuestGraphActionEdgeSG?{
        if let edges = graph.edgesForVertex(node) {
            return edges[mediaAction.rawValue].weight
        }else{
            print("No edges found for the node \(node.name)")
        }
        return nil
    }
    
    func reset(){
        self.audioPlayer.stop()
        if !self.isEnd(){
            self.synthesizer.stop()
        }
        self.gameGraph = QuestGraphFixtures.SimpleQuest()
        self.currentNode = self.gameGraph.vertexAtIndex(0)
    }
    
    func isEnd() -> Bool{
        return self.currentNode.isEnd
    }
}

enum MediaActions:Int{
    case Play = 1
    case PreviousTrack = 0
    case NextTrack = 2
}
