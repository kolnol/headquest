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
    let synthesizer: AVSpeechSynthesizer
    let audioPlayer : GameAudioPlayer
    
    init() {
        self.gameGraph = QuestGraphFixtures.SimpleQuest()
        self.currentNode = self.gameGraph.vertexAtIndex(0)
        self.synthesizer = AVSpeechSynthesizer()
        self.audioPlayer = GameAudioPlayer()
    }
    
    func reactToMediaKey(mediaAction: MediaActions) {
        self.synthesizer.stopSpeaking(at:AVSpeechBoundary.immediate)
        if let edge = self.actionToEdge(mediaAction: mediaAction, node: self.currentNode, graph: gameGraph){
            let nextNode = self.gameGraph.traverse(questNode: self.currentNode, action: edge)!
            if nextNode.name == "Come Back" {
                let e = self.actionToEdge(mediaAction: MediaActions.PreviousTrack, node: nextNode, graph: gameGraph)! //TODO fix this workaround
                self.currentNode = self.gameGraph.traverse(questNode: nextNode, action: e)!
            }else{
                self.currentNode = nextNode
            }
        }// TODO add action if no edges found
        
        // OnReact
        self.tellDescriptionOfNode(node:self.currentNode)
    }
    
    func startGame(){
        tellDescriptionOfNode(node: self.currentNode)
    }
    
    private func tellDescriptionOfNode(node: QuestGraphNodeSG){
        let utterance = AVSpeechUtterance(string: node.description)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        //utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-AU_compact")
        //utterance.pitchMultiplier = 0.5
        //let myRate:Float = 0.3
        //let rate = myRate * (AVSpeechUtteranceMaximumSpeechRate - AVSpeechUtteranceMinimumSpeechRate) + AVSpeechUtteranceMinimumSpeechRate
        //utterance.rate = rate
        self.synthesizer.speak(utterance)
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
        if !self.isEnd(){
            self.synthesizer.stopSpeaking(at:AVSpeechBoundary.immediate)
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
