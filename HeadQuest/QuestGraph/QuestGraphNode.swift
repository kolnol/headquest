//
//  QuestGraphNode.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 16.05.22.
//

import Foundation

protocol QuestGraphNode
{
	var name: String { get }
	var description: String { get }
	var isEnd: Bool { get }
}
