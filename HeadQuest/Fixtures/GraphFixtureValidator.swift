//
//  GraphValidator.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 20.08.22.
//

import Foundation
import SwiftGraph

class GrpahFixtureValidator: LoggingComponent
{
	let nodeValidator: GraphFixtureNodeValidator
	let edgeValidator: GraphFixtureEdgeValidator

	init(nodeValidator: GraphFixtureNodeValidator, edgeValidator: GraphFixtureEdgeValidator)
	{
		self.nodeValidator = nodeValidator
		self.edgeValidator = edgeValidator
	}

	func validate(graph: QuestGraphSG) throws
	{
		logger.info("Validating graph...")
		// check nodes
		try checkNodes(graph: graph)

		// check edges
		try checkEdges(graph: graph)

		// no duplicated nodes
		try checkDuplicatedNodes(graph: graph)

		// no duplicate edges
		try checkDuplicatedEdges(graph: graph)

		// no edges of the same action from one origin
		try checkUniqueActionPossibilities(graph: graph)

		// check if node has no out edges then it is the end and vice versa
		try validateEndNodes(graph: graph)

		// every path has an end (can be problematic with cycles)
		// TODO: test it for weighted graph
		// try validateEveryPathHasEnd(graph: graph)

		logger.info("Graph passed validation.")
	}

	private func checkNodes(graph: QuestGraphSG) throws
	{
		for node in graph.vertices
		{
			try nodeValidator.validate(node: node)
		}
	}

	private func checkEdges(graph: QuestGraphSG) throws
	{
		for edge in getGraphEdges(graph: graph)
		{
			try edgeValidator.validate(edge: edge)
		}
	}

	private func checkDuplicatedNodes(graph: QuestGraphSG) throws
	{
		let duplicatedNodes = findDuplicatedNodes(graph: graph)
		if !duplicatedNodes.isEmpty
		{
			throw GraphFixtureValidationError.duplicatedNodes(message: "Following nodes are duplicated \(duplicatedNodes.map(\.name))")
		}
	}

	private func checkDuplicatedEdges(graph: QuestGraphSG) throws
	{
		let duplicatedEdges = findDuplicatedEdges(graph: graph)
		if !duplicatedEdges.isEmpty
		{
			throw GraphFixtureValidationError.duplicatedNodes(message: "Following edges are duplicated \(duplicatedEdges)")
		}
	}

	private func checkUniqueActionPossibilities(graph: QuestGraphSG) throws
	{
		for node in graph.vertices
		{
			guard
				let outEdges = graph.edgesForVertex(node)?.filter({ (edge: WeightedEdge<QuestGraphActionEdgeSG>) in
					edge.u == graph.indexOfVertex(node)
				})
			else
			{
				continue
			}

			if outEdges.isEmpty
			{
				continue
			}

			let duplicatedEdges = findDuplicatedGeneric(collection: outEdges)
			if !duplicatedEdges.isEmpty
			{
				throw GraphFixtureValidationError.nonUniqueAction(message: "Found non unique set of actions for node \(node.name) with actions \(outEdges)")
			}
		}
	}

	private func validateEndNodes(graph: QuestGraphSG) throws
	{
		for node in graph.vertices
		{
			let outEdges = graph.edgesForVertex(node)?.filter
			{ (edge: WeightedEdge<QuestGraphActionEdgeSG>) in
				edge.u == graph.indexOfVertex(node)
			}

			if outEdges != nil, !outEdges!.isEmpty
			{
				// non empty outEdges
				if node.isEnd
				{
					throw GraphFixtureValidationError.endNodeVialation(message: "Found node \(node.name) which is an end node but has output edges \(outEdges!.map(\.weight.name)).")
				}
			}
			else
			{
				// empty outEdges
				if !node.isEnd
				{
					throw GraphFixtureValidationError.endNodeVialation(message: "Found node \(node.name) which has no out edges but is not end node.")
				}
			}
		}
	}

	private func validateEveryPathHasEnd(graph: QuestGraphSG) throws
	{
		let endNodes = graph.vertices.filter
		{ node in
			node.isEnd
		}

		for node in graph.vertices
		{
			if node.isEnd
			{
				continue
			}

			var pathFound = false
			for endNode in endNodes
			{
				// TODO: as we use weighted graph should we use dijkstra?
				let path = graph.dfs(from: node, to: endNode)

				if !path.isEmpty
				{
					pathFound = true
					break
				}
			}

			if !pathFound
			{
				throw GraphFixtureValidationError.noPathToTheEndFound(message: "No path found between node \(node.name) and any of the end nodes \(endNodes.map(\.name))")
			}
		}
	}

	private func findDuplicatedNodes(graph: QuestGraphSG) -> [QuestGraphNodeSG]
	{
		findDuplicatedGeneric(collection: graph.vertices)
	}

	private func findDuplicatedEdges(graph: QuestGraphSG) -> [WeightedEdge<QuestGraphActionEdgeSG>]
	{
		findDuplicatedGeneric(collection: getGraphEdges(graph: graph))
	}

	private func findDuplicatedGeneric<T>(collection: [T]) -> [T] where T: Hashable
	{
		let setOfItems: Set<T> = Set(collection)
		if setOfItems.count == collection.count
		{
			return []
		}

		var amountOfItemsInList: [T: Int] = [:]

		for item in collection
		{
			if let itemsAmount = amountOfItemsInList[item]
			{
				amountOfItemsInList.updateValue(itemsAmount + 1, forKey: item)
				continue
			}
			amountOfItemsInList.updateValue(1, forKey: item)
		}

		var duplicatedItems: [T] = []
		for (item, amount) in amountOfItemsInList
		{
			if amount > 1
			{
				duplicatedItems.append(item)
			}
		}
		return duplicatedItems
	}

	private func getGraphEdges(graph: QuestGraphSG) -> [WeightedEdge<QuestGraphActionEdgeSG>]
	{
		graph.edges[0]
	}
}

class GraphFixtureNodeValidator
{
	func validate(node _: QuestGraphNodeSG) throws
	{}
}

class GraphFixtureEdgeValidator
{
	func validate(edge _: WeightedEdge<QuestGraphActionEdgeSG>) throws
	{}
}

enum GraphFixtureValidationError
{
	case duplicatedNodes(message: String?)
	case duplicatedEdges(message: String?)
	case nonUniqueAction(message: String?)
	case endNodeVialation(message: String?)
	case noPathToTheEndFound(message: String?)
}

extension GraphFixtureValidationError: LocalizedError
{
	public var errorDescription: String?
	{
		switch self
		{
		case
			let .duplicatedNodes(message),
			let .nonUniqueAction(message),
			let .endNodeVialation(message),
			let .noPathToTheEndFound(message),
			let .duplicatedEdges(message):
			return message
		}
	}
}
