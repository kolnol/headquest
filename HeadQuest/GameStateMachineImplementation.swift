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
        if let edge = self.actionToEdge(mediaAction: mediaAction, node: self.currentNode, graph: gameGraph){
            let nextNode = self.gameGraph.traverse(questNode: self.currentNode, action: edge)!
            if nextNode.name == "Come Back" {
                let e = self.actionToEdge(mediaAction: MediaActions.PreviousTrack, node: nextNode, graph: gameGraph)! //TODO fix this workaround
                self.currentNode = self.gameGraph.traverse(questNode: nextNode, action: e)!
            }else{
                self.currentNode = nextNode
            }
        }// TODO add action if no edges found
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
