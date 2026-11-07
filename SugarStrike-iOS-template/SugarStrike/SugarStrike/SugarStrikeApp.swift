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

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.10, green: 0.04, blue: 0.18, alpha: 1)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsLinkPreview = false

        if let url = Bundle.main.url(forResource: "game", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKScriptMessageHandler {
        private let light = UIImpactFeedbackGenerator(style: .light)
        private let heavy = UIImpactFeedbackGenerator(style: .heavy)

        func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
            let ms = (message.body as? NSNumber)?.doubleValue ?? 10
            if ms >= 30 { heavy.impactOccurred() } else { light.impactOccurred(intensity: 0.7) }
        }
    }
}
