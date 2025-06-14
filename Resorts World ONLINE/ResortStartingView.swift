import WebKit

final class ResortsWebCoordinator: NSObject, WKNavigationDelegate {
    let parent: ResortsWebContainer
    private var navigationStarted = false

    init(parent: ResortsWebContainer) {
        self.parent = parent
    }

    private func beginNavigation() {
        if !navigationStarted { updateState(.loading(0)) }
    }

    private func commitNavigation() {
        navigationStarted = false
    }

    private func finishNavigation() {
        updateState(.finished)
    }

    private func failNavigation(_ error: Error) {
        updateState(.error(error))
    }

    private func updateState(_ state: ResortsWeb.State) {
        DispatchQueue.main.async { [weak self] in
            self?.parent.observable.state = state
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        beginNavigation()
    }

    func webView(_ webView: WKWebView, didCommit _: WKNavigation!) {
        commitNavigation()
    }

    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        finishNavigation()
    }

    func webView(_ webView: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        failNavigation(error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
        failNavigation(error)
    }

    func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if action.navigationType == .other && webView.url != nil {
            navigationStarted = true
        }
        decisionHandler(.allow)
    }
}
