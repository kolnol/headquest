//
//  QuestGraphNodeSwiftGraph.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 16.05.22.
//

import Foundation

class QuestGraphNodeSG:QuestGraphNode, Decodable, Encodable, Equatable{
    var name: String
    
    var description: String
    
    var isEnd: Bool
    
    init(name:String, description:String, isEnd:Bool = false) {
        self.name = name
        self.description = description
        self.isEnd = isEnd
    }
    
    static func == (lhs: QuestGraphNodeSG, rhs: QuestGraphNodeSG) -> Bool {
        return lhs.description == rhs.description && lhs.name == rhs.name
    }
}
