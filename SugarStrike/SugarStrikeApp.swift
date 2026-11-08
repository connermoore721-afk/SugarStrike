import SwiftUI
import WebKit
import UIKit

@main
struct SugarStrikeApp: App {
    var body: some Scene {
        WindowGroup {
            GameView()
                .ignoresSafeArea()
                .statusBarHidden(true)
                .persistentSystemOverlays(.hidden)
                .background(Color(red: 0.10, green: 0.04, blue: 0.18))
        }
    }
}

/// Hosts the game (game.html, bundled in the app) in a full-screen web view.
struct GameView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        // The game calls window.webkit.messageHandlers.haptic.postMessage(ms)
        config.userContentController.add(context.coordinator, name: "haptic")
        // The game calls window.webkit.messageHandlers.saveFile.postMessage({name, text})
        config.userContentController.add(context.coordinator, name: "saveFile")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.10, green: 0.04, blue: 0.18, alpha: 1)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsLinkPreview = false
        context.coordinator.webView = webView

        if let url = Bundle.main.url(forResource: "game", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKScriptMessageHandler {
        weak var webView: WKWebView?
        private let light = UIImpactFeedbackGenerator(style: .light)
        private let heavy = UIImpactFeedbackGenerator(style: .heavy)

        func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "saveFile" {
                guard let body = message.body as? [String: Any],
                      let name = body["name"] as? String,
                      let text = body["text"] as? String else { return }
                shareSaveFile(name: name, text: text)
                return
            }
            let ms = (message.body as? NSNumber)?.doubleValue ?? 10
            if ms >= 30 { heavy.impactOccurred() } else { light.impactOccurred(intensity: 0.7) }
        }

        /// Writes the save to a temporary file and opens the iOS share sheet ("Save to Files", AirDrop, etc.).
        private func shareSaveFile(name: String, text: String) {
            let safeName = name.replacingOccurrences(of: "/", with: "-")
            let url = FileManager.default.temporaryDirectory.appendingPathComponent(safeName)
            do { try text.write(to: url, atomically: true, encoding: .utf8) } catch { return }
            DispatchQueue.main.async {
                guard let webView = self.webView,
                      var top = webView.window?.rootViewController else { return }
                while let presented = top.presentedViewController { top = presented }
                let sheet = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                if let pop = sheet.popoverPresentationController {
                    pop.sourceView = webView
                    pop.sourceRect = CGRect(x: webView.bounds.midX, y: webView.bounds.midY, width: 1, height: 1)
                    pop.permittedArrowDirections = []
                }
                top.present(sheet, animated: true)
            }
        }
    }
}
