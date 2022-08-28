//
//  GameState.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 15.08.22.
//

import Foundation
//
//public final class GameState
//{
//	// Singleton implementation
//	public static let shared = GameState()
//	private let serialQueue = DispatchQueue(label: "gameStateSerialQueue")
//	private let palyerState = PlayerState.shared
//
//	private var hasTalkedToOldMan: Bool = false
//
//	private init() {}
//
//	// GameState
//	public func readHasTalkedToOldMan() -> Bool
//	{
//		var value: Bool?
//		serialQueue.sync
//		{
//			value = hasTalkedToOldMan
//		}
//		return value!
//	}
//
//	public func updateHasTalkedToOldMan(newHasTalkedToOldMan: Bool)
//	{
//		serialQueue.sync
//		{
//			hasTalkedToOldMan = newHasTalkedToOldMan
//		}
//	}
//}

public final class GameStateWithDictionary
{
	// Singleton implementation
	public static let shared = GameStateWithDictionary()
	private let serialQueue = DispatchQueue(label: "gameStateSerialQueue")
	//private let palyerState = PlayerState.shared

	private var stateToValueMap: [String: String] = [GameStateConstants.hasTalkedToOldMan.rawValue: "false"]

	private init() {}

	// GameState
	public func readState(for state: String) -> String?
	{
		var value: String?
		serialQueue.sync
		{
			value = stateToValueMap[state]
		}
		return value
	}

	public func addOrUpdateState(state: String, content: String)
	{
		_ = serialQueue.sync
		{
			self.stateToValueMap.updateValue(content, forKey: state)
		}
	}
    
    public func reset() {
        serialQueue.sync
        {
            self.stateToValueMap = [
                GameStateConstants.hasTalkedToOldMan.rawValue: "false",
                GameStateConstants.hp.rawValue: "3",
                GameStateConstants.isDead.rawValue: "false"
            ]
            //palyerState.reset()
        }
    }
}

enum GameStateConstants: String, Decodable
{
	case hasTalkedToOldMan
    case hp
    case isDead
}
