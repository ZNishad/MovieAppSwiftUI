//
//  CastModel.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 19.05.26.
//

import Foundation

// MARK: - CastModel
struct CastModel: Codable {
    let id: Int
    let cast, crew: [Cast]
}

// MARK: - Cast
struct Cast: Codable {
    let adult: Bool
    let gender, id: Int
    let knownForDepartment: Department
    let name, originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?
    let department: Department?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }

    private func getFullPath(filePath: String?) -> String? {
        guard let filePath else { return nil}
        let baseURL = "https://image.tmdb.org/t/p/"
        let size = "w500"
        return "\(baseURL)\(size)\(filePath)"
    }

    var getCastProfileFullPath: String? {
        getFullPath(filePath: profilePath)
    }
}

enum Department: String, Codable {
    case acting = "Acting"
    case art = "Art"
    case camera = "Camera"
    case costumeMakeUp = "Costume & Make-Up"
    case crew = "Crew"
    case directing = "Directing"
    case editing = "Editing"
    case lighting = "Lighting"
    case production = "Production"
    case sound = "Sound"
    case visualEffects = "Visual Effects"
    case writing = "Writing"
}
