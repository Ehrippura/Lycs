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

    @Binding var item: SearchItem?

    @Binding var isLoading: Bool

    fileprivate var lyrics: String? = nil

    init(searchText: Binding<String>, item: Binding<SearchItem?>, isLoading: Binding<Bool>) {
        self._searchText = searchText
        self._item = item
        self._isLoading = isLoading
    }

    class Coordinate: NSObject, WKNavigationDelegate, WKScriptMessageHandler {

        var parent: WebView

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

            switch message.name {

            case "handler":
                if let dict = message.body as? Dictionary<String, AnyObject>, let status = dict["status"] as? Int {
                    if status == 200,
                       let responseData = dict["response"] as? String,
                       let data = responseData.data(using: .utf8),
                       let response = try? JSONDecoder().decode([LyricsResponse].self, from: data) {

                        let lys = Converter.convert(lyrics: response)
                        parent.lyrics = lys
                    }
                }

            default:
                break
            }
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

            decisionHandler(navigationAction.request.url?.host == "petitlyrics.com" ? .allow : .cancel)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

            guard let jsFile = Bundle.main.url(forResource: "title", withExtension: "js"),
                  let js = try? String(contentsOf: jsFile) else {
                return
            }

            webView.evaluateJavaScript(js) { [unowned webView] obj, err in

                guard let id = webView.url?.lastPathComponent else {
                    return
                }

                var item = SearchItem(id: id, title: "<unknown>", artist: "<unknown>", lyrics: self.parent.lyrics ?? "")

                if let title = obj as? String {
                    let components = title.split(separator: "/")
                    let title = components.first?.trimmingCharacters(in: .whitespacesAndNewlines)
                    let artist = components.last?.trimmingCharacters(in: .whitespacesAndNewlines)

                    if let title = title {
                        item.title = title
                    }

                    if let artist = artist {
                        item.artist = artist
                    }
                }

                self.parent.item = item
                self.parent.isLoading = false
            }
        }

        init(parent: WebView) {
            self.parent = parent
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

        return Coordinate(parent: self)
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {

        guard let url = URL(string: searchText), url != nsView.url else {
            return
        }
        nsView.load(URLRequest(url: url))
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
        WebView(searchText: .constant("https://www.google.com"), item: .constant(nil), isLoading: .constant(false))
    }
}

