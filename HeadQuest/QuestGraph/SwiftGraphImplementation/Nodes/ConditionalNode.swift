//
//  ConditionalNode.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 21.08.22.
//

import Foundation

public class ConditionalNode: QuestGraphNodeSG
{
    var gameStatePropertyToCheck: GameStateConstants
    var expectedValue: String
    
    private enum CodingKeys: String, CodingKey
    {
        case gameStatePropertyToCheck
        case expectedValue
    }

    init(name: String, gameStatePropertyToCheck: GameStateConstants, expectedValue: String)
    {
        self.gameStatePropertyToCheck = gameStatePropertyToCheck
        self.expectedValue = expectedValue
        
        super.init(name: name, description: "", isEnd: false, backgroundMusicFile: nil, preVoiceSound: nil, postVoiceSound: nil, isSkipable: true)
    }
    
    // TODO extend to support not only equalence
    public func evaluateCondition() -> Bool {
        return GameStateWithDictionary.shared.readState(for: gameStatePropertyToCheck.rawValue) == expectedValue
    }
    
    required init(from decoder: Decoder) throws
    {
        expectedValue = try decoder.container(keyedBy: ConditionalNode.CodingKeys.self)
            .decode(String.self, forKey: .expectedValue)
        gameStatePropertyToCheck = try decoder.container(keyedBy: ConditionalNode.CodingKeys.self)
            .decode(GameStateConstants.self, forKey: .gameStatePropertyToCheck)
        try super.init(from: decoder)
    }
}

enum ConditionalEdgeTypes {
    case fullfilledConditionEdge
    case notFullfilledConditionEdge
}
