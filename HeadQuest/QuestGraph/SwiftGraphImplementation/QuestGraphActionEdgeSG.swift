//
//  QuestGraphActionEdge.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 16.05.22.
//

import Foundation

class QuestGraphActionEdgeSG: QuestGraphActionEdge, Decodable, Encodable, Equatable{
    var name: String
    
    init(name:String) {
        self.name=name
    }
    
    static func == (lhs: QuestGraphActionEdgeSG, rhs: QuestGraphActionEdgeSG) -> Bool {
        return lhs.name == rhs.name
    }
}


