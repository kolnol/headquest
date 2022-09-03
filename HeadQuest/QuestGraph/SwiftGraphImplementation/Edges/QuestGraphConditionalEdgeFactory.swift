//
//  QuestGraphPositiveConditionEdge.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 21.08.22.
//

import Foundation

public class QuestGraphConditionalEdgeFactory
{
	public static let fullfilledEdgeName: String = "yes"
	public static let notFullfilledEdgeName: String = "no"

	public static func createConditionalNode(edgeType: ConditionalEdgeTypes) -> QuestGraphActionEdgeSG
	{
		switch edgeType
		{
		case .fullfilledConditionEdge:
            return QuestGraphActionEdgeSG(name: fullfilledEdgeName, action: MediaActions.Play)
		case .notFullfilledConditionEdge:
            return QuestGraphActionEdgeSG(name: notFullfilledEdgeName, action: MediaActions.Play)
		}
	}
}
