//
//  FireDoorDialogue.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 21.08.22.
//

import Foundation

class FireDoorDialogue: QuestFixtureBase
{
    override func buildNodes() -> [String: QuestGraphNodeSG]
    {
        
        let hasTalkedToOldManConditionalNode = ConditionalNode(name: "HasTalkedToOldMan", gameStatePropertyToCheck: GameStateConstants.hasTalkedToOldMan, expectedValue: true.description)
        
        let oldManOfferingHelp = QuestDialogueNode(
            name: "oldManOfferingHelp",
            description: "You look lost, maybe I can help you?",
            isEnd: false,
            backgroundMusicFile: "old_man_campfire_background",
            npc: "Old Man"
        )
        
        let oldManWelcomesBack = QuestDialogueNode(
            name: "oldManWelcomesBack",
            description: "Oh, you are back. Nice to see you again. How can I help you?",
            isEnd: false,
            backgroundMusicFile: "old_man_campfire_background",
            npc: "Old Man"
        )
        
        let decidingAboutHelp = QuestGraphNodeSG(name: "decidingAboutHelp", description: "By coming closer you can see that a man has a long beard and not so friendly face. Press previous button for accepting the help. Press play button to discard the help and come back.")

        
        
        var internalNodes = [String: QuestGraphNodeSG]()
        
        internalNodes.updateValue(oldManOfferingHelp, forKey: "oldManOfferingHelp")
        internalNodes.updateValue(hasTalkedToOldManConditionalNode, forKey: "hasTalkedToOldManConditionalNode")
        internalNodes.updateValue(decidingAboutHelp, forKey: "decidingAboutHelp")
        internalNodes.updateValue(oldManWelcomesBack, forKey: "oldManWelcomesBack")
        
        return internalNodes
    }

    override func buildEdges() -> [GraphEdge]
    {
        var edges = [GraphEdge]()

        edges.append(GraphEdge(from: "hasTalkedToOldManConditionalNode", to: "oldManOfferingHelp", weight: QuestGraphConditionalEdgeFactory.createConditionalNode(edgeType: ConditionalEdgeTypes.notFullfilledConditionEdge)))
        edges.append(GraphEdge(from: "hasTalkedToOldManConditionalNode", to: "oldManWelcomesBack", weight: QuestGraphConditionalEdgeFactory.createConditionalNode(edgeType: ConditionalEdgeTypes.fullfilledConditionEdge)))
        
        edges.append(GraphEdge(from: "oldManOfferingHelp", to: "decidingAboutHelp", weight: QuestGraphActionEdgeSG(name: "decidingAboutHelp")))

        
        edges.append(GraphEdge(from: "fireDoorV", to: "hasTalkedToOldManConditionalNode", weight: QuestGraphActionEdgeSG(name: "talk")))
        
        return edges
    }
}
