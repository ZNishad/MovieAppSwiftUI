//
//  ReviewModel.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 19.05.26.
//

import Foundation

// MARK: - ReviewModel
struct ReviewModel: Codable {
    let id, page: Int
    let results: [ReviewResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct ReviewResult: Codable {
    let author: String
    let authorDetails: AuthorDetails
    let content, createdAt, id, updatedAt: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

// MARK: - AuthorDetails
struct AuthorDetails: Codable {
    let name, username: String
    let avatarPath: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }

    private func getFullPath(filePath: String?) -> String? {
        guard let filePath else { return nil}
        let baseURL = "https://image.tmdb.org/t/p/"
        let size = "w500"
        return "\(baseURL)\(size)\(filePath)"
    }

    var getFullAvatarPath: String? {
        getFullPath(filePath: avatarPath)
    }
}
