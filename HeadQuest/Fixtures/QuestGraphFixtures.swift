//
//  QuestGraphFixtures.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 10.05.22.
//

import Foundation

struct QuestGraphFixtures{
    static func SimpleQuest() -> QuestGraphSG {
        let startV = QuestGraphNodeSG(name: "Start", description: "Welcome to the demo of the app. You are in the dungeon. In front of you, you have three doors: one with skeleton, one with fire and one with key on it. Which one do you choose?")
        let skeletonFightV = QuestGraphNodeSG(name: "Skeleton Fight", description: "You open the door. In the middle of the room you see a huge golden throne on which sits a skeleton. He looks huge. You can attack, come back or try to sneak. What do you choose?")
        let fireDoorV = QuestGraphNodeSG(name: "Fire Door", description: "You open the door and see an old man who is constantly mutters something about his honor. You can attack, come back, talk to him, or try to ignore him and go through the room.")
        let keyDoorV = QuestGraphNodeSG(name: "Key door/Easy win", description: "You found the exit congrats.", isEnd: true)
        let sneakingV = QuestGraphNodeSG(name: "Win by sneaking", description: "You pass the skeleton and exit the dungeon. Sneaky bastard wins.", isEnd: true)
        let attackV = QuestGraphNodeSG(name: "Attack Skeleton", description: "The fighting mechanic is not implemented yet so... Oponent sees your attack and burns you alive. GG.", isEnd: true)
        let teaV = QuestGraphNodeSG(name: "Win by tea", description: "The old man tells you a story about his past by pooring a cup of tea. You have a great conversation. After that old man shows you the way to the exit. Win.", isEnd: true)
        let ignoreV = QuestGraphNodeSG(name: "Win by ignore", description: "You pass the old man and exit the dungeon. Win.", isEnd: true)
        let comeBackV = QuestGraphNodeSG(name: "Come Back", description: "You decide to come back in the previous room")
        
        let questGraph = QuestGraphSG(vertices: [startV, skeletonFightV, fireDoorV, keyDoorV, sneakingV, attackV, teaV, ignoreV, comeBackV])
        
        questGraph.addEdge(from: startV, to: skeletonFightV, weight: QuestGraphActionEdgeSG(name: "Skeleton Door"), directed: true)
        
        questGraph.addEdge(from: startV, to: fireDoorV, weight: QuestGraphActionEdgeSG(name: "open_fire_door"), directed: true)
        questGraph.addEdge(from: startV, to: keyDoorV, weight: QuestGraphActionEdgeSG(name: "open_key_door"), directed: true)
        
        questGraph.addEdge(from: skeletonFightV, to: sneakingV, weight: QuestGraphActionEdgeSG(name: "sneak"), directed: true)
        questGraph.addEdge(from: skeletonFightV, to: comeBackV, weight: QuestGraphActionEdgeSG(name: "come_back"), directed: true)
        questGraph.addEdge(from: skeletonFightV, to: attackV, weight: QuestGraphActionEdgeSG(name: "attack"), directed: true)
        
        questGraph.addEdge(from: fireDoorV, to: attackV, weight: QuestGraphActionEdgeSG(name: "attack"), directed: true)
        questGraph.addEdge(from: fireDoorV, to: teaV, weight: QuestGraphActionEdgeSG(name: "talk"), directed: true)
        questGraph.addEdge(from: fireDoorV, to: ignoreV, weight: QuestGraphActionEdgeSG(name: "ignore"), directed: true)
        questGraph.addEdge(from: fireDoorV, to: comeBackV, weight: QuestGraphActionEdgeSG(name: "come_back"), directed: true)
        
        return questGraph
    }
}
