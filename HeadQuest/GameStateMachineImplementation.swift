//
//  GameStateMachine.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 16.07.22.
//

import Foundation

class GameStateMachineImplementation{
    var gameGraph:QuestGraphSG
    var currentNode:QuestGraphNodeSG
    
    init() {
        self.gameGraph = QuestGraphFixtures.SimpleQuest()
        self.currentNode = self.gameGraph.vertexAtIndex(0)
    }
    
    func reactToMediaKey(mediaAction: MediaActions) {
        let edge = self.actionToEdge(mediaAction: mediaAction, node: self.currentNode, graph: gameGraph)
        self.currentNode = self.gameGraph.traverse(questNode: self.currentNode, action: edge)!
    }
    
    // TODO make it better
    private func actionToEdge(mediaAction: MediaActions, node:QuestGraphNodeSG, graph: QuestGraphSG)-> QuestGraphActionEdgeSG{
        return graph.edgesForVertex(node)![mediaAction.rawValue].weight
    }
}

enum MediaActions:Int{
    case Play = 1
    case PreviousTrack = 2
    case NextTrack = 3
    case Pause = 4
}
