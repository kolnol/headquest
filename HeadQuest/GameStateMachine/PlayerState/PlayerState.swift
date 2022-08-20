//
//  PlayerState.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 15.08.22.
//

import Foundation

public final class PlayerState
{
	// Singleton implementation
	public static let shared = PlayerState()
	private let serialQueue = DispatchQueue(label: "playerStateSerialQueue")

	// Health
	public let healthState: HealthState = .shared

	private init() {}
}

public final class PlayerStateWithInstances
{
	// Singleton implementation
	public static let shared = PlayerStateWithInstances()
	private let serialQueue = DispatchQueue(label: "playerStateSerialQueue")

	// Health
	private var healthState = HealthState.shared

	// GameState
	private var gameState = GameState.shared

	private init() {}
}

public enum PlayerStateError: Error
{
	case CanNotHealError(message: String)
}

extension PlayerStateError: LocalizedError
{
	public var errorDescription: String?
	{
		switch self
		{
		case
			let .CanNotHealError(message):
			return message
		}
	}
}
