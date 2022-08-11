//
//  AssistWebViewControllerResprestable.swift
//  CBAAssist
//
//  Created by Cole M on 3/2/22.
//

import UIKit
import SwiftUI
import WebKit

struct AssistWebViewResprestable: UIViewRepresentable {
     
        var url: URL
    
        func makeUIView(context: Context) -> WKWebView {
            return WKWebView()
        }
     
        func updateUIView(_ webView: WKWebView, context: Context) {
            let request = URLRequest(url: url)
            _  = webView.load(request)
        }
    }
