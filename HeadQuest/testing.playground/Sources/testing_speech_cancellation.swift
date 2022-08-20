import AVFoundation
import Foundation

public class SpeechSynthesizerAsyncPlayGround: NSObject, ObservableObject
{
	private typealias SpeechContinuation = CheckedContinuation<Void, Never>

	private var speechContinuation: SpeechContinuation?
	private var errorDescription: String?
	public let synthesizer: AVSpeechSynthesizer = .init()
	private var continuation: CheckedContinuation<AVAudioPCMBuffer?, Never>?

	override public init()
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

	//    public func generateAudioBuffer(_ text: String, language: String = "en-GB") async -> AVAudioPCMBuffer? {
	//        do {
	//            let utterance = AVSpeechUtterance(string: text)
	//            utterance.voice = AVSpeechSynthesisVoice(language: language)
//
	//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
	//            try AVAudioSession.sharedInstance().setActive(true)
//
	//            return await withCheckedContinuation { (continuation: CheckedContinuation<AVAudioPCMBuffer?, Never>) in
	//                if Task.isCancelled {
	//                    print("Finished decoding")
	//                    continuation.resume(returning: nil)
	//                }
	//                var wholeBuffer = AVAudioPCMBuffer()
	//                var currentFrame = 0
	//                synthesizer.write(utterance) { buffer in
	//                    guard let pcmBuffer = buffer as? AVAudioPCMBuffer else {
	//                        fatalError("unknown buffer type: \(buffer)")
	//                    }
//
	//                    if Task.isCancelled {
	//                        print("Finished decoding")
	//                        // continuation.resume(returning: nil)
	//                    }
//
	//                    if pcmBuffer.frameLength == 0 {
	//                        // done
	//                        // continuation.resume(returning: wholeBuffer)
	//                    } else {
	//                        // append buffer to buffer
	//                    }
	//                }
	//            }
	//        } catch {
	//            errorDescription = error.localizedDescription
	//            print("Cannot speak \(String(describing: errorDescription))")
	//            return nil
	//        }
	//    }

	public func stop()
	{
		print("[Synthesizer] stop")
		synthesizer.stopSpeaking(at: .immediate)
	}
}

// TODO: why delegate is not called?
extension SpeechSynthesizerAsyncPlayGround: AVSpeechSynthesizerDelegate
{
	public func speechSynthesizer(_: AVSpeechSynthesizer, didStart _: AVSpeechUtterance)
	{
		print("[Synthesizer] didStart")
	}

	public func speechSynthesizer(_: AVSpeechSynthesizer, didCancel _: AVSpeechUtterance)
	{
		print("[Synthesizer] didCancel")
		//        speechContinuation?.resume()
		//        speechContinuation = nil
	}

	public func speechSynthesizer(_: AVSpeechSynthesizer, didFinish _: AVSpeechUtterance)
	{
		print("[Synthesizer] didFinish")
		speechContinuation?.resume()
		speechContinuation = nil
	}

	public func speechSynthesizer(_: AVSpeechSynthesizer, willSpeakRangeOfSpeechString _: NSRange, utterance _: AVSpeechUtterance)
	{
		print("[Synthesizer] willSpeakRangeOfSpeechString")
	}
}
