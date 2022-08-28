//
//  PlayerState.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 15.08.22.
//

import Foundation


// NOT USED YET
public final class PlayerState
{
	// Singleton implementation
	public static let shared = PlayerState()
	private let serialQueue = DispatchQueue(label: "playerStateSerialQueue")

	// Health
	public let healthState: HealthState = HealthState.shared

	private init() {}
    
//    public func reset() {
//        serialQueue.sync {
//            //healthState.reset()
//        }
//    }
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
