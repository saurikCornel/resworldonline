import WebKit
import SwiftUI
import Foundation

struct ResortsWebContainer: UIViewRepresentable {
    @ObservedObject var observable: ResortsWebObservable

    func makeCoordinator() -> ResortsWebCoordinator {
        ResortsWebCoordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = ResortsWebContainer.createConfiguredWebView(delegate: context.coordinator)
        observable.attachWebView(webView)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        ResortsWebContainer.clearWebData()
    }
}

extension ResortsWebContainer {
    static func createConfiguredWebView(delegate: WKNavigationDelegate) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = ResortsColor(rgb: "#141f2b")
        clearWebData()
        webView.navigationDelegate = delegate
        return webView
    }

    static func clearWebData() {
        let types: Set<String> = [
            WKWebsiteDataTypeLocalStorage,
            WKWebsiteDataTypeCookies,
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeMemoryCache
        ]
        WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: Date.distantPast) {}
    }
}
