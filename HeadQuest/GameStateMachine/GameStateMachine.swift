//
//  GameStateMachine.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 10.05.22.
//

import Foundation

protocol GameStateMachine {
    var currState :State {get}
    func reactToAction(action:MediaAction) -> State
    func reset() -> State
}
