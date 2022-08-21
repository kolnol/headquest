//
//  QuestFixture.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 15.08.22.
//

import Foundation

class GraphEdge: Equatable
{
	static func == (lhs: GraphEdge, rhs: GraphEdge) -> Bool
	{
		lhs.to == rhs.to && lhs.from == rhs.from && lhs.weight == rhs.weight
	}

	let from: String
	let to: String
	let weight: QuestGraphActionEdgeSG

	init(from: String, to: String, weight: QuestGraphActionEdgeSG)
	{
		self.from = from
		self.to = to
		self.weight = weight
	}

	public var description: String
	{
		String(format: "GraphEdge:{ \n from: %$ \n to: %$ \n}", [from, to])
	}
}

class QuestFixtureBase: LoggingComponent
{
	var edges: [GraphEdge] = []
	var nodes: [String: QuestGraphNodeSG] = [:]
	var graph: QuestGraphSG?

	override init()
	{
		super.init()
		nodes = buildNodes()
		edges = buildEdges()
	}

	func buildNodes() -> [String: QuestGraphNodeSG] { fatalError("Must Override") }
	func buildEdges() -> [GraphEdge] { fatalError("Must Override") }

	func buildGraph() -> QuestGraphSG
	{
		let graph = QuestGraphSG()

		for node in nodes.values
		{
			_ = graph.addVertex(node)
		}

		for edge in edges
		{
			graph.addEdge(from: nodes[edge.from]!, to: nodes[edge.to]!, weight: edge.weight, directed: true)
		}

		return graph
	}

	/// the functions adds nodes and edges from the provided subgraph
	///  if the node already exists it will fail
	///  if the edge from the same node with the same weigth(action) exists it will be replaced with the new one
	func addSubgraph(graphFixture: QuestFixtureBase) -> QuestFixtureBase
	{
		for node in graphFixture.nodes
		{
			if nodes[node.key] != nil
			{
				fatalError("The node created in subgraph already exists in the main graph")
			}

			nodes.updateValue(node.value, forKey: node.key)
		}

		for edge in graphFixture.edges
		{
			if edgeExists(edge: edge, edges: edges)
			{
				logger.info("Trying to add edge which already exists \(edge.description). Skipping.")
				continue
			}

			tryReplaceEdge(edge: edge, edgesToProcess: &edges)
		}

		return self
	}

	func edgeExists(edge: GraphEdge, edges: [GraphEdge]) -> Bool
	{
		edges.contains
		{ internalEdge in
			edge == internalEdge
		}
	}

	/// the function checks if the edge starting point is the same and the weight is the same
	/// it is used to identify if we should replace the existing edge with a new one
	func tryReplaceEdge(edge: GraphEdge, edgesToProcess: inout [GraphEdge])
	{
		// we expect only one edge
		let edgeIndexToReplace = edgesToProcess.firstIndex(where: { internalEdge in
			internalEdge.from == edge.from && internalEdge.weight == edge.weight
		})

		if edgeIndexToReplace == nil
		{
			edgesToProcess.append(edge)
			return
		}

		let edgeToReplace = edgesToProcess[edgeIndexToReplace!]
		logger.info("Replacing edges \(edgeToReplace.description) with edge \(edge.description)")

		edgesToProcess.remove(at: edgeIndexToReplace!)
		edgesToProcess.append(edge)
	}

	static func createButtonsSuggestion(onPrevAction: String, onPlayAction: String, onNextAction: String) -> String
	{
		"Press previous button for \(onPrevAction). Press play button for \(onPlayAction). Press next button for \(onNextAction)."
	}

	private static func getLongText() -> String
	{
		"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. "
	}
}
