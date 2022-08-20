//
//  GameStateMachineError.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 14.08.22.
//

import Foundation

enum GameStateMachineError: Error
{
	case noEdgeFound(message: String)
	case noNodeFound(message: String)
	case notSkipableState(message: String)
}

extension GameStateMachineError: LocalizedError
{
	public var errorDescription: String?
	{
		switch self
		{
		case
			let .noEdgeFound(message),
			let .noNodeFound(message),
			let .notSkipableState(message):
			return message
		}
	}
}
