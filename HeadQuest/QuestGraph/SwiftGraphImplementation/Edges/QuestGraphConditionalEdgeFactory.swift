//
//  QuestGraphPositiveConditionEdge.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 21.08.22.
//

import Foundation

class QuestGraphConditionalEdgeFactory {
    
    static let fullfilledEdgeName: String = "yes"
    static let notFullfilledEdgeName:String = "no"
    
        public static func createConditionalNode(edgeType: ConditionalEdgeTypes) -> QuestGraphActionEdgeSG {
        switch edgeType {
        case .fullfilledConditionEdge:
            return QuestGraphActionEdgeSG(name: fullfilledEdgeName)
        case .notFullfilledConditionEdge:
            return QuestGraphActionEdgeSG(name: notFullfilledEdgeName)
        }
    }
}
