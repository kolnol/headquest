//
//  QuestGraphFixtures.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 10.05.22.
//

import Foundation

struct QuestGraphFixtures
{
	static func SimpleQuest() throws -> QuestGraphSG
	{
		let graph = DemoQuest()
			.addSubgraph(graphFixture: FireDoorDialogue())
			.buildGraph()

		// validate graph
		let nodeValidator = GraphFixtureNodeValidator()
		let edgeValidator = GraphFixtureEdgeValidator()
		let graphValidator = GrpahFixtureValidator(nodeValidator: nodeValidator, edgeValidator: edgeValidator)

		try graphValidator.validate(graph: graph)
		return graph
	}

	static func TestSkipableQuest() -> QuestGraphSG
	{
		let skipableStartingNode = QuestGraphNodeSG(
			name: "Start",
			description: "This is a skipable state with music. Please skip me.",
			backgroundMusicFile: "dungeon_backgraound.mp3", preVoiceSound: "dungeon_door_open.wav",
			isSkipable: true
		)

		let secondSkip = QuestGraphNodeSG(
			name: "After skip",
			description: "This will be skipped as well",
			backgroundMusicFile: "dungeon_backgraound.mp3",
			preVoiceSound: "dungeon_door_open.wav",
			isSkipable: true
		)

		let nextNodeAfterSkip = QuestGraphNodeSG(
			name: "After skip2",
			description: "This node is after skip. Automatically started?",
			isEnd: true
		)

		let questGraph = QuestGraphSG(vertices:
			[
				skipableStartingNode,
				secondSkip,
				nextNodeAfterSkip,
			])

		questGraph.addEdge(from: skipableStartingNode, to: secondSkip, weight: QuestGraphActionEdgeSG(name: "Skip action"), directed: true)
		questGraph.addEdge(from: secondSkip, to: nextNodeAfterSkip, weight: QuestGraphActionEdgeSG(name: "Skip action"), directed: true)

		return questGraph
	}
}
