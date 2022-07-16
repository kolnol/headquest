//
//  QuestGraph.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 16.05.22.
//

import Foundation
import SwiftGraph

// TODO make it implement QuestGraph protocol
class QuestGraphSG: WeightedGraph<QuestGraphNodeSG, QuestGraphActionEdgeSG> {
    func traverse(questNode: QuestGraphNodeSG, action: QuestGraphActionEdge) -> QuestGraphNodeSG? {
        let connectedEdges = self.edgesForVertex(questNode)!
        
        for edge in connectedEdges {
            if edge.u == self.indexOfVertex(questNode) && edge.weight.name == action.name {
                return self.vertexAtIndex(edge.v)
            }
        }
        
        return nil
    }
}


