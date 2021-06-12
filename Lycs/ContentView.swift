//
//  ContentView.swift
//  Lycs
//
//  Created by wayne lin on 2020/6/26.
//  Copyright © 2020 wayne lin. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @StateObject var searchModel = SearchModel()

    @State var url: String = "https://petitlyrics.com/lyrics/"

    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $url, onCommit:  {
                    self.searchModel.searchText = url
                })

                Button(action: {
                    self.searchModel.searchText = url
                }, label: {
                    Text("Search")
                })

            }.padding()

            ZStack {
                WebView(searchText: $searchModel.searchText,
                        lyrics: $searchModel.lyrics)
                Rectangle()
                    .fill(Color(NSColor.windowBackgroundColor))
            }
            .frame(height: 2)

            HStack {

                VStack {
                    ScrollView {
                        Text(searchModel.lyrics ?? "")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    Button(action: {
                        guard let text = self.searchModel.lyrics else { return }
                        let pastboard = NSPasteboard.general
                        pastboard.clearContents()
                        pastboard.setString(text, forType: .string)
                    }, label: {
                        Text("Copy to Pasteboard")
                    }).frame(maxHeight: 44)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
