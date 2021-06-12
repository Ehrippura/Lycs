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

    @Published var lyrics: String?

    private var converter = Converter()
}
