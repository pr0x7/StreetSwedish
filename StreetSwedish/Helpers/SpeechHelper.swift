import Foundation
import AVFoundation

public final class SpeechHelper: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    public static let shared = SpeechHelper()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    @Published public var isSpeaking = false
    @Published public var currentlySpeakingID: String? = nil
    
    private override init() {
        super.init()
        synthesizer.delegate = self
        
        // Configure audio session for playback so it plays even when phone is on silent mode
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error.localizedDescription)")
        }
    }
    
    /// Speaks a given Swedish text.
    /// - Parameters:
    ///   - text: The Swedish text to speak.
    ///   - itemID: Optional vocabulary item ID to trace what is speaking.
    ///   - rate: Speech rate (AVSpeechUtteranceBoundary values: typically 0.4 to 0.6).
    public func speak(_ text: String, itemID: String? = nil, rate: Float = 0.5) {
        // Stop any current speech immediately
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        // Setup utterance
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "sv-SE")
        
        // Handle iOS default fallback if Swedish voice is not installed
        if utterance.voice == nil {
            print("Warning: sv-SE voice not found. Falling back to default voice.")
            utterance.voice = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode())
        }
        
        // Clamp speed rate between min/max bounds
        utterance.rate = max(AVSpeechUtteranceMinimumSpeechRate, min(rate, AVSpeechUtteranceMaximumSpeechRate))
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        currentlySpeakingID = itemID
        isSpeaking = true
        synthesizer.speak(utterance)
    }
    
    public func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        isSpeaking = false
        currentlySpeakingID = nil
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = true
        }
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.currentlySpeakingID = nil
        }
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.currentlySpeakingID = nil
        }
    }
}
