//
//  GameState.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 15.08.22.
//

import Foundation

public final class GameState
{
	// Singleton implementation
	public static let shared = GameState()
	private let serialQueue = DispatchQueue(label: "gameStateSerialQueue")
	private let palyerState = PlayerState.shared

	private var hasTalkedToOldMan: Bool = false

	private init() {}

	// GameState
	public func readHasTalkedToOldMan() -> Bool
	{
		var value: Bool?
		serialQueue.sync
		{
			value = hasTalkedToOldMan
		}
		return value!
	}

	public func updateHasTalkedToOldMan(newHasTalkedToOldMan: Bool)
	{
		serialQueue.sync
		{
			hasTalkedToOldMan = newHasTalkedToOldMan
		}
	}
}
