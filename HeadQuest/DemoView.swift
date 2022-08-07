//
//  ContentView.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 09.05.22.
//

import SwiftUI

struct ContentView: View {
    var game: Game
    @State private var startButtonEnabled: Bool

    init() {
        game = Game()
        startButtonEnabled = true
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
                Text("Test")
                    .fontWeight(.bold)
                    .font(.system(.title, design: .rounded))
            }
            .padding()
        }.onAppear(perform: OnAppear)
    }

    private func OnAppear() {
        let mediaButtonsRegistrator = MediaButtonsRegistrator()
        mediaButtonsRegistrator.register(OnPlay: { () in OnMediaButton(mediaAction: MediaActions.Play) },
                                         OnNextTrack: { () in OnMediaButton(mediaAction: MediaActions.NextTrack) },
                                         OnPreviousTrack: { () in OnMediaButton(mediaAction: MediaActions.PreviousTrack) }
        )
    }

    func onStartButton(){
        print("Start button pressed...")
        Task.init{
            print("Starting gaeme in UI")
            try! await self.game.startGame()
        }

        print("Started task")
        self.startButtonEnabled = false
    }

    func OnTestButton(){
        Task.init{
            print("Starting gaeme in UI")
            try! await self.game.startGame()
        }
        self.startButtonEnabled = false

        // sleep for 5 seconds
        sleep(5)
        print("Pressing button...")
        OnMediaButton(mediaAction: MediaActions.PreviousTrack)

        sleep(5)
        OnMediaButton(mediaAction: MediaActions.Play)

    }

    private func OnMediaButton(mediaAction: MediaActions) {
        print("On Action \(mediaAction)")
        Task.init {
            self.game.reactToMediaKey(mediaAction: mediaAction)
            OnPostReact()
        }
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
