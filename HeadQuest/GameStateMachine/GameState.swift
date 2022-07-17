//
//  State.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 10.05.22.
//

import Foundation

protocol GameState {
    var questText: String {get}
    func invoke() -> Void
}
