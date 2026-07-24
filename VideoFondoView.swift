import SwiftUI
import AVKit

struct VideoFondoView: UIViewControllerRepresentable {

    let videoNames: [String]
    @Binding var currentIndex: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(videoNames: videoNames, currentIndex: $currentIndex)
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {

        let controller = AVPlayerViewController()
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.player = context.coordinator.player
        context.coordinator.player.play()

        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {

    }

    class Coordinator: NSObject {

        let videoNames: [String]
        @Binding var currentIndex: Int
        let player: AVPlayer

        init(videoNames: [String], currentIndex: Binding<Int>) {
            self.videoNames = videoNames
            self._currentIndex = currentIndex

            let url = Bundle.main.url(forResource: videoNames[0], withExtension: "mp4")!
            self.player = AVPlayer(url: url)

            super.init()

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(videoDidEnd),
                name: .AVPlayerItemDidPlayToEndTime,
                object: nil
            )
        }

        @objc func videoDidEnd() {

            let nextIndex = (currentIndex + 1) % videoNames.count

            guard let url = Bundle.main.url(forResource: videoNames[nextIndex], withExtension: "mp4") else { return }

            let nextItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: nextItem)
            player.play()

            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 1)) {
                    self.currentIndex = nextIndex
                }
            }
        }
    }
}
