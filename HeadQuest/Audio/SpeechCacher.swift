//
//  SpeechCacher.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 12.08.22.
//

import Foundation
import OSLog

public class SpeechCacher: LoggingComponent
{
	override init()
	{
		super.init()
	}

    public func cacheGraphSpeechSynthesizedAudio(gameGraph: QuestGraphSG, overrideExisting: Bool = false, onEachConverted: (() -> Void)?) async
	{
		await withTaskGroup(of: Void.self, body: { taskGroup in
			for node in gameGraph.vertices
			{
				taskGroup.addTask
				{
                    let fileName = SpeechCacher.nodeNameToSpeechFileName(nodeName: node.name)
                    
                    if !overrideExisting && SpeechCacher.fileExists(fileName: fileName)
                    {
                        return
                    }
                    
                    guard let description = node.description else {
                        self.logger.warning("No description in node \(node.name). Skipping...")
                        return
                    }
                    
					self.logger.log(level: .debug, "Start converting \(node.name)...")
					let textToAudioFileGenerator = TextToAudioFileGenerator()
					
					self.logger.log(level: .debug, "Converting \(node.name) in to file name \(fileName)")
					await textToAudioFileGenerator.generateAudio(description, outputFilePath: fileName)
					self.logger.log(level: .debug, "Done converting \(node.name) in to file name \(fileName)")
				}
			}

			for await _ in taskGroup
			{
				onEachConverted?()
			}
		})
	}

	public static func nodeNameToSpeechFileName(nodeName: String) -> String
	{
		nodeName.replacingOccurrences(of: " ", with: "_") + ".caf"
	}
    
    public static func fileExists(fileName: String) -> Bool {
        let outputFileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: outputFileUrl.path)
    }
}
