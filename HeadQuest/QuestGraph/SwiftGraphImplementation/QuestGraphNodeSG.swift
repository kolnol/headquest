//
//  QuestGraphNodeSwiftGraph.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 16.05.22.
//

import Foundation

class QuestGraphNodeSG:QuestGraphNode, Decodable, Encodable, Equatable{
    init(name: String, description: String, isEnd: Bool = false, backgroundMusicFile: String? = nil, preVoiceSound: String? = nil, postVoiceSound: String? = nil) {
        self.name = name
        self.description = description
        self.isEnd = isEnd
        self.backgroundMusicFile = backgroundMusicFile
        self.preVoiceSound = preVoiceSound
        self.postVoiceSound = postVoiceSound
    }
    
    var name: String
    
    var description: String
    
    var isEnd: Bool
    
    // Audio
    var backgroundMusicFile: String?
    var preVoiceSound: String?
    var postVoiceSound: String?
    
    init(name:String, description:String, isEnd:Bool = false) {
        self.name = name
        self.description = description
        self.isEnd = isEnd
    }
    
    static func == (lhs: QuestGraphNodeSG, rhs: QuestGraphNodeSG) -> Bool {
        return lhs.description == rhs.description && lhs.name == rhs.name
    }
}
