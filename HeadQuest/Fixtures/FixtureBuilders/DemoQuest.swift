//
//  SimpleGraph.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 15.08.22.
//

import Foundation
import SwiftGraph

class DemoQuest: QuestFixtureBase
{
	override func buildNodes() -> [String: QuestGraphNodeSG]
	{
		let startV = QuestGraphNodeSG(
			name: "Start",
			description: "Welcome to the demo of the Head Quest. You are in the dungeon. In front of you, you have three doors: one with skeleton, one with fire and one with key on it. Which one do you choose?. " + DemoQuest.createButtonsSuggestion(onPrevAction: "skeleton door", onPlayAction: "Fire Door", onNextAction: "Key Door"),
            isStart: true,
			backgroundMusicFile: "dungeon_backgraound.mp3",
			preVoiceSound: "dungeon_door_open.wav"
		)

		let skeletonFightV = QuestGraphNodeSG(
			name: "Skeleton Fight",
			description: "You open the door. In the middle of the room you see a huge golden throne on which sits a skeleton. He looks huge. You can attack, come back or try to sneak. What do you choose? " + DemoQuest.createButtonsSuggestion(onPrevAction: "attack", onPlayAction: "come back", onNextAction: "sneak")
		)

		let fireDoorV = QuestGraphNodeSG(
			name: "Fire Door",
			description: "You open the door and see an old man who is constantly talking something about his honor. You can attack, come back, talk to him, or try to ignore him and go through the room. " + DemoQuest.createButtonsSuggestion(onPrevAction: "attack", onPlayAction: "talk", onNextAction: "come back")
		)

		let keyDoorV = QuestGraphNodeSG(
			name: "Key door Easy win",
			description: "You found the exit congrats.",
			isEnd: true
		)

		let sneakingV = QuestGraphNodeSG(
			name: "Win by sneaking",
			description: "You pass the skeleton and exit the dungeon. Sneaky bastard wins. ",
			isEnd: true
		)

		let attackV = QuestGraphNodeSG(name: "Attack Skeleton", description: "The fighting mechanic is not implemented yet so... Oponent sees your attack and burns you alive. GG. ", isEnd: true)
		let teaV = QuestGraphNodeSG(name: "Win by tea", description: "The old man tells you a story about his past by pooring a cup of tea. You have a great conversation. After that old man shows you the way to the exit. Win. ", isEnd: true)
		let comeBackV = QuestGraphNodeSG(name: "Come Back", description: "You decide to come back in the previous room. ", isSkipable: true)

		var internalNodes = [String: QuestGraphNodeSG]()
		internalNodes.updateValue(startV, forKey: "startV")
		internalNodes.updateValue(skeletonFightV, forKey: "skeletonFightV")
		internalNodes.updateValue(fireDoorV, forKey: "fireDoorV")
		internalNodes.updateValue(keyDoorV, forKey: "keyDoorV")
		internalNodes.updateValue(sneakingV, forKey: "sneakingV")
		internalNodes.updateValue(attackV, forKey: "attackV")
		internalNodes.updateValue(teaV, forKey: "teaV")
		internalNodes.updateValue(comeBackV, forKey: "comeBackV")

		return internalNodes
	}

	override func buildEdges() -> [GraphEdge]
	{
		var edges = [GraphEdge]()

		edges.append(GraphEdge(from: "startV", to: "skeletonFightV", weight: QuestGraphActionEdgeSG(name: "Skeleton Door")))

		edges.append(GraphEdge(from: "startV", to: "fireDoorV", weight: QuestGraphActionEdgeSG(name: "open_fire_door")))
		edges.append(GraphEdge(from: "startV", to: "keyDoorV", weight: QuestGraphActionEdgeSG(name: "open_key_door")))

		edges.append(GraphEdge(from: "skeletonFightV", to: "sneakingV", weight: QuestGraphActionEdgeSG(name: "sneak")))
		edges.append(GraphEdge(from: "skeletonFightV", to: "comeBackV", weight: QuestGraphActionEdgeSG(name: "come_back")))
		edges.append(GraphEdge(from: "skeletonFightV", to: "attackV", weight: QuestGraphActionEdgeSG(name: "attack")))

		edges.append(GraphEdge(from: "fireDoorV", to: "attackV", weight: QuestGraphActionEdgeSG(name: "attack")))

		edges.append(GraphEdge(from: "fireDoorV", to: "comeBackV", weight: QuestGraphActionEdgeSG(name: "come_back")))

		edges.append(GraphEdge(from: "comeBackV", to: "startV", weight: QuestGraphActionEdgeSG(name: "come_back")))

		return edges
	}
}
