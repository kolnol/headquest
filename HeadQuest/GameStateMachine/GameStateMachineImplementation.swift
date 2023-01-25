//
//  GameStateMachine.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 16.07.22.
//

import AVFoundation
import Foundation

class GameStateMachineImplementation
{
	var gameGraph: QuestGraphSG
	var currentNode: QuestGraphNodeSG

	init(gameGraph: QuestGraphSG)
	{
		self.gameGraph = gameGraph
        currentNode = gameGraph.getRootNode()
	}
    
	func updateStateByAction(mediaAction: MediaActions) throws -> QuestGraphNodeSG
	{
		// Find new current node
		guard let edge = try? actionToEdge(mediaAction: mediaAction, node: currentNode, graph: gameGraph)
		else
		{
			throw GameStateMachineError.noEdgeFound(message: "No edge found from node \(currentNode.name) by action \(mediaAction).")
		}

		guard let newNode = gameGraph.traverse(questNode: currentNode, action: edge)
		else
		{
			throw GameStateMachineError.noNodeFound(message: "No node found from node \(currentNode.name) by action \(mediaAction).")
		}
    
		currentNode = newNode
        
		return currentNode
	}

	func goNext() throws -> QuestGraphNodeSG
	{
		if !currentNode.isSkipable
		{
			throw GameStateMachineError.notSkipableState(message: "Go next is not possible as it is not clear to which state to go")
		}

        if let condNode = currentNode as? ConditionalNode {
            
            let newNode = try goNextConditionalNode(condNode: condNode)
            currentNode = newNode
            return newNode
        }
        
        if let stateUpdate = currentNode as? NodeWhichUpdatesState {
            stateUpdate.updateState()
        }
        
		guard let edges = gameGraph.edgesForVertex(currentNode)
		else
		{
			throw GameStateMachineError.noEdgeFound(message: "No edges found for the node \(currentNode.name)")
		}

		if edges.count != 1
		{
			throw GameStateMachineError.notSkipableState(message: "Go next is not possible as it is not clear to which state to go")
		}

		let edge = edges.first!
		guard let newNode = gameGraph.traverse(questNode: currentNode, action: edge.weight)
		else
		{
			throw GameStateMachineError.noNodeFound(message: "No node found from node \(currentNode.name) by action \(edge.weight.name).")
		}

		currentNode = newNode
		return newNode
	}
    
    // TODO make it to strategy pattern
    private func goNextConditionalNode(condNode: ConditionalNode) throws -> QuestGraphNodeSG {
        guard let edges = gameGraph.edgesForVertex(condNode)
        else
        {
            throw GameStateMachineError.noEdgeFound(message: "No edges found for the node \(condNode.name)")
        }
        let edge = edges.first { edge in
                edge.weight.name == (condNode.evaluateCondition() ? QuestGraphConditionalEdgeFactory.fullfilledEdgeName : QuestGraphConditionalEdgeFactory.notFullfilledEdgeName)
            }!
        guard let newNode = gameGraph.traverse(questNode: condNode, action: edge.weight)
        else
        {
            throw GameStateMachineError.noNodeFound(message: "No node found from node \(condNode.name) by action \(edge.weight.name).")
        }
        
        return newNode
    }
    
	private func actionToEdge(mediaAction: MediaActions, node: QuestGraphNodeSG, graph: QuestGraphSG) throws -> QuestGraphActionEdgeSG
	{
		guard let edges = graph.edgesForVertex(node)
		else
		{
			throw GameStateMachineError.noEdgeFound(message: "No edges found for the node \(node.name)")
		}
        
        let edge = edges.first { edge in
            edge.weight.action == mediaAction
        }
        
        return edge!.weight
	}

	func reset()
	{
        currentNode = gameGraph.getRootNode()
	}

	func isEnd() -> Bool
	{
		currentNode.isEnd
	}
}
