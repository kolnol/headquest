//
//  MediaButtonsRegistrator.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 16.07.22.
//

import Foundation
import AVFAudio
import MediaPlayer


class MediaButtonsRegistrator{
    func register(OnPlay:@escaping ()->Void, OnNextTrack:@escaping ()->Void,OnPreviousTrack:@escaping ()->Void){
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch{
            print("Cannot register")
        }
        
        setupMediaPlayerNotifications(OnPlay: OnPlay, OnNextTrack: OnNextTrack, OnPreviousTrack: OnPreviousTrack)
    }
    
    private func setupMediaPlayerNotifications(OnPlay:@escaping ()->Void, OnNextTrack:@escaping ()->Void,OnPreviousTrack:@escaping ()->Void){
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.stopCommand.addTarget(handler: {  event in
            print("Stop")
            return .success
        })
        
        commandCenter.togglePlayPauseCommand.addTarget(handler: {  event in
            print("OnToggle")
            OnPlay()
            return .success
        })
        
        commandCenter.playCommand.addTarget(handler: {  event in
            OnPlay()
            return .success
        })
    
        
        commandCenter.nextTrackCommand.addTarget(handler: {  event in
            OnNextTrack()
            return .success
        })
        
        commandCenter.previousTrackCommand.addTarget(handler: {  event in
            OnPreviousTrack()
            return .success
        })
    }
}
