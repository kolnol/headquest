//
//  GameStateMachine.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 16.07.22.
//

import AVFoundation
import Foundation

class GameStateMachineImplementation {
    var gameGraph: QuestGraphSG
    var currentNode: QuestGraphNodeSG
    let synthesizer: SpeechSynthesizer
    var audioPlayer: GameAudioPlayerWithMultipleAudios?

    init() {
        gameGraph = QuestGraphFixtures.SimpleQuest()
        currentNode = gameGraph.vertexAtIndex(0)
        synthesizer = SpeechSynthesizer()
        // self.audioPlayer = GameAudioPlayerWithMultipleAudios()
    }

    func reactToMediaKey(mediaAction: MediaActions) {
        OnPreReact()

        // Find new current node
        if let edge = actionToEdge(mediaAction: mediaAction, node: currentNode, graph: gameGraph) {
            let nextNode = gameGraph.traverse(questNode: currentNode, action: edge)!
            if nextNode.isSkipable {
                synthesizer.speak(nextNode.description, OnFinish: {
                    let e = self.actionToEdge(mediaAction: MediaActions.PreviousTrack, node: nextNode, graph: self.gameGraph)! // TODO: fix this workaround
                    self.currentNode = self.gameGraph.traverse(questNode: nextNode, action: e)!

                    self.OnReactToNode()
                    self.OnPostReact()
                })
            } else {
                currentNode = nextNode

                OnReactToNode()
                OnPostReact()
            }
        } // TODO: add action if no edges found
    }

    func OnPreReact() {
        audioPlayer?.stop()
        synthesizer.stop()
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print(error.localizedDescription)
        }
    }

    func OnPostReact() {
        print("Post rteact")
    }

    func OnReactToEdge() {}

    func OnReactToNode() {
        do {
            try playAudio(OnAudioPlayed: {
                self.synthesizer.speak(self.currentNode.description)
            })
        } catch let GameAudioPlayerError.invalidFileFormat(fileName, message) {
            print("Cannot play audio because of invalid file format in \(fileName) with message \(message)")
        } catch {
            print(error)
        }
    }

    func playAudio(OnAudioPlayed: @escaping () -> Void) throws {
        try audioPlayer = GameAudioPlayerWithMultipleAudios(backGroundMusicFileName: currentNode.backgroundMusicFile, soundsFileNames: [currentNode.preVoiceSound, currentNode.postVoiceSound])

        if let backgroundMusicFile = currentNode.backgroundMusicFile {
            try audioPlayer!.startBackgroundMusic(backGroundMusicFileName: backgroundMusicFile, onPlayed: {})
        }

        if let preVoiceSound = currentNode.preVoiceSound {
            try audioPlayer!.playSound(fileName: preVoiceSound, onPlayed: {
                OnAudioPlayed()
            })
        } else {
            OnAudioPlayed()
        }
        // TODO: add possibility to play several audios
    }

    func startGame() {
        OnReactToNode()
    }

    // TODO: make it better
    private func actionToEdge(mediaAction: MediaActions, node: QuestGraphNodeSG, graph: QuestGraphSG) -> QuestGraphActionEdgeSG? {
        if let edges = graph.edgesForVertex(node) {
            return edges[mediaAction.rawValue].weight
        } else {
            print("No edges found for the node \(node.name)")
        }
        return nil
    }

    func reset() {
        audioPlayer?.stop()
        if !isEnd() {
            synthesizer.stop()
        }
        gameGraph = QuestGraphFixtures.SimpleQuest()
        currentNode = gameGraph.vertexAtIndex(0)
    }

    func isEnd() -> Bool {
        currentNode.isEnd
    }
}

enum MediaActions: Int {
    case Play = 1
    case PreviousTrack = 0
    case NextTrack = 2
}
