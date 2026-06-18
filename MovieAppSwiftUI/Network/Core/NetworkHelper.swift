//
//  NetworkHelper.swift
//  MovieApp
//
//  Created by Nishad Zulfuqarli on 02.02.25.
//

import Foundation

enum HttpMethods: String {
    case get = "GET"
    case post = "Post"
}

struct NetworkRequestModel {
    let path: String
    let method: HttpMethods
    let pathParams: [Any]?
    let body: Data?
    let queryParams: [String: Any]?

    init(path: String, method: HttpMethods, pathParams: [Any]?, body: Data?, queryParams: [String : Any]?) {
        self.path = path
        self.method = method
        self.pathParams = pathParams
        self.body = body
        self.queryParams = queryParams
    }

    init(path: String, method: HttpMethods, pathParams: [Any]?, body: [String: Any], queryParams: [String : Any]?) {
        self.path = path
        self.method = method
        self.pathParams = pathParams
        self.body = try? JSONSerialization.data(withJSONObject: body, options: [])
        self.queryParams = queryParams
    }

    init(path: String, method: HttpMethods, pathParams: [Any]?, body: Encodable, queryParams: [String : Any]?) {
        self.path = path
        self.method = method
        self.pathParams = pathParams
        self.body = try? JSONEncoder().encode(body)
        self.queryParams = queryParams
    }
}

enum NetworkResponse<T: Decodable> {
    case success(T)
    case error(CoreModel)
}

struct CoreModel: Codable {
    let success: Bool?
    var statusCode: Int?
    let statusMessage: String?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }

    var errorMessage: String {
        statusMessage ?? "Local Error"
    }
}

