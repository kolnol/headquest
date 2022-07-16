//
//  ContentView.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 09.05.22.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    var body: some View {
        Button {
            let questGraph = QuestGraphFixtures.SimpleQuest()
            let start = questGraph.vertexAtIndex(0)
            
            var utterance = AVSpeechUtterance(string: start.description)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
            
            let keyDoor = questGraph.traverse(questNode: start, action: QuestGraphActionEdgeSG(name: "open_key_door"))!
            utterance = AVSpeechUtterance(string: keyDoor.description)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            synthesizer.speak(utterance)
        } label: {
            Text("Hello World")
                .fontWeight(.bold)
                .font(.system(.title, design: .rounded))
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.purple)
        .cornerRadius(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
