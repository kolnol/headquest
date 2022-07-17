//
//  GameStateMachine.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 10.05.22.
//

import Foundation

protocol GameStateMachine {
    var currState :GameState {get}
    func reactToAction(action:MediaAction) -> GameState
    func reset() -> GameState
}
