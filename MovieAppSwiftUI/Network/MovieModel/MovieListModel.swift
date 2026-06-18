//
//  MovieListModel.swift
//  MovieApp
//
//  Created by Nishad Zulfuqarli on 02.02.25.
//

import Foundation

struct MovieListModel: Codable {
    let page: Int?
    let results: [MovieModel]?

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
    }
}
