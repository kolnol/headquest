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
    
    init() {
        self.game = GameStateMachineImplementation()
    }
    
    var body: some View {
        Button {
            tellDescriptionOfNode(node: self.game.currentNode)
        } label: {
            Text("Start")
                .fontWeight(.bold)
                .font(.system(.title, design: .rounded))
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.purple)
        .cornerRadius(20)
        .onAppear(perform: OnAppear)
    }
    
    private func OnAppear(){
        let mediaButtonsRegistrator = MediaButtonsRegistrator()
        mediaButtonsRegistrator.register(OnPlay: OnPlay, OnNextTrack: OnNextTrack, OnPreviousTrack: OnPreviousTrack)
    }
    
    private func OnPlay(){
        self.game.reactToMediaKey(mediaAction: MediaActions.Play)
        self.tellDescriptionOfNode(node:self.game.currentNode)
    }
    
    private func OnPause(){
        //Notsupported yet
    }
    
    private func OnNextTrack(){
        self.game.reactToMediaKey(mediaAction: MediaActions.NextTrack)
        self.tellDescriptionOfNode(node:self.game.currentNode)
    }
    
    private func OnPreviousTrack(){
        self.game.reactToMediaKey(mediaAction: MediaActions.PreviousTrack)
        self.tellDescriptionOfNode(node:self.game.currentNode)
    }
    
    private func tellDescriptionOfNode(node: QuestGraphNodeSG){
        let utterance = AVSpeechUtterance(string: node.description)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
