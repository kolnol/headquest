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
        
//        let graphVisualiser = MermaidGraphVisualiser()
//        graphVisualiser.visualise(graph: graph)
		
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

        questGraph.addEdge(from: skipableStartingNode, to: secondSkip, weight: QuestGraphActionEdgeSG(name: "Skip action", action: MediaActions.Play), directed: true)
        questGraph.addEdge(from: secondSkip, to: nextNodeAfterSkip, weight: QuestGraphActionEdgeSG(name: "Skip action", action: MediaActions.Play), directed: true)

		return questGraph
	}
    
    static func TestConditionalNodes() -> QuestGraphSG
    {
        let startingNode = QuestGraphNodeSG(
            name: "Start",
            description: "This is a start",
            isStart: true, isSkipable: true
        )
        
        let conditionalNode = ConditionalNode(name: "HasTalkedToOldMan", gameStatePropertyToCheck: GameStateConstants.hasTalkedToOldMan, expectedValue: true.description)

        let noNode = QuestGraphNodeSG(
            name: "NoNode",
            description: "This is no node",
            isSkipable: true
        )

        let yesNode = QuestGraphNodeSG(
            name: "YesNode",
            description: "This is Yes Node",
            isEnd: true
        )
        
        let changeStateNode = NodeWhichUpdatesState(name: "UpdateStateNode", description: "Update state", gameStatePropertyToUpdate: GameStateConstants.hasTalkedToOldMan, updatedValue: true.description)
        
        let questGraph = QuestGraphSG(vertices:
            [
                startingNode,
                conditionalNode,
                noNode,
                yesNode,
                changeStateNode
            ])

        questGraph.addEdge(from: startingNode, to: conditionalNode, weight: QuestGraphActionEdgeSG(name: "Skip action", action: MediaActions.Play), directed: true)
        
        questGraph.addEdge(from: conditionalNode, to: noNode, weight: QuestGraphConditionalEdgeFactory.createConditionalNode(edgeType: ConditionalEdgeTypes.notFullfilledConditionEdge), directed: true)
        
        questGraph.addEdge(from: noNode, to: changeStateNode, weight: QuestGraphActionEdgeSG(name: "Update state", action: MediaActions.Play), directed: true)
        
        questGraph.addEdge(from: changeStateNode, to: conditionalNode, weight: QuestGraphActionEdgeSG(name: "loop until true", action: MediaActions.Play), directed: true)
        
        questGraph.addEdge(from: conditionalNode, to: yesNode, weight: QuestGraphConditionalEdgeFactory.createConditionalNode(edgeType: ConditionalEdgeTypes.fullfilledConditionEdge), directed: true)

        return questGraph
    }
}
