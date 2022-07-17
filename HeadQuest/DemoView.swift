//
//  ContentView.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 09.05.22.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    var game:GameStateMachineImplementation
    @State private var startButtonEnabled:Bool
    let synthesizer: AVSpeechSynthesizer
    
    init() {
        self.game = GameStateMachineImplementation()
        self.startButtonEnabled = true
        self.synthesizer = AVSpeechSynthesizer()
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10){
        Button {
            tellDescriptionOfNode(node: self.game.currentNode)
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
        self.tellDescriptionOfNode(node:self.game.currentNode)
        OnPostReact()
    }
    
    private func OnNextTrack(){
        print("OnNextTrack")
        self.game.reactToMediaKey(mediaAction: MediaActions.NextTrack)
        self.tellDescriptionOfNode(node:self.game.currentNode)
        OnPostReact()
    }
    
    private func OnPreviousTrack(){
        print("OnPreviousTrack")
        self.game.reactToMediaKey(mediaAction: MediaActions.PreviousTrack)
        self.tellDescriptionOfNode(node:self.game.currentNode)
        OnPostReact()
    }
    
    private func tellDescriptionOfNode(node: QuestGraphNodeSG){
        let utterance = AVSpeechUtterance(string: node.description)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        self.synthesizer.speak(utterance)
    }
    
    private func OnPostReact(){
        if self.game.isEnd(){
            resetGame()
        }
    }
    
    private func resetGame(){
        print("Reset Game")
        if !self.game.isEnd(){
            self.synthesizer.stopSpeaking(at:AVSpeechBoundary.immediate)
        }
        self.game.reset()
        self.startButtonEnabled = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
