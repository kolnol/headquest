//
//  QuestDialogueNode.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 14.08.22.
//

import Foundation

public class QuestDialogueNode: QuestGraphNodeSG
{
	var npc: String

	private enum CodingKeys: String, CodingKey
	{
		case npc
	}

	init(name: String, description: String, isEnd: Bool = false, backgroundMusicFile: String? = nil, preVoiceSound: String? = nil, postVoiceSound: String? = nil, isSkipable: Bool = true, npc: String)
	{
		self.npc = npc
		super.init(name: name, description: description, isEnd: isEnd, backgroundMusicFile: backgroundMusicFile, preVoiceSound: preVoiceSound, postVoiceSound: postVoiceSound, isSkipable: isSkipable)
	}

	required init(from decoder: Decoder) throws
	{
		npc = try decoder.container(keyedBy: QuestDialogueNode.CodingKeys.self)
			.decode(String.self, forKey: .npc)
		try super.init(from: decoder)
	}
}
