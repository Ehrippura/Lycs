//
//  ContentView.swift
//  Lycs
//
//  Created by wayne lin on 2020/6/26.
//  Copyright © 2020 wayne lin. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @StateObject var model = SearchModel()

    var body: some View {
        NavigationView {
            HistoryView(items: $model.histories, selection: $model.selectedHistory)
                .frame(minWidth: 200.0)
            SearchView(searchModel: model)
        }
        .navigationTitle(model.item?.title ?? "petitlyrics.com")
        .navigationSubtitle(model.item?.artist ?? "")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
