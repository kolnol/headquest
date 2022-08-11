import AVFoundation
import Combine
import Foundation
import UIKit

var s = SpeechSynthesizerAsyncPlayGround()

var t = Task {
    var p = await s.speak("Testknfdhoansd asdhfopiu asjdhpi poashdfp oashd")
}

sleep(3)
print("Stopping task")
t.cancel()

// testing swift concurency
// We need something like
// print("OnPlay clicked")
// print("OnPlay done")
// print("Done playing")
//
// class Player {
//    func playAudioAsync(node: QuestGraphNodeSG) async throws {
//        print("Start playing \(node.name)")
//        if Task.isCancelled {
//            print("Playing task was cancelled")
//            return
//        }
//
//        await startBackground(node: node)
////        await playPreVoiceSound()
////        await synthesize(node.description)
////        await playPostVoiceSound()
//        do {
//            try await Task.sleep(nanoseconds: 5_000_000_000)
//        } catch is CancellationError {
//            print("cancellation duirng playiong (sleeping) \(node.name)")
//        }
//
//        print("Done playing \(node.name)")
//    }
//
//    func startBackground(node: QuestGraphNodeSG) async {
//        print("Playing background music of \(node.name)")
//        do {
//            try await Task.sleep(nanoseconds: 5_000_000_000)
//        } catch is CancellationError {
//            print("cancellation duirng playiong BACKGROUND (sleeping) \(node.name)")
//        } catch {
//            print("Some other error")
//        }
//    }
// }
//
// class GameTest {
//    var player: Player
//    var currentNode: QuestGraphNodeSG?
//    var playerTask: Task<Void, Never>?
//
//    init() {
//        player = Player()
//    }
//
//    func OnPlayPress() async {
//        print("OnPlay clicked")
//        updateCurrentNode()
//        if playerTask != nil {
//            print("canceling in game")
//            playerTask!.cancel()
//        }
//
//        playerTask = Task.init {
//            try! await self.player.playAudioAsync(node: self.currentNode!)
//        }
//
//        print("OnPlay done")
//    }
//
//    func updateCurrentNode() {
//        if currentNode == nil {
//            currentNode = QuestGraphNodeSG(name: "First node", description: "lul")
//            return
//        }
//
//        if currentNode!.name == "First node" {
//            currentNode = QuestGraphNodeSG(name: "Second node", description: "lul2")
//        }
//    }
// }
//
// func mediaCallbackPlayPressed(game: GameTest) {
//    print("Media start")
//
//    Task(operation: {
//        await game.OnPlayPress()
//    })
//
//    print("Media done")
// }
//
//// var game = GameTest()
//
//// Task.init {
////    mediaCallbackPlayPressed(game: game)
////
////    try await Task.sleep(nanoseconds: 2_000_000_000)
////    print("canceling by clicking again")
////    mediaCallbackPlayPressed(game: game)
//// }
