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

	// TODO: make it better
	private func actionToEdge(mediaAction: MediaActions, node: QuestGraphNodeSG, graph: QuestGraphSG) throws -> QuestGraphActionEdgeSG
	{
		guard let edges = graph.edgesForVertex(node)
		else
		{
			throw GameStateMachineError.noEdgeFound(message: "No edges found for the node \(node.name)")
		}

		return edges[mediaAction.rawValue].weight
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
