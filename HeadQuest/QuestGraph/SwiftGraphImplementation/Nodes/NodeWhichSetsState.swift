//
//  NodeWhichSetsState.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 24.08.22.
//

import Foundation

public class NodeWhichUpdatesState: QuestGraphNodeSG {
    var gameStatePropertyToUpdate: GameStateConstants
    var updatedValue: String
    
    private enum CodingKeys: String, CodingKey
    {
        case gameStatePropertyToUpdate
        case updatedValue
    }

    init(name: String, description: String?, isEnd: Bool = false, backgroundMusicFile: String? = nil, preVoiceSound: String? = nil, postVoiceSound: String? = nil, isSkipable: Bool = false, gameStatePropertyToUpdate: GameStateConstants, updatedValue: String)
    {
        self.gameStatePropertyToUpdate = gameStatePropertyToUpdate
        self.updatedValue = updatedValue

        super.init(name: name, description: description, isEnd: isEnd, backgroundMusicFile: backgroundMusicFile, preVoiceSound: preVoiceSound, postVoiceSound: postVoiceSound, isSkipable: isSkipable)
    }
    
    required init(from decoder: Decoder) throws {
        updatedValue = try decoder.container(keyedBy: NodeWhichUpdatesState.CodingKeys.self)
            .decode(String.self, forKey: .updatedValue)
        gameStatePropertyToUpdate = try decoder.container(keyedBy: NodeWhichUpdatesState.CodingKeys.self)
            .decode(GameStateConstants.self, forKey: .gameStatePropertyToUpdate)
        try super.init(from: decoder)
    }
    
    public func updateState() {
        GameStateWithDictionary.shared.addOrUpdateState(state: gameStatePropertyToUpdate.rawValue, content: updatedValue)
    }
}
