//
//  SoundShort.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 4/22/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import Foundation

struct SoundsPage: Codable {
    let count: Int
    let next: String
    let results: [SoundShort]
    let previous: String
}

// MARK: - Result
struct SoundShort: Codable, Identifiable {
    let id: Int
    let name: String
    let tags: [String]
    let license: String
    let username: String
}
