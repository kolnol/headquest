//
//  QuestGraph.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 16.05.22.
//

import Foundation
import SwiftGraph

// TODO: make it implement QuestGraph protocol
public class QuestGraphSG: WeightedGraph<QuestGraphNodeSG, QuestGraphActionEdgeSG>
{
	func traverse(questNode: QuestGraphNodeSG, action: QuestGraphActionEdge) -> QuestGraphNodeSG?
	{
		let connectedEdges = edgesForVertex(questNode)!

		for edge in connectedEdges
		{
			if edge.u == indexOfVertex(questNode), edge.weight.name == action.name
			{
				return vertexAtIndex(edge.v)
			}
		}

		return nil
	}
    
    func getRootNode() -> QuestGraphNodeSG {
        return vertices.first { node in
            node.isStart
        }!
    }
}
