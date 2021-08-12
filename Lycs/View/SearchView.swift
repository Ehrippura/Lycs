//
//  SearchView.swift
//  Lycs
//
//  Created byTzu-Yi Lin on 2021/8/12.
//  Copyright © 2021Tzu-Yi Lin. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var searchModel: SearchModel

    @State var url: String = "https://petitlyrics.com/lyrics/"

    @State var isSearching: Bool = false

    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $url, onCommit:  {
                    self.searchModel.searchText = url
                })

                Button("Search") {
                    self.searchModel.searchText = url
                    self.isSearching = true
                }

                if isSearching {
                    ProgressView()
                        .scaleEffect(0.5)
                }

            }.padding()

            ZStack {
                WebView(searchText: $searchModel.searchText,
                        item: $searchModel.item,
                        isLoading: $isSearching)
                Rectangle()
                    .fill(Color(NSColor.windowBackgroundColor))
            }
            .frame(height: 2)

            HStack {

                VStack {
                    ScrollView {
                        Text(searchModel.item?.lyrics ?? "")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }

                    Button("Copy to Pasteboard") {
                        guard let text = self.searchModel.item?.lyrics else { return }
                        let pastboard = NSPasteboard.general
                        pastboard.clearContents()
                        pastboard.setString(text, forType: .string)
                    }
                    .frame(maxHeight: 44)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchModel: SearchModel())
    }
}
