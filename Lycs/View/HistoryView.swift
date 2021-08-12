//
//  HistoryView.swift
//  Lycs
//
//  Created byTzu-Yi Lin on 2021/8/12.
//  Copyright © 2021Tzu-Yi Lin. All rights reserved.
//

import SwiftUI

struct HistoryView: View {

    @Binding var items: [SearchItem]

    @Binding var selection: SearchItem.ID?

    var body: some View {
        if items.isEmpty {
            Text("No History")
        } else {
            List(items, selection: $selection) { item in
                VStack(alignment: .leading, spacing: 4.0) {
                    Text(item.title)
                    Text(item.artist)
                        .font(.footnote)
                    Text(item.lyrics)
                        .lineLimit(2)
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(items: .constant([]), selection: .constant(nil))
    }
}
