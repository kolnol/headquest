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

	public func cacheGraphSpeechSynthesizedAudio(gameGraph: QuestGraphSG, onEachConverted: (() -> Void)?) async
	{
		await withTaskGroup(of: Void.self, body: { taskGroup in
			for node in gameGraph.vertices
			{
				taskGroup.addTask
				{
					self.logger.log(level: .debug, "Start converting \(node.name)...")
					let textToAudioFileGenerator = TextToAudioFileGenerator()
					let fileName = SpeechCacher.nodeNameToSpeechFileName(nodeName: node.name)
					self.logger.log(level: .debug, "Converting \(node.name) in to file name \(fileName)")
					await textToAudioFileGenerator.generateAudio(node.description, outputFilePath: fileName)
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
}
