//
//  ContentView.swift
//  Lycs
//
//  Created by wayne lin on 2020/6/26.
//  Copyright © 2020 wayne lin. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var searchModel: SearchModel

    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $searchModel.searchText)

                Button(action: {
                    self.searchModel.shouldUpdate = true
                }, label: {
                    Text("Search")
                })

            }.padding()

            HStack {
                WebView(searchText: $searchModel.searchText,
                        shouldUpdateSearchText: $searchModel.shouldUpdate,
                        lyrics: $searchModel.lyrics)

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
