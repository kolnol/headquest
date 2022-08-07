//
//  QuestGraph.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 10.05.22.
//

import Foundation
import SwiftGraph

protocol QuestGraph {
    func traverse(questNode: QuestGraphNode, action: QuestGraphActionEdge) -> QuestGraphNode
}
