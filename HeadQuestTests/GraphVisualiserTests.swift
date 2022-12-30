//
//  GraphVisualiserTests.swift
//  HeadQuestTests
//
//  Created by Mykola Odnoshyvkin on 30.12.22.
//

import Foundation

@testable import HeadQuest
import XCTest

class GraphVisualiserTests: XCTestCase
{
    var graphVisualiser: MermaidGraphVisualiser!

    override func setUp()
    {
        super.setUp()

        graphVisualiser = MermaidGraphVisualiser()
    }

    func testGraphFixtureValidatorTests_DemoQuest_Is_valid() throws
    {
        let graph = DemoQuest().buildGraph()

        // validate graph
        graphVisualiser.visualise(graph: graph)
    }

    func test_FireDoorDialogue_with_DemoQuest_Is_valid() throws
    {
        let graph = DemoQuest()
            .addSubgraph(graphFixture: FireDoorDialogue())
            .buildGraph()
        graphVisualiser.visualise(graph: graph)
    }
}


