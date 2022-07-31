//
//  QuestGraphFixtures.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 10.05.22.
//

import Foundation

struct QuestGraphFixtures{
    static func SimpleQuest() -> QuestGraphSG {
        let startV = QuestGraphNodeSG(
                                    name: "Start",
                                    description: "Welcome to the demo of the Head Quest. You are in the dungeon. In front of you, you have three doors: one with skeleton, one with fire and one with key on it. Which one do you choose?." + createButtonsSuggestion(onPrevAction: "skeleton door", onPlayAction: "Fire Door", onNextAction: "Key Door"),
                                    backgroundMusicFile: "dungeon_backgraound.mp3", preVoiceSound: "dungeon_door_open.wav")
        
        let skeletonFightV = QuestGraphNodeSG(
                                            name: "Skeleton Fight",
                                            description: "You open the door. In the middle of the room you see a huge golden throne on which sits a skeleton. He looks huge. You can attack, come back or try to sneak. What do you choose?" + createButtonsSuggestion(onPrevAction: "attack", onPlayAction: "come back", onNextAction: "sneak"))
        
        let fireDoorV = QuestGraphNodeSG(name: "Fire Door", description: "You open the door and see an old man who is constantly talking something about his honor. You can attack, come back, talk to him, or try to ignore him and go through the room." + createButtonsSuggestion(onPrevAction: "attack", onPlayAction: "talk", onNextAction: "come back"))
        let keyDoorV = QuestGraphNodeSG(name: "Key door/Easy win", description: "You found the exit congrats.", isEnd: true)
        let sneakingV = QuestGraphNodeSG(name: "Win by sneaking", description: "You pass the skeleton and exit the dungeon. Sneaky bastard wins.", isEnd: true)
        let attackV = QuestGraphNodeSG(name: "Attack Skeleton", description: "The fighting mechanic is not implemented yet so... Oponent sees your attack and burns you alive. GG.", isEnd: true)
        let teaV = QuestGraphNodeSG(name: "Win by tea", description: "The old man tells you a story about his past by pooring a cup of tea. You have a great conversation. After that old man shows you the way to the exit. Win.", isEnd: true)
        let comeBackV = QuestGraphNodeSG(name: "Come Back", description: "You decide to come back in the previous room", isSkipable: true)
        
        let questGraph = QuestGraphSG(vertices: [startV, skeletonFightV, fireDoorV, keyDoorV, sneakingV, attackV, teaV, comeBackV])
        
        questGraph.addEdge(from: startV, to: skeletonFightV, weight: QuestGraphActionEdgeSG(name: "Skeleton Door"), directed: true)
        questGraph.addEdge(from: startV, to: fireDoorV, weight: QuestGraphActionEdgeSG(name: "open_fire_door"), directed: true)
        questGraph.addEdge(from: startV, to: keyDoorV, weight: QuestGraphActionEdgeSG(name: "open_key_door"), directed: true)
        
        questGraph.addEdge(from: skeletonFightV, to: sneakingV, weight: QuestGraphActionEdgeSG(name: "sneak"), directed: true)
        questGraph.addEdge(from: skeletonFightV, to: comeBackV, weight: QuestGraphActionEdgeSG(name: "come_back"), directed: true)
        questGraph.addEdge(from: skeletonFightV, to: attackV, weight: QuestGraphActionEdgeSG(name: "attack"), directed: true)
        
        questGraph.addEdge(from: fireDoorV, to: attackV, weight: QuestGraphActionEdgeSG(name: "attack"), directed: true)
        questGraph.addEdge(from: fireDoorV, to: teaV, weight: QuestGraphActionEdgeSG(name: "talk"), directed: true)
        questGraph.addEdge(from: fireDoorV, to: comeBackV, weight: QuestGraphActionEdgeSG(name: "come_back"), directed: true)
        
        questGraph.addEdge(from: comeBackV, to: startV, weight: QuestGraphActionEdgeSG(name: "come_back"), directed: true)
        return questGraph
    }
    
    private static func createButtonsSuggestion(onPrevAction: String, onPlayAction:String, onNextAction:String) -> String{
        return "Press previous button for \(onPrevAction). Press play button for \(onPlayAction). Press next button for \(onNextAction)."
    }
}
