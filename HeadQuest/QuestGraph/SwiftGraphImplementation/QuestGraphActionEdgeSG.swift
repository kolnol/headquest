//
//  QuestGraphActionEdge.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 16.05.22.
//

import Foundation
import SwiftGraph

public class QuestGraphActionEdgeSG: QuestGraphActionEdge, Decodable, Encodable, Equatable, Hashable
{
	var name: String

	init(name: String)
	{
		self.name = name
	}

	public static func == (lhs: QuestGraphActionEdgeSG, rhs: QuestGraphActionEdgeSG) -> Bool
	{
		lhs.name == rhs.name
	}

	public func hash(into hasher: inout Hasher)
	{
		hasher.combine(name)
	}
}

extension WeightedEdge: Hashable where W == QuestGraphActionEdgeSG
{
	public func hash(into hasher: inout Hasher)
	{
		hasher.combine(u)
		hasher.combine(v)
		hasher.combine(weight)
	}
}
