//
//  Action.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 10.05.22.
//

import Foundation

enum MediaActions: Int, Decodable
{
	case PreviousTrack = 0
	case Play = 1
	case NextTrack = 2

	var description: String
	{
		switch self
		{
		case .Play: return "PlayMediaActions"
		case .PreviousTrack: return "PreviousTrackMediaActions"
		case .NextTrack: return "NextTrackMediaActions"
		}
	}
}
