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

        ZStack {
            WebView(searchText: $searchModel.searchText,
                    item: $searchModel.item,
                    isLoading: $isSearching)
                .frame(height: 1.0)

            VStack {
                HStack {
                    TextField("Search", text: $url, onCommit:  {
                        self.searchModel.searchText = url
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Search") {
                        self.searchModel.searchText = url
                        self.isSearching = true
                    }

                }.padding()

                ZStack {
                    ScrollView {
                        Text(searchModel.item?.lyrics ?? "")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .contextMenu(menuItems: {
                        Button("Copy to Pasteboard") {
                            guard let text = self.searchModel.item?.lyrics else { return }
                            let pastboard = NSPasteboard.general
                            pastboard.clearContents()
                            pastboard.setString(text, forType: .string)
                        }
                    })

                    if isSearching {
                        ProgressView()
                    }
                }
            }
            .background(Color(NSColor.windowBackgroundColor))
        }

        .toolbar {
            ToolbarItem {
                Spacer()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchModel: SearchModel())
    }
}
