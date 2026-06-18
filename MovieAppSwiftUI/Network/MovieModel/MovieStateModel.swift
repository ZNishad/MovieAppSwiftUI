//
//  WatchListStateModel.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 25.05.26.
//

import Foundation

// MARK: - MovieStateModel
struct MovieStateModel: Codable {
    let id: Int
    let favorite: Bool
    let watchlist: Bool
}
