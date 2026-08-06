import AVFoundation

final class AudioManager {
    static let shared = AudioManager()
    private var player: AVAudioPlayer?

    private init() {}

    func playSound(_ name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else {
            print("⚠️ No se encontró el sonido \(name).wav en el bundle.")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("❌ Error reproduciendo el sonido \(name): \(error)")
        }
    }
}