//
//  FireDoorDialogue.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 21.08.22.
//

import Foundation
import SwiftUI

class FireDoorDialogue: QuestFixtureBase
{
	override func buildNodes() -> [String: QuestGraphNodeSG]
	{
		let hasTalkedToOldManConditionalNode = ConditionalNode(name: "HasTalkedToOldMan", gameStatePropertyToCheck: GameStateConstants.hasTalkedToOldMan, expectedValue: true.description)

		let oldManOfferingHelp = QuestDialogueNode(
			name: "oldManOfferingHelp",
			description: "You look lost, maybe I can help you?",
			isEnd: false,
			backgroundMusicFile: "old_man_campfire_background",
			npc: "Old Man"
		)

		let oldManWelcomesBack = QuestDialogueNode(
			name: "oldManWelcomesBack",
			description: "Oh, you are back. Nice to see you again. How can I help you?",
			isEnd: false,
			backgroundMusicFile: "old_man_campfire_background",
			npc: "Old Man"
		)

		let decidingAboutHelp = QuestGraphNodeSG(
            name: "decidingAboutHelp",
            description: "By coming closer you can see that a man has a long beard and not so friendly face. Press previous button for accepting the help. Press play button to discard the help and come back.",
            backgroundMusicFile: "old_man_campfire_background")

		let fireDoorComingBack = QuestGraphNodeSG(
			name: "fireDoorComingBack",
			description: "You come back and see an old man who is constantly mutters something about his honor. You can attack, come back, talk to him, or try to ignore him and go through the room."
		)

        let acceptingHelp = QuestGraphNodeSG(
            name: "fireDoorComingBack",
            description: "You accept the help from the old man. His face became more calm and friendly.",
            isSkipable: true
        )
        
        let oldManOffersTea = QuestGraphNodeSG(
            name: "oldManOffersTea",
            description: "An old man lays back to fire. Pours a cup of tea and gives it to you.",
            isSkipable: true
        )
        
        let oldManOffersTeaDialogue = QuestDialogueNode(
            name: "oldManOffersTeaDialogue",
            description: "Here is some tea. I hope you like it.",
            isEnd: false,
            backgroundMusicFile: "old_man_campfire_background",
            // TODO get sound preVoiceSound: "puring_tea",
            isSkipable: true,
            npc: "OldMan"
        )
        
        let decideIfToDrinkTea = QuestGraphNodeSG(
            name: "decideIfToDrinkTea",
            description:
                FireDoorDialogue.createButtonsSuggestion(
                    onPrevAction: "to take the cup and drink.",
                    onPlayAction: "Decline",
                    onNextAction: "say goodbye and comeback"),
            isEnd: false,
            backgroundMusicFile: "old_man_campfire_background"
        )
        
        let drinkingTea = QuestGraphNodeSG(
            name: "drinkingTea",
            description:"You take the cup and slurp a bit. The tea is so terrible that you take one HP of damage." +
                FireDoorDialogue.createButtonsSuggestion(
                    onPrevAction: "tell that tea is bad",
                    onPlayAction: "ignore the taste",
                    onNextAction: "compliment the tea"),
            isEnd: false,
            backgroundMusicFile: "old_man_campfire_background"
            //TODO preVoiceSound: "drinking_tea"
        )
        
        let decliningTea = QuestGraphNodeSG(
            name: "decliningTea",
            description:"You politely decline the tea. The old man puts cup down. The old man looks disappointed. He will remember this.",
            backgroundMusicFile: "old_man_campfire_background",
            isSkipable: true
            //TODO postVoiceSound: "remembering_sound_from_walking_dead"
        )
        
        let notOnlyForTeaHere = QuestDialogueNode(
            name: "notOnlyForTeaHere",
            description: "You are here not only for tea right? How can I help you?",
            isEnd: false,
            backgroundMusicFile: "old_man_campfire_background",
            // TODO get sound preVoiceSound: "puring_tea",
            isSkipable: true,
            npc: "OldMan"
        )

        let tellingTeaIsBad = QuestGraphNodeSG(
            name: "tellingTeaIsBad",
            description: "You tell that the tea or whatever it is almost killed you. This is not drinkable! The old man jumps up explosively and is ready to attack but in the instance remembered something and calmed down.",
            isEnd: false,
            backgroundMusicFile: "old_man_campfire_background",
            // TODO get sound preVoiceSound: "puring_tea",
            isSkipable: true
        )
        
        let ignoringTea = QuestGraphNodeSG(
            name: "ignoringTea",
            description: "You are not showing that the tea almost killed you and hiddenly pours it to the ground. The man does not seem to notice that.",
            backgroundMusicFile: "old_man_campfire_background",
            isSkipable: true
        )
        
        let complimetingTea = QuestGraphNodeSG(
            name: "complimetingTea",
            description: "You compliment the tea. The face of the old man looks surprised.",
            backgroundMusicFile: "old_man_campfire_background",
            isSkipable: true
        )
        
        let oldManTellsAboutUncle = QuestDialogueNode(
            name: "oldManTellsAboutUncle",
            description: "Oh really? I learned it from my uncle. At some point he had the best tea shop in the city.",
            isEnd: false,
            backgroundMusicFile: "old_man_campfire_background",
            // TODO get sound preVoiceSound: "puring_tea",
            isSkipable: true,
            npc: "OldMan"
        )
        
        let askingForInformation = NodeWhichUpdatesState(
            name: "askingForInformation",
            description: "Ask Who is the old man?" + FireDoorDialogue.createButtonsSuggestion(onPrevAction: "Check previous question", onPlayAction: "Ask current question", onNextAction: "Check next questions"),
            backgroundMusicFile: "old_man_campfire_background",
            isSkipable: false,
            gameStatePropertyToUpdate: GameStateConstants.hasTalkedToOldMan,
            updatedValue: "true"
        )
    
        let askingForInformation2 = QuestGraphNodeSG(
            name: "askingForInformation2",
            description: "Ask Where are we?" + FireDoorDialogue.createButtonsSuggestion(onPrevAction: "Check previous question", onPlayAction: "Ask current question", onNextAction: "Check next questions"),
            backgroundMusicFile: "old_man_campfire_background",
            isSkipable: false
        )
        
        let askingForInformation3 = QuestGraphNodeSG(
            name: "askingForInformation3",
            description: "Ask Where is the exit?" + FireDoorDialogue.createButtonsSuggestion(onPrevAction: "Check previous question", onPlayAction: "Ask current question", onNextAction: "Check next questions"),
            backgroundMusicFile: "old_man_campfire_background",
            isSkipable: false
        )
        
        let askingForInformation4 = QuestGraphNodeSG(
            name: "askingForInformation4",
            description: "Ask for a cup of tea" + FireDoorDialogue.createButtonsSuggestion(onPrevAction: "Check previous question", onPlayAction: "Ask current question", onNextAction: "Check next questions"),
            backgroundMusicFile: "old_man_campfire_background",
            isSkipable: false
        )
        
        let askingForInformation5 = QuestGraphNodeSG(
            name: "askingForInformation5",
            description: "Tell I have to go and come back" + FireDoorDialogue.createButtonsSuggestion(onPrevAction: "Check previous question", onPlayAction: "Ask current question", onNextAction: "Check next questions"),
            backgroundMusicFile: "old_man_campfire_background",
            isSkipable: false
        )
        
        
        let oldManIntroducesHimself = QuestDialogueNode(
            name: "oldManIntroducesHimself",
            description: "Oh I am really sorry, where are my manners. My name is Lee. I was put here by the deloper to show dialogue mechanic of the game. Looks like it works.",
            isEnd: false,
            backgroundMusicFile: "old_man_campfire_background",
            isSkipable: true,
            npc: "OldMan")
        
        let oldManTellsWhereYouAre = QuestDialogueNode(
            name: "oldManIntroducesHimself",
            description: "In the dungeon, wehre else. Didn't you listened to the introduction?",
            isEnd: false,
            backgroundMusicFile: "old_man_campfire_background",
            isSkipable: true,
            npc: "OldMan")
        
        let oldManTellsYouAboutExit = QuestDialogueNode(
            name: "oldManTellsYouAboutExit",
            description: "Right there I can guide you there if you want.",
            isEnd: false,
            backgroundMusicFile: "old_man_campfire_background",
            isSkipable: true,
            npc: "OldMan")
        
        
        let exitTheDungeonQuestion = QuestGraphNodeSG(
            name: "exitTheDungeonQuestion",
            description: "Follow the old man?" + FireDoorDialogue.createButtonsSuggestion(onPrevAction: "follow", onPlayAction: "not follow"),
            backgroundMusicFile: "old_man_campfire_background",
            isSkipable: false
        )
        
        let thankingAndComingBack = QuestGraphNodeSG(
            name: "thankingAndComingBack",
            description: "You thank the old man for help, standing up.",
            backgroundMusicFile: "old_man_campfire_background",
            isSkipable: false
        )

        let itIsAPleasureOldMan = QuestDialogueNode(
            name: "itIsAPleasureOldMan",
            description: "My pleasure. Sharing a cup of tea with a fascinating stranger is one of the biggest life's delights.",
            isEnd: false,
            backgroundMusicFile: "old_man_campfire_background",
            isSkipable: true,
            npc: "OldMan")
        
		var internalNodes = [String: QuestGraphNodeSG]()

		internalNodes.updateValue(oldManOfferingHelp, forKey: "oldManOfferingHelp")
		internalNodes.updateValue(hasTalkedToOldManConditionalNode, forKey: "hasTalkedToOldManConditionalNode")
		internalNodes.updateValue(decidingAboutHelp, forKey: "decidingAboutHelp")
		internalNodes.updateValue(oldManWelcomesBack, forKey: "oldManWelcomesBack")
		internalNodes.updateValue(fireDoorComingBack, forKey: "fireDoorComingBack")
        internalNodes.updateValue(acceptingHelp, forKey: "acceptingHelp")
        internalNodes.updateValue(oldManOffersTea, forKey: "oldManOffersTea")
        internalNodes.updateValue(oldManOffersTeaDialogue, forKey: "oldManOffersTeaDialogue")
        internalNodes.updateValue(decideIfToDrinkTea, forKey: "decideIfToDrinkTea")
        internalNodes.updateValue(drinkingTea, forKey: "drinkingTea")
        internalNodes.updateValue(decliningTea, forKey: "decliningTea")
        internalNodes.updateValue(notOnlyForTeaHere, forKey: "notOnlyForTeaHere")
        internalNodes.updateValue(tellingTeaIsBad, forKey: "tellingTeaIsBad")
        internalNodes.updateValue(ignoringTea, forKey: "ignoringTea")
        internalNodes.updateValue(complimetingTea, forKey: "complimetingTea")
        internalNodes.updateValue(oldManTellsAboutUncle, forKey: "oldManTellsAboutUncle")
        
        internalNodes.updateValue(askingForInformation, forKey: "askingForInformation1")
        internalNodes.updateValue(askingForInformation2, forKey: "askingForInformation2")
        internalNodes.updateValue(askingForInformation3, forKey: "askingForInformation3")
        internalNodes.updateValue(askingForInformation4, forKey: "askingForInformation4")
        internalNodes.updateValue(askingForInformation5, forKey: "askingForInformation5")

        internalNodes.updateValue(oldManIntroducesHimself, forKey: "oldManIntroducesHimself")
        internalNodes.updateValue(oldManTellsWhereYouAre, forKey: "oldManTellsWhereYouAre")

        internalNodes.updateValue(oldManTellsYouAboutExit, forKey: "oldManTellsYouAboutExit")
        internalNodes.updateValue(exitTheDungeonQuestion, forKey: "exitTheDungeonQuestion")
        internalNodes.updateValue(thankingAndComingBack, forKey: "thankingAndComingBack")

        internalNodes.updateValue(itIsAPleasureOldMan, forKey: "itIsAPleasureOldMan")

		return internalNodes
	}

	override func buildEdges() -> [GraphEdge]
	{
		var edges = [GraphEdge]()
        edges.append(GraphEdge(from: "fireDoorV", to: "hasTalkedToOldManConditionalNode", weight: QuestGraphActionEdgeSG(name: "talk", action: MediaActions.Play)))

		edges.append(GraphEdge(from: "hasTalkedToOldManConditionalNode", to: "oldManOfferingHelp", weight: QuestGraphConditionalEdgeFactory.createConditionalNode(edgeType: ConditionalEdgeTypes.notFullfilledConditionEdge)))
		edges.append(GraphEdge(from: "hasTalkedToOldManConditionalNode", to: "oldManWelcomesBack", weight: QuestGraphConditionalEdgeFactory.createConditionalNode(edgeType: ConditionalEdgeTypes.fullfilledConditionEdge)))
        
        edges.append(GraphEdge(from: "oldManWelcomesBack", to: "askingForInformation1", weight: QuestGraphActionEdgeSG(name: "askingQuestionsAftercomingBack", action: MediaActions.Play)))
        
        edges.append(GraphEdge(from: "oldManOfferingHelp", to: "decidingAboutHelp", weight: QuestGraphActionEdgeSG(name: "decidingAboutHelp", action: MediaActions.Play)))

        edges.append(GraphEdge(from: "decidingAboutHelp", to: "fireDoorComingBack", weight: QuestGraphActionEdgeSG(name: "comeBack", action: MediaActions.Play)))
        edges.append(GraphEdge(from: "decidingAboutHelp", to: "acceptingHelp", weight: QuestGraphActionEdgeSG(name: "acceptHelp", action: MediaActions.PreviousTrack)))

        edges.append(GraphEdge(from: "fireDoorComingBack", to: "attackV", weight: QuestGraphActionEdgeSG(name: "attack", action: MediaActions.PreviousTrack)))
        edges.append(GraphEdge(from: "fireDoorComingBack", to: "comeBackV", weight: QuestGraphActionEdgeSG(name: "come_back", action: MediaActions.NextTrack)))
        edges.append(GraphEdge(from: "fireDoorComingBack", to: "hasTalkedToOldManConditionalNode", weight: QuestGraphActionEdgeSG(name: "talk", action: MediaActions.Play)))
        
        edges.append(GraphEdge(from: "acceptingHelp", to: "oldManOffersTea", weight: QuestGraphActionEdgeSG(name: "acceptHelp", action: MediaActions.Play)))
        
        edges.append(GraphEdge(from: "oldManOffersTea", to: "oldManOffersTeaDialogue", weight: QuestGraphActionEdgeSG(name: "oldManAskedIfYouWantTea", action: MediaActions.Play)))
        edges.append(GraphEdge(from: "oldManOffersTeaDialogue", to: "decideIfToDrinkTea", weight: QuestGraphActionEdgeSG(name: "decideIfToDrinkTea", action: MediaActions.Play)))
        
        edges.append(GraphEdge(from: "decideIfToDrinkTea", to: "drinkingTea", weight: QuestGraphActionEdgeSG(name: "acceptingTea", action: MediaActions.PreviousTrack)))
        edges.append(GraphEdge(from: "decideIfToDrinkTea", to: "decliningTea", weight: QuestGraphActionEdgeSG(name: "declineTea", action: MediaActions.Play)))
        edges.append(GraphEdge(from: "decideIfToDrinkTea", to: "fireDoorComingBack", weight: QuestGraphActionEdgeSG(name: "comeBack", action: MediaActions.NextTrack)))
        
        edges.append(GraphEdge(from: "decliningTea", to: "notOnlyForTeaHere", weight: QuestGraphActionEdgeSG(name: "oldManReacts", action: MediaActions.Play)))

        edges.append(GraphEdge(from: "drinkingTea", to: "tellingTeaIsBad", weight: QuestGraphActionEdgeSG(name: "tellingTeaIsBad", action: MediaActions.PreviousTrack)))
        edges.append(GraphEdge(from: "drinkingTea", to: "ignoringTea", weight: QuestGraphActionEdgeSG(name: "ignoreTea", action: MediaActions.Play)))
        edges.append(GraphEdge(from: "drinkingTea", to: "complimetingTea", weight: QuestGraphActionEdgeSG(name: "complementTea", action: MediaActions.NextTrack)))

        
        edges.append(GraphEdge(from: "tellingTeaIsBad", to: "notOnlyForTeaHere", weight: QuestGraphActionEdgeSG(name: "tellingTeaIsbadToNotonlyForTeaHere", action: MediaActions.Play)))
        edges.append(GraphEdge(from: "ignoringTea", to: "notOnlyForTeaHere", weight: QuestGraphActionEdgeSG(name: "complementTeaToNotOnlyForTeaHere", action: MediaActions.Play)))
        edges.append(GraphEdge(from: "complimetingTea", to: "oldManTellsAboutUncle", weight: QuestGraphActionEdgeSG(name: "complimetingTeaTooldManTellsAboutUncle", action: MediaActions.Play)))
        edges.append(GraphEdge(from: "oldManTellsAboutUncle", to: "notOnlyForTeaHere", weight: QuestGraphActionEdgeSG(name: "complimetingTeaTooldManTellsAboutUncle", action: MediaActions.Play)))

        edges.append(GraphEdge(from: "notOnlyForTeaHere", to: "askingForInformation1", weight: QuestGraphActionEdgeSG(name: "askForInformation", action: MediaActions.Play)))
        
        // TODO the problem here will be that i expect all edges to be in the right order prev, play, next
        // TODO how to fix it?
        // Carousel of dialogues
        edges.append(GraphEdge(from: "askingForInformation1", to: "askingForInformation2", weight: QuestGraphActionEdgeSG(name: "next", action: MediaActions.NextTrack)))
        edges.append(GraphEdge(from: "askingForInformation2", to: "askingForInformation3", weight: QuestGraphActionEdgeSG(name: "next", action: MediaActions.NextTrack)))
        edges.append(GraphEdge(from: "askingForInformation3", to: "askingForInformation4", weight: QuestGraphActionEdgeSG(name: "next", action: MediaActions.NextTrack)))
        edges.append(GraphEdge(from: "askingForInformation4", to: "askingForInformation5", weight: QuestGraphActionEdgeSG(name: "next", action: MediaActions.NextTrack)))
        edges.append(GraphEdge(from: "askingForInformation5", to: "askingForInformation1", weight: QuestGraphActionEdgeSG(name: "next", action: MediaActions.NextTrack)))

        edges.append(GraphEdge(from: "askingForInformation5", to: "askingForInformation4", weight: QuestGraphActionEdgeSG(name: "prev", action: MediaActions.PreviousTrack)))
        edges.append(GraphEdge(from: "askingForInformation4", to: "askingForInformation3", weight: QuestGraphActionEdgeSG(name: "prev", action: MediaActions.PreviousTrack)))
        edges.append(GraphEdge(from: "askingForInformation3", to: "askingForInformation2", weight: QuestGraphActionEdgeSG(name: "prev", action: MediaActions.PreviousTrack)))
        edges.append(GraphEdge(from: "askingForInformation2", to: "askingForInformation1", weight: QuestGraphActionEdgeSG(name: "prev", action: MediaActions.PreviousTrack)))
        edges.append(GraphEdge(from: "askingForInformation1", to: "askingForInformation5", weight: QuestGraphActionEdgeSG(name: "prev", action: MediaActions.PreviousTrack)))

        
        edges.append(GraphEdge(from: "askingForInformation1", to: "oldManIntroducesHimself", weight: QuestGraphActionEdgeSG(name: "play", action: MediaActions.Play)))
        edges.append(GraphEdge(from: "oldManIntroducesHimself", to: "askingForInformation1", weight: QuestGraphActionEdgeSG(name: "answered", action: MediaActions.Play)))

        edges.append(GraphEdge(from: "askingForInformation2", to: "oldManTellsWhereYouAre", weight: QuestGraphActionEdgeSG(name: "play", action: MediaActions.Play)))
        edges.append(GraphEdge(from: "oldManTellsWhereYouAre", to: "askingForInformation2", weight: QuestGraphActionEdgeSG(name: "answered", action: MediaActions.Play)))

        edges.append(GraphEdge(from: "askingForInformation3", to: "oldManTellsYouAboutExit", weight: QuestGraphActionEdgeSG(name: "play", action: MediaActions.Play)))
        edges.append(GraphEdge(from: "oldManTellsYouAboutExit", to: "exitTheDungeonQuestion", weight: QuestGraphActionEdgeSG(name: "answered", action: MediaActions.Play)))
        edges.append(GraphEdge(from: "exitTheDungeonQuestion", to: "teaV", weight: QuestGraphActionEdgeSG(name: "follow", action: MediaActions.PreviousTrack)))
        edges.append(GraphEdge(from: "exitTheDungeonQuestion", to: "askingForInformation3", weight: QuestGraphActionEdgeSG(name: "notFollow", action: MediaActions.Play)))
        
        edges.append(GraphEdge(from: "askingForInformation4", to: "decideIfToDrinkTea", weight: QuestGraphActionEdgeSG(name: "play", action: MediaActions.Play)))
        
        edges.append(GraphEdge(from: "askingForInformation5", to: "thankingAndComingBack", weight: QuestGraphActionEdgeSG(name: "comeBack", action: MediaActions.NextTrack)))
        edges.append(GraphEdge(from: "thankingAndComingBack", to: "itIsAPleasureOldMan", weight: QuestGraphActionEdgeSG(name: "saidThanksAndComingBack", action: MediaActions.Play)))
        edges.append(GraphEdge(from: "itIsAPleasureOldMan", to: "fireDoorComingBack", weight: QuestGraphActionEdgeSG(name: "comeBack", action: MediaActions.Play)))
        
        return edges
	}
}
