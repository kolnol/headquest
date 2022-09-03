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
    var action: MediaActions
    
    private enum CodingKeys: String, CodingKey
    {
        case name
        case action
    }
    
    init(name: String, action: MediaActions)
	{
		self.name = name
        self.action = action
	}

	public static func == (lhs: QuestGraphActionEdgeSG, rhs: QuestGraphActionEdgeSG) -> Bool
	{
		return lhs.name == rhs.name &&
        lhs.action.rawValue == rhs.action.rawValue
	}

	public func hash(into hasher: inout Hasher)
	{
		hasher.combine(name)
        hasher.combine(action)
	}
    
    public required init(from decoder: Decoder) throws
    {
        name = try decoder.container(keyedBy: QuestGraphActionEdgeSG.CodingKeys.self)
            .decode(String.self, forKey: .name)
        action = try decoder.container(keyedBy: QuestGraphActionEdgeSG.CodingKeys.self)
            .decode(MediaActions.self, forKey: .action)
    }
    
    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
           try container.encode(name, forKey: .name)
        try container.encode(action.rawValue, forKey: .action)
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
