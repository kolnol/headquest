//
//  QuestGraphActionEdge.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 16.05.22.
//

import Foundation

public class QuestGraphActionEdgeSG: QuestGraphActionEdge, Decodable, Encodable, Equatable {
    var name: String

    init(name: String) {
        self.name = name
    }

    public static func == (lhs: QuestGraphActionEdgeSG, rhs: QuestGraphActionEdgeSG) -> Bool {
        lhs.name == rhs.name
    }
}
