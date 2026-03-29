import AVFoundation
import AudioToolbox

class AudioService {
    static let shared = AudioService()

    private let synthesizer = AVSpeechSynthesizer()

    private init() {}

    func playTapSound() {
        // 使用系統音效
        AudioServicesPlaySystemSound(1104)
    }

    func playGameOverSound() {
        AudioServicesPlaySystemSound(1053)
    }

    func playHaptic() {
        // 使用系統觸覺反饋
        AudioServicesPlaySystemSound(1519) // 觸覺反饋音效
    }

    /// 使用 AVSpeechSynthesizer 發音注音符號
    func pronounce(_ character: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: character)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
        utterance.rate = 0.3
        utterance.volume = 1.0
        synthesizer.speak(utterance)
    }
}