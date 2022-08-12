//
//  ContentView.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 09.05.22.
//

import OSLog
import SwiftUI

struct ContentView: View {
    var game: Game
    var gameGraph: QuestGraphSG
    var logger: Logger = .init(subsystem: "com.mykola.headquest.DemoView", category: String(describing: ContentView.self))

    @State private var startButtonEnabled: Bool = true
    @State private var showCachingProgressView: Bool = true
    @State private var progress = 0.0

    init() {
        gameGraph = QuestGraphFixtures.SimpleQuest()
        game = Game(gameGraph: gameGraph)

        startButtonEnabled = true
        showCachingProgressView = true
    }

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Button {
                onStartButton()
            } label: {
                Text("Start")
                    .fontWeight(.bold)
                    .font(.system(.title, design: .rounded))
            }.disabled(startButtonEnabled == false)
                .padding()

            Button {
                resetGame()
            } label: {
                Text("Reset")
                    .fontWeight(.bold)
                    .font(.system(.title, design: .rounded))
            }
            .padding()

            Button {
                OnTestButton()
            } label: {
                Text("Test combackines")
                    .fontWeight(.bold)
                    .font(.system(.title, design: .rounded))
            }
            .padding()

            Button {
                OnTestSkipabilityButton()
            } label: {
                Text("Test skipability")
                    .fontWeight(.bold)
                    .font(.system(.title, design: .rounded))
            }
            .padding()

            ProgressView("Caching audio data... Please give me money for voice actors!")
                .font(.body)
                .hidden(showCachingProgressView == false)

            ProgressView(value: progress)
                .padding([.leading, .trailing], 10)
                .accentColor(Color.green)
                .scaleEffect(x: 1, y: 4, anchor: .center)
                .hidden(showCachingProgressView == false)
        }.task {
            startButtonEnabled = false
            showCachingProgressView = true
            let totalNodesToConvert = Double(gameGraph.vertices.count)
            var converted = 0.0
            await SpeechCacher.cacheGraphSpeechSynthesizedAudio(gameGraph: gameGraph, onEachConverted: {
                converted += 1
                progress = converted / totalNodesToConvert
            })
            showCachingProgressView = false
            startButtonEnabled = true
        }.onAppear(perform: OnAppear)
    }

    private func OnAppear() {
        let mediaButtonsRegistrator = MediaButtonsRegistrator()
        mediaButtonsRegistrator.register(OnPlay: { () in OnMediaButton(mediaAction: MediaActions.Play) },
                                         OnNextTrack: { () in OnMediaButton(mediaAction: MediaActions.NextTrack) },
                                         OnPreviousTrack: { () in OnMediaButton(mediaAction: MediaActions.PreviousTrack) })
    }

    func onStartButton() {
        print("Start button pressed...")

        print("Starting gaeme in UI")
        try! game.startGame()

        print("Started task")
        startButtonEnabled = false
    }

    func OnTestSkipabilityButton() {
        print("Starting gaeme in UI")
        try! game.startGame()
        startButtonEnabled = false
    }

    func OnTestButton() {
        print("Starting gaeme in UI")
        try! game.startGame()

        startButtonEnabled = false
        let i = 5 // for i in 5...20{
        print("Testing \(i) seconds delay")
        sleep(UInt32(i))
        print("Pressing button...")
        OnMediaButton(mediaAction: MediaActions.PreviousTrack)

        sleep(UInt32(i))
        OnMediaButton(mediaAction: MediaActions.Play)

        sleep(UInt32(10))
        print("Pressing button...")
        OnMediaButton(mediaAction: MediaActions.PreviousTrack)
        // }
    }

    private func OnMediaButton(mediaAction: MediaActions) {
        print("On Action \(mediaAction)")
        game.reactToMediaKey(mediaAction: mediaAction)
    }

    private func OnPostReact() {
        if game.isEnd() {
            resetGame()
        }
    }

    private func resetGame() {
        print("Reset Game")
        game.reset()
        startButtonEnabled = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
