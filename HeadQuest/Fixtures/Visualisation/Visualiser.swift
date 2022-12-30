//
//  Visualiser.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 30.12.22.
//

import Foundation
import SwiftGraph
class MermaidGraphVisualiser : LoggingComponent {
    let header: String = "flowchart TD"
    
    func visualise(graph: QuestGraphSG) {
        var mermaidString = header;
        
        for edge in getGraphEdges(graph: graph)
        {
            let originNode = graph.vertexAtIndex(edge.u)
            let targetNode = graph.vertexAtIndex(edge.v)
            
            let mermaidEdgeString = "\(edge.u)([\(originNode.name)]) -->|\(edge.weight.name)\\\(edge.weight.action)| \(edge.v)([\(targetNode.name)])"
            
            mermaidString += "\n"
            mermaidString += mermaidEdgeString
        }
        
        logger.info("\(mermaidString)")        
    }
    
    private func getGraphEdges(graph: QuestGraphSG) -> [WeightedEdge<QuestGraphActionEdgeSG>]
    {
        var res = [WeightedEdge<QuestGraphActionEdgeSG>]()
        for e in graph.edges {
            res.append(contentsOf: e)
        }
        
        return res
    }
}
