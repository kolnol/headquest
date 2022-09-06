//
//  SpeechIdentifiers.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 06.09.22.
//

import Foundation

class SpeechIdentifiers {
    public static func getVoiceIdForName(name:String) -> String {
        let maps = [
            "Old Man" : "com.apple.ttsbundle.Daniel-compact",
            "OldMan" : "com.apple.ttsbundle.Daniel-compact",
            "Narrator" : "com.apple.ttsbundle.siri_male_en-GB_compact"
        ]
        
        return maps[name]!
    }
}
