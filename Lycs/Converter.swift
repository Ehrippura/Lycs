//
//  Converter.swift
//  Lycs
//
//  Created by wayne lin on 2020/6/26.
//  Copyright © 2020 wayne lin. All rights reserved.
//

import Foundation

struct LyricsResponse: Codable {
    var lyrics: String
}

struct Converter {

    static func convert(lyrics: [LyricsResponse]) -> String {

        var finalString = ""

        for line in lyrics {
            if let data = Data(base64Encoded: line.lyrics),
                let str = String(data: data, encoding: .utf8) {

                finalString += str + "\n"
            }
        }

        return finalString
    }
}

