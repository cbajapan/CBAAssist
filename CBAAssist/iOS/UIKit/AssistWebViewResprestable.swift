//
//  AssistWebViewControllerResprestable.swift
//  CBAAssist
//
//  Created by Cole M on 3/2/22.
//

import UIKit
import SwiftUI
import WebKit

struct AssistWebViewRepresentable: UIViewRepresentable {
    
    var webView: WKWebView
    @Binding var forwardId: UUID?
    @Binding var backId: UUID?
    @Binding var refreshId: UUID?
    
    init(
        webView: WKWebView,
        forwardId: Binding<UUID?>,
        backId: Binding<UUID?>,
        refreshId: Binding<UUID?>
    ) {
        self.webView = webView
        self._forwardId = forwardId
        self._backId = backId
        self._refreshId = refreshId
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        
        if forwardId != context.coordinator.previousForwardId {
            if webView.canGoForward {
                _ = webView.goForward()
            }
            context.coordinator.previousForwardId = forwardId
        }
        
        if backId != context.coordinator.previousBackId {
            if webView.canGoBack {
                _ = webView.goBack()
            }
            context.coordinator.previousBackId = backId
        }
        
        if refreshId != context.coordinator.previousRefreshId {
               _ = webView.reload()
            context.coordinator.previousRefreshId = refreshId
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        var parent: AssistWebViewRepresentable
        var previousForwardId: UUID? = nil
        var previousBackId: UUID? = nil
        var previousRefreshId: UUID? = nil
        
        init(_ parent: AssistWebViewRepresentable) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
            return .allow
        }
        
        func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            completionHandler(.performDefaultHandling, nil)
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("DID FAIL ERROR: ", error)
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("DID FAIL Provisional ERROR: ", error)
        }
    }
}
