//
//  ContentView.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 09.05.22.
//

import OSLog
import SwiftUI

struct ContentView: View
{
	var game: Game
	var gameGraph: QuestGraphSG
	var logger: Logger = .init(subsystem: "com.mykola.headquest.DemoView", category: String(describing: ContentView.self))

	@State private var startButtonEnabled: Bool = true
	@State private var showCachingProgressView: Bool = true
	@State private var progress = 0.0

	init()
	{
		do
		{
			try gameGraph = QuestGraphFixtures.SimpleQuest()
		}
		catch
		{
			fatalError(error.localizedDescription)
		}

		game = Game(gameGraph: gameGraph)

		startButtonEnabled = true
		showCachingProgressView = true
	}

	var body: some View
	{
		VStack(alignment: .center, spacing: 10)
		{
			Button
			{
				onStartButton()
			} label: {
				Text("Start")
					.fontWeight(.bold)
					.font(.system(.title, design: .rounded))
			}.disabled(startButtonEnabled == false)
			.padding()

			Button
			{
				resetGame()
			} label: {
				Text("Reset")
					.fontWeight(.bold)
					.font(.system(.title, design: .rounded))
			}
			.padding()

			ProgressView("Caching audio data... Please give me money for voice actors!")
				.font(.body)
				.hidden(showCachingProgressView == false)

			ProgressView(value: progress)
				.padding([.leading, .trailing], 10)
				.accentColor(Color.green)
				.scaleEffect(x: 1, y: 4, anchor: .center)
				.hidden(showCachingProgressView == false)

		}.task
		{
			await cacheAudio()
		}.onAppear(perform: OnAppear)
	}

	private func OnAppear()
	{
		let mediaButtonsRegistrator = MediaButtonsRegistrator()
		mediaButtonsRegistrator.register(
			OnPlay: { () in OnMediaButton(mediaAction: MediaActions.Play) },
			OnNextTrack: { () in OnMediaButton(mediaAction: MediaActions.NextTrack) },
			OnPreviousTrack: { () in OnMediaButton(mediaAction: MediaActions.PreviousTrack) }
		)
	}

	func onStartButton()
	{
		logger.info("Start button pressed.")
		try! game.startGame()

		logger.info("Start event processed.")
		startButtonEnabled = false
	}

	private func OnMediaButton(mediaAction: MediaActions)
	{
		logger.info("On Action \(mediaAction.description)")
		game.reactToMediaKey(mediaAction: mediaAction)
	}

	private func resetGame()
	{
		logger.info("Reset Game")
		game.reset()
		startButtonEnabled = true
	}

	private func cacheAudio() async
	{
		startButtonEnabled = false
		showCachingProgressView = true
		let totalNodesToConvert = Double(gameGraph.vertices.count)
		var converted = 0.0
		let audioCacher = SpeechCacher()
		await audioCacher.cacheGraphSpeechSynthesizedAudio(gameGraph: gameGraph, onEachConverted: {
			converted += 1
			progress = converted / totalNodesToConvert
		})
		showCachingProgressView = false
		startButtonEnabled = true
	}
}

struct ContentView_Previews: PreviewProvider
{
	static var previews: some View
	{
		ContentView()
	}
}

extension View
{
	func hidden(_ shouldHide: Bool) -> some View
	{
		opacity(shouldHide ? 0 : 1)
	}
}
