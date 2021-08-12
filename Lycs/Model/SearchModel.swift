//
//  SearchModel.swift
//  Lycs
//
//  Created by wayne lin on 2020/6/26.
//  Copyright © 2020 wayne lin. All rights reserved.
//

import Combine
import WebKit

class SearchModel: NSObject, ObservableObject {

    @Published var searchText: String = "https://"

    @Published var item: SearchItem? = nil

    @Published var histories: [SearchItem] = []

    @Published var selectedHistory: SearchItem.ID?

    private var cancellables: Set<AnyCancellable> = []

    override init() {
        super.init()

        $item
            .compactMap { $0 }
            .sink { [unowned self] in
                if !histories.contains($0) {
                    histories.append($0)
                }
            }
            .store(in: &cancellables)

        $selectedHistory
            .compactMap { $0 }
            .map { [unowned self] in
                item(for: $0)
            }
            .assign(to: &$item)
    }

    private func item(for id: SearchItem.ID) -> SearchItem? {
        return histories.filter({ $0.id == id }).first
    }
}
