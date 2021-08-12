//
//  SearchItem.swift
//  Lycs
//
//  Created byTzu-Yi Lin on 2021/8/12.
//  Copyright © 2021Tzu-Yi Lin. All rights reserved.
//

import Foundation

struct SearchItem: Codable, Identifiable, Equatable, Hashable {

    var id: String

    var title: String

    var artist: String

    var lyrics: String

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
