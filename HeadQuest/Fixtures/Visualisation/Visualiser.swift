//
//  Visualiser.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 30.12.22.
//

import Foundation
import SwiftGraph
import UIKit
class MermaidGraphVisualiser : LoggingComponent {
    let header: String = "flowchart TD"
    let nodeDescriptionLength = 900
    let nodeDescriptionMaxRowLength = 50
    let startNodeStyleClassName = "startClass"
    let endNodeStyleClassName = "endClass"
    let skipableNodeStyleClassName = "skipableClass"
    
    func visualise(graph: QuestGraphSG) {
        var mermaidString = header;
        
        for edge in getGraphEdges(graph: graph)
        {
            let originNode = graph.vertexAtIndex(edge.u)
            let targetNode = graph.vertexAtIndex(edge.v)
            
            let mermaidEdgeString = buildMermaidEdgeForEdge(edge: edge, originNode: originNode, targetNode: targetNode, descriptionLength: nodeDescriptionLength)
            
            mermaidString += "\n"
            mermaidString += mermaidEdgeString
        }
        
        // Add styling
        mermaidString += "\n"
        mermaidString += buildMermaidStyleConfig()
        
        logger.info("\(mermaidString)")
    }
    
    private func buildMermaidEdgeForEdge(edge: WeightedEdge<QuestGraphActionEdgeSG>, originNode:QuestGraphNodeSG, targetNode: QuestGraphNodeSG, descriptionLength : Int) -> String {
        
        let originNodeIndex = edge.u
        let targetNodeIndex = edge.v
        
        let edgeLable = visualiseEdgeContent(edge: edge)
        

        let originNodeVisualisation = visualiseNode(nodeIndex: originNodeIndex, node: originNode, descriptionLength: nodeDescriptionLength, maxRowLength: nodeDescriptionMaxRowLength)
        let targetNodeVisualisation = visualiseNode(nodeIndex: targetNodeIndex, node: targetNode, descriptionLength: nodeDescriptionLength, maxRowLength: nodeDescriptionMaxRowLength)
        
        return "\(originNodeVisualisation) -->|\(edgeLable)| \(targetNodeVisualisation)"
    }
    
    private func getGraphEdges(graph: QuestGraphSG) -> [WeightedEdge<QuestGraphActionEdgeSG>]
    {
        var res = [WeightedEdge<QuestGraphActionEdgeSG>]()
        for e in graph.edges {
            res.append(contentsOf: e)
        }
        
        return res
    }
    
    private func visualiseEdgeContent(edge: WeightedEdge<QuestGraphActionEdgeSG>) -> String {
        return "\(edge.weight.name)\\\(edge.weight.action)"
    }
    
    private func visualiseNode(nodeIndex: Int, node : QuestGraphNodeSG, descriptionLength: Int, maxRowLength: Int) -> String {
        let nodeContent = visualiseNodeContent(node: node, descriptionLength: descriptionLength, maxRowLength: maxRowLength)
        var nodeVisualisation = "\(nodeIndex)"
        
        if node is ConditionalNode {
            nodeVisualisation += "{\(nodeContent)}"
        } else if node is NodeWhichUpdatesState {
            nodeVisualisation += "[(\(nodeContent))]"
        }
        else {
            nodeVisualisation += "([\(nodeContent)])"
        }
        
        if let nodeClass = getNodeStyleClass(node:node) {
            nodeVisualisation += ":::\(nodeClass)"
        }
        
        return nodeVisualisation
    }
    
    private func visualiseNodeContent(node: QuestGraphNodeSG, descriptionLength: Int, maxRowLength: Int) -> String {
        var content = "<b>\(node.name)</b>"
        content += "\\n Skipable: \(node.isSkipable)"
        
        if let nodeDescription = node.description {
            var shortenNodeDescription = String(nodeDescription.prefix(descriptionLength))
            
            // Avoid long description lines by breaking them in small ones
            for i in stride(from: 0, to: shortenNodeDescription.count, by: maxRowLength) {
                let index = shortenNodeDescription.index(shortenNodeDescription.startIndex, offsetBy: i)
                shortenNodeDescription.insert(contentsOf:"\\n", at: index)
            }
            
            content += "\\n \(shortenNodeDescription)"
        }
        
        return content
    }
    
    private func getNodeStyleClass(node: QuestGraphNodeSG) -> String? {
        if (node.isStart) {
            return startNodeStyleClassName
        }
        
        if (node.isEnd) {
            return endNodeStyleClassName
        }
        
        if (node.isSkipable){
            return skipableNodeStyleClassName
        }
        return nil
    }
    
    private func buildMermaidStyleConfig() -> String {
        let startNodeColor = UIColor.green.hexString!
        let endNodeColor = UIColor.orange.hexString!
        let skipableNodeColor = UIColor.yellow.hexString!
        
        return """
                classDef \(startNodeStyleClassName) fill:\(startNodeColor)
                classDef \(endNodeStyleClassName) fill:\(endNodeColor)
                classDef \(skipableNodeStyleClassName) fill:\(skipableNodeColor)
                """
    }
}

extension UIColor {
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}

