//
//  GraphFixtureValidatorTests.swift
//  HeadQuestTests
//
//  Created by Mykola Odnoshyvkin on 21.08.22.
//

import Foundation

@testable import HeadQuest
import XCTest

class GraphFixtureValidatorTests: XCTestCase
{
	var graphValidator: GrpahFixtureValidator!

	override func setUp()
	{
		super.setUp()

		let nodeValidator = GraphFixtureNodeValidator()
		let edgeValidator = GraphFixtureEdgeValidator()
		graphValidator = GrpahFixtureValidator(nodeValidator: nodeValidator, edgeValidator: edgeValidator)
	}

	func testGraphFixtureValidatorTests_DemoQuest_Is_valid() throws
	{
		let graph = DemoQuest().buildGraph()

		// validate graph
		try graphValidator.validate(graph: graph)
	}

	func test_FireDoorDialogue_with_DemoQuest_Is_valid() throws
	{
		let graph = DemoQuest()
			.addSubgraph(graphFixture: FireDoorDialogue())
			.buildGraph()
		try graphValidator.validate(graph: graph)
	}

	func test_NotEndingQuest_fail_with_endNodeVialation() throws
	{
		let graph = NotEndingQuest().buildGraph()

		do
		{
			try graphValidator.validate(graph: graph)
		}
		catch let GraphFixtureValidationError.endNodeVialation(message)
		{
			XCTAssert(!message!.isEmpty)
		}
	}

	func test_CyclicGraphWithNoEnd_fail_with_noPathToTheEndFound() throws
	{
		let graph = CyclicGraphWithNoEnd().buildGraph()

		do
		{
			try graphValidator.validate(graph: graph)
		}
		catch let GraphFixtureValidationError.noPathToTheEndFound(message)
		{
			XCTAssert(!message!.isEmpty)
		}
	}
    
    func test_NoRootNodeGraph_fail_with_no_root_node() throws
    {
        let graph = NoRootNodeGraph().buildGraph()

        do
        {
            try graphValidator.validate(graph: graph)
        }
        catch let GraphFixtureValidationError.rootNodeError(message)
        {
            XCTAssert(!message!.isEmpty)
        }
    }
}

class NotEndingQuest: QuestFixtureBase
{
	override func buildNodes() -> [String: QuestGraphNodeSG]
	{
		let start = QuestGraphNodeSG(name: "start", description: "start", isStart: true)
		let end = QuestGraphNodeSG(name: "end", description: "end", isEnd: true, isSkipable: false)

		var internalNodes = [String: QuestGraphNodeSG]()
		internalNodes.updateValue(start, forKey: "start")
		internalNodes.updateValue(end, forKey: "end")

		return internalNodes
	}

	override func buildEdges() -> [GraphEdge]
	{
		[]
	}
}

class CyclicGraphWithNoEnd: QuestFixtureBase
{
	override func buildNodes() -> [String: QuestGraphNodeSG]
	{
		let start = QuestGraphNodeSG(name: "start", description: "start", isStart: true)
		let secondNode = QuestGraphNodeSG(name: "second", description: "second")
		let end = QuestGraphNodeSG(name: "end", description: "end", isEnd: true, isSkipable: false)

		var internalNodes = [String: QuestGraphNodeSG]()
		internalNodes.updateValue(start, forKey: "start")
		internalNodes.updateValue(secondNode, forKey: "second")
		internalNodes.updateValue(end, forKey: "end")

		return internalNodes
	}

	override func buildEdges() -> [GraphEdge]
	{
		var edges = [GraphEdge]()

		edges.append(GraphEdge(from: "start", to: "second", weight: QuestGraphActionEdgeSG(name: "start_second")))

		edges.append(GraphEdge(from: "second", to: "start", weight: QuestGraphActionEdgeSG(name: "second_start")))

		return edges
	}
}

class NoRootNodeGraph: QuestFixtureBase
{
    override func buildNodes() -> [String: QuestGraphNodeSG]
    {
        let end = QuestGraphNodeSG(name: "end", description: "end", isEnd: true, isSkipable: false)

        var internalNodes = [String: QuestGraphNodeSG]()
        internalNodes.updateValue(end, forKey: "end")

        return internalNodes
    }

    override func buildEdges() -> [GraphEdge]
    {
        []
    }
}
