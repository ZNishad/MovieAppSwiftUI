//
//  MovieModel.swift
//  MovieApp
//
//  Created by Nishad Zulfuqarli on 02.02.25.
//

import Foundation

struct MovieModel: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id = "id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    private func getFullPath(filePath: String?) -> String? {
        guard let filePath else { return nil}
        let baseURL = "https://image.tmdb.org/t/p/"
        let size = "w500"
        return "\(baseURL)\(size)\(filePath)"
    }

    var posterFullPath: String? {
        getFullPath(filePath: posterPath)
    }

    var backdropFullPath: String? {
        getFullPath(filePath: backdropPath)
    }
}
