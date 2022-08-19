//
//  QuestFixture.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 15.08.22.
//

import Foundation

class QuestFixtureBase{
    private static func createButtonsSuggestion(onPrevAction: String, onPlayAction: String, onNextAction: String) -> String {
        "Press previous button for \(onPrevAction). Press play button for \(onPlayAction). Press next button for \(onNextAction)."
    }

    private static func getLongText() -> String {
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. "
    }
}
