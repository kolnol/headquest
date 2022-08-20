//
//  AudioSynthes.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 17.05.22.
//

import AVFoundation
import Foundation

internal class SpeechSynthesizer: NSObject, ObservableObject
{
	internal var errorDescription: String?
	private let synthesizer: AVSpeechSynthesizer = .init()
	private var OnFinish: (() -> Void)?

	override init()
	{
		super.init()
		synthesizer.delegate = self
	}

	internal func speak(_ text: String, language: String = "en-GB", OnFinish: (() -> Void)? = nil)
	{
		do
		{
			self.OnFinish = OnFinish
			let utterance = AVSpeechUtterance(string: text)
			utterance.voice = AVSpeechSynthesisVoice(language: language)

			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
			try AVAudioSession.sharedInstance().setActive(true)
			synthesizer.speak(utterance)
		}
		catch
		{
			errorDescription = error.localizedDescription
			print("Cannot speak \(String(describing: errorDescription))")
		}
	}

	internal func stop()
	{
		synthesizer.stopSpeaking(at: .immediate)
	}
}

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate
{
	func speechSynthesizer(_: AVSpeechSynthesizer, didFinish _: AVSpeechUtterance)
	{
		if OnFinish != nil
		{
			OnFinish!()
		}
	}
}

public class SpeechSynthesizerAsync: NSObject, ObservableObject
{
	private typealias SpeechContinuation = CheckedContinuation<Void, Never>

	private var speechContinuation: SpeechContinuation?
	internal var errorDescription: String?
	public let synthesizer: AVSpeechSynthesizer = .init()
	private var continuation: CheckedContinuation<AVAudioPCMBuffer?, Never>?

	override init()
	{
		super.init()
		synthesizer.delegate = self
	}

	public func speak(_ text: String, language: String = "en-GB") async
	{
		do
		{
			let utterance = AVSpeechUtterance(string: text)
			utterance.voice = AVSpeechSynthesisVoice(language: language)

			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
			try AVAudioSession.sharedInstance().setActive(true)

			print("Starting speaking")
			synthesizer.speak(utterance)

			print("Waiting for finish speaking")

			await withTaskCancellationHandler(handler: {
				self.stop()
			}, operation: {
				await withCheckedContinuation
				{ (continuation: SpeechContinuation) in
					self.speechContinuation = continuation
				}
			})
		}
		catch
		{
			errorDescription = error.localizedDescription
			print("Cannot speak \(String(describing: errorDescription))")
		}
	}

	public func stop()
	{
		print("[Synthesizer] Stop playing requested")
		synthesizer.stopSpeaking(at: .immediate)
		if speechContinuation != nil
		{
			do
			{
				try speechContinuation?.resume()
			}
			catch
			{
				print("[Synthesizer] error during resuming continuation on stopping")
			}
			speechContinuation = nil
		}
	}
}

extension SpeechSynthesizerAsync: AVSpeechSynthesizerDelegate
{
	public func speechSynthesizer(_: AVSpeechSynthesizer, didStart _: AVSpeechUtterance)
	{
		print("[Synthesizer] didStart")
	}

	public func speechSynthesizer(_: AVSpeechSynthesizer, didCancel _: AVSpeechUtterance)
	{
		print("[Synthesizer] didCancel")
	}

	public func speechSynthesizer(_: AVSpeechSynthesizer, didFinish _: AVSpeechUtterance)
	{
		print("[Synthesizer] didFinish")
		speechContinuation?.resume()
		speechContinuation = nil
	}

	public func speechSynthesizer(_: AVSpeechSynthesizer, willSpeakRangeOfSpeechString _: NSRange, utterance _: AVSpeechUtterance)
	{
		// print("[Synthesizer] willSpeakRangeOfSpeechString")
	}
}
