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
}
