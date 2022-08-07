//
//  MediaButtonsRegistrator.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 16.07.22.
//

import AVFAudio
import Foundation
import MediaPlayer

class MediaButtonsRegistrator {
    func register(OnPlay: @escaping () -> Void, OnNextTrack: @escaping () -> Void, OnPreviousTrack: @escaping () -> Void) {
        do {
            setupNotifications()
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Cannot register")
        }

        setupMediaPlayerNotifications(OnPlay: OnPlay, OnNextTrack: OnNextTrack, OnPreviousTrack: OnPreviousTrack)
    }

    private func setupMediaPlayerNotifications(OnPlay: @escaping () -> Void, OnNextTrack: @escaping () -> Void, OnPreviousTrack: @escaping () -> Void) {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.stopCommand.addTarget(handler: { _ in
            print("Stop")
            return .success
        })

        commandCenter.togglePlayPauseCommand.addTarget(handler: { _ in
            print("OnToggle")
            OnPlay()
            return .success
        })

        commandCenter.playCommand.addTarget(handler: { _ in
            OnPlay()
            return .success
        })

        commandCenter.nextTrackCommand.addTarget(handler: { _ in
            OnNextTrack()
            return .success
        })

        commandCenter.previousTrackCommand.addTarget(handler: { _ in
            OnPreviousTrack()
            return .success
        })
    }

    func setupNotifications() {
        // Get the default notification center instance.
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(handleInterruption),
                       name: AVAudioSession.interruptionNotification,
                       object: AVAudioSession.sharedInstance())
    }

    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue)
        else {
            return
        }

        // Switch over the interruption type.
        switch type {
        case .began:
            print("Began audio interruption")

        case .ended:
            print("Ended audio interruption")

            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                // An interruption ended. Resume playback.
            } else {
                // An interruption ended. Don't resume playback.
            }

        default: ()
        }
    }
}
