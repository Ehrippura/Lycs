//
//  WebView.swift
//  Lycs
//
//  Created by wayne lin on 2020/6/26.
//  Copyright © 2020 wayne lin. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {

    @Binding var searchText: String
    @Binding var shouldUpdateSearchText: Bool
    @Binding var lyrics: String?

    class Coordinate: NSObject, WKNavigationDelegate, WKScriptMessageHandler {

        var lyrics: Binding<String?>

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

            if let dict = message.body as? Dictionary<String, AnyObject>, let status = dict["status"] as? Int {

                if status == 200,
                    let responseData = dict["response"] as? String,
                    let data = responseData.data(using: .utf8),
                    let response = try? JSONDecoder().decode([LyricsResponse].self, from: data) {

                    let lys = Converter.convert(lyrics: response)
                    self.lyrics.wrappedValue = lys
                }
            }
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

            decisionHandler(navigationAction.request.url?.host == "petitlyrics.com" ? .allow : .cancel)
        }

        init(lyrics: Binding<String?>) {
            self.lyrics = lyrics
            super.init()
        }
    }

    func makeNSView(context: Context) -> WKWebView {

        let config = WKWebViewConfiguration()
        let userScript = WKUserScript(source: getScript(), injectionTime: .atDocumentStart, forMainFrameOnly: false)
        config.userContentController.addUserScript(userScript)
        config.userContentController.add(context.coordinator, name: "handler")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func makeCoordinator() -> Coordinate {

        return Coordinate(lyrics: $lyrics)
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {

        guard let url = URL(string: searchText), url != nsView.url else {
            return
        }

        if shouldUpdateSearchText {
            shouldUpdateSearchText = false
            nsView.load(URLRequest(url: url))
        }
    }

    static func dismantleNSView(_ nsView: WKWebView, coordinator: Coordinate) {

    }

    private func getScript() -> String {
        let path = Bundle.main.path(forResource: "listener", ofType: "js")!
        let str = try! String(contentsOfFile: path)
        return str
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(searchText: .constant("https://www.google.com"), shouldUpdateSearchText: .constant(true), lyrics: .constant("hello world"))
    }
}

