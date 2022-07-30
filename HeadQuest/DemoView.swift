//
//  ContentView.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 09.05.22.
//

import SwiftUI

struct ContentView: View {
    var game:GameStateMachineImplementation
    @State private var startButtonEnabled:Bool
    
    init() {
        self.game = GameStateMachineImplementation()
        self.startButtonEnabled = true
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10){
        Button {
            self.game.startGame()
            self.startButtonEnabled = false
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
        }.onAppear(perform: OnAppear)
    }
    
    private func OnAppear(){
        let mediaButtonsRegistrator = MediaButtonsRegistrator()
        mediaButtonsRegistrator.register(OnPlay: OnPlay, OnNextTrack: OnNextTrack, OnPreviousTrack: OnPreviousTrack)
    }
    
    private func OnPlay(){
        print("OnPlay")
        self.game.reactToMediaKey(mediaAction: MediaActions.Play)
        OnPostReact()
    }
    
    private func OnNextTrack(){
        print("OnNextTrack")
        self.game.reactToMediaKey(mediaAction: MediaActions.NextTrack)
        OnPostReact()
    }
    
    private func OnPreviousTrack(){
        print("OnPreviousTrack")
        self.game.reactToMediaKey(mediaAction: MediaActions.PreviousTrack)
        
        OnPostReact()
    }
    
    private func OnPostReact(){
        if self.game.isEnd(){
            resetGame()
        }
    }
    
    private func resetGame(){
        print("Reset Game")
        self.game.reset()
        self.startButtonEnabled = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
