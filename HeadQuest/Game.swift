//
//  Game.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 06.08.22.
//

import AVFoundation
import Foundation

class Game {
    var gameStateMachine: GameStateMachineImplementationNew
    let synthesizer: SpeechSynthesizerAsync
    var audioPlayer: GameAudioPlayerWithMultipleAudiosWithAsync?
    var playerTask: Task<Void, Never>?

    init() {
        gameStateMachine = GameStateMachineImplementationNew()
        synthesizer = SpeechSynthesizerAsync()
    }

    func reactToMediaKey(mediaAction: MediaActions) {
        // only updates currentNode
        var currentNode: QuestGraphNodeSG?

        do {
            currentNode = try gameStateMachine.updateStateByAction(mediaAction: mediaAction)
        } catch {
            print("Error during getting current node \(error.localizedDescription)")
            return
        }

        if currentNode == nil {
            print("Received empty current node. Doing nothing.")
            return
        }

        processNode(node: currentNode!)
    }

    func processNode(node: QuestGraphNodeSG) {
        if playerTask != nil {
            print("Cancelling running player...")
            playerTask!.cancel()
            audioPlayer!.stop()
            synthesizer.stop()
        }

        playerTask = Task.init {
            do {
                try await playAudioAsync(node: node)

                if node.isSkipable {
                    try gameStateMachine.goNext()
                    processNode(node: gameStateMachine.currentNode)
                }
            } catch {
                print("Error during playing \(error.localizedDescription)")
            }
        }
    }

    func playAudioAsync(node: QuestGraphNodeSG) async throws {
        try audioPlayer = GameAudioPlayerWithMultipleAudiosWithAsync(backGroundMusicFileName: node.backgroundMusicFile, soundsFileNames: [node.preVoiceSound, node.postVoiceSound])

        if Task.isCancelled {
            print("Playing task was cancelled")
            return
        }

        if let backgroundMusicFile = node.backgroundMusicFile {
            // task init to not await until the background music is done playing
            Task.init {
                try await audioPlayer!.startBackgroundMusicAsync(backGroundMusicFileName: backgroundMusicFile)
            }
        }

        if Task.isCancelled {
            print("Playing task was cancelled")
            audioPlayer!.stop()
            return
        }

        if let preVoiceSound = node.preVoiceSound {
            try await audioPlayer!.playSoundAsync(fileName: preVoiceSound)
        }

        if Task.isCancelled {
            print("Playing task was cancelled")
            audioPlayer!.stop()
            return
        }

        await synthesizer.speak(node.description)

        if Task.isCancelled {
            print("Playing task was cancelled")
            audioPlayer!.stop()
            synthesizer.stop()
            return
        }

        // TODO: Make the sound to appear after speak
        if let postVoiceSound = node.postVoiceSound {
            Task {
                try await self.audioPlayer!.playSoundAsync(fileName: postVoiceSound)
            }
        }
    }

    func startGame() async throws {
        print("Starting gaeme in Game engine")
        playerTask = Task.init {
            do {
                try await playAudioAsync(node: gameStateMachine.currentNode)
            } catch {
                print("Error during playing \(error.localizedDescription)")
            }
        }
    }

    func reset() {
        playerTask?.cancel()
        audioPlayer?.stop()
        if !isEnd() {
            synthesizer.stop()
        }

        gameStateMachine.reset()
    }

    func isEnd() -> Bool {
        return gameStateMachine.isEnd()
    }
}

class GameStateMachineImplementationNew {
    var gameGraph: QuestGraphSG
    var currentNode: QuestGraphNodeSG

    init() {
        gameGraph = QuestGraphFixtures.SimpleQuest()
        currentNode = gameGraph.vertexAtIndex(0)
    }

    func updateStateByAction(mediaAction: MediaActions) throws -> QuestGraphNodeSG {
        // Find new current node
        guard let edge = try? actionToEdge(mediaAction: mediaAction, node: currentNode, graph: gameGraph)
        else {
            throw GameStateMachineError.noEdgeFound(message: "No edge found from node \(currentNode.name) by action \(mediaAction).")
        }

        guard let newNode = gameGraph.traverse(questNode: currentNode, action: edge) else {
            throw GameStateMachineError.noNodeFound(message: "No node found from node \(currentNode.name) by action \(mediaAction).")
        }

        currentNode = newNode
        return currentNode
    }

    func goNext() throws {
        if !currentNode.isSkipable {
            throw GameStateMachineError.notSkipableState(message: "Go next is not possible as it is not clear to which state to go")
        }

        guard let edges = gameGraph.edgesForVertex(currentNode) else {
            throw GameStateMachineError.noEdgeFound(message: "No edges found for the node \(currentNode.name)")
        }

        if edges.count != 1 {
            throw GameStateMachineError.notSkipableState(message: "Go next is not possible as it is not clear to which state to go")
        }

        let edge = edges.first!
        guard let newNode = gameGraph.traverse(questNode: currentNode, action: edge.weight) else {
            throw GameStateMachineError.noNodeFound(message: "No node found from node \(currentNode.name) by action \(edge.weight.name).")
        }

        currentNode = newNode
    }

    // TODO: make it better
    private func actionToEdge(mediaAction: MediaActions, node: QuestGraphNodeSG, graph: QuestGraphSG) throws -> QuestGraphActionEdgeSG {
        guard let edges = graph.edgesForVertex(node) else {
            throw GameStateMachineError.noEdgeFound(message: "No edges found for the node \(node.name)")
        }

        return edges[mediaAction.rawValue].weight
    }

    func reset() {
        gameGraph = QuestGraphFixtures.SimpleQuest()
        currentNode = gameGraph.vertexAtIndex(0)
    }

    func isEnd() -> Bool {
        return currentNode.isEnd
    }
}

enum GameStateMachineError: Error {
    case noEdgeFound(message: String)
    case noNodeFound(message: String)
    case notSkipableState(message: String)
}

extension GameStateMachineError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case
            let .noEdgeFound(message),
            let .noNodeFound(message),
            let .notSkipableState(message):
            return message
        }
    }
}
