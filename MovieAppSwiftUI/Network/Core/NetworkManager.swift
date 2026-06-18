//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Nishad Zulfuqarli on 02.02.25.
//

import Foundation

class NetworkManager {
    private let urlToken: String = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMDZhZGJhYzc5MzNiZGVlYjcxY2NlZjM1NWQzN2ZhYiIsIm5iZiI6MTczNjkzNzc3NS4yODgsInN1YiI6IjY3ODc5MTJmOWM2YzM3OTg3YjdhZjhhYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Qj5cQwrYlRSFy9qfiqrjLO55FeGtkneUjpCEylczgtI"

    static let shared = NetworkManager()

    private init() { }

    func request<T>(model: NetworkRequestModel, completion: @escaping (NetworkResponse<T>) -> Void) {
        DispatchQueue.global().async {
            guard let urlRequest = self.getUrlRequest(model: model) else { return }
            URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
                let httpResponse = response as? HTTPURLResponse
                if let data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
                       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        print(String(decoding:jsonData, as: UTF8.self))
                    } else {
                        print("json data malformed")
                    }
                    if let model = try? JSONDecoder().decode(T.self, from: data) {
                        DispatchQueue.main.async {
                            completion(.success(model))
                        }
                        return
                    }
                }
                DispatchQueue.main.async {
                    completion(.error(CoreModel(
                        success: false,
                        statusCode: httpResponse?.statusCode,
                        statusMessage: "")))
                }
            }).resume()
        }
    }

    private func getUrlRequest(model: NetworkRequestModel) -> URLRequest? {
        guard let url = URL(string: getPath(model: model)) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(urlToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.httpMethod = model.method.rawValue
        urlRequest.httpBody = model.body
        return urlRequest
    }

    private func getPath(model: NetworkRequestModel) -> String {
        var path = "https://api.themoviedb.org/3" + model.path
        if let pathParams = model.pathParams {
            for i in pathParams {
                path += "/\(i)"
            }
        }
        if let queryParams = model.queryParams, !queryParams.isEmpty {
            let query = queryParams.compactMap({
                guard let encodedValue = percentEncoded("\($0.value)") else { return nil }
                return "\($0.key)=\(encodedValue)"
            }).joined(separator: "&")
            path += "?\(query)"
        }
        return path
    }

    private func percentEncoded(_ value: String) -> String? {
        let string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghiklmnopqrstuvwxyz0123456789%"
        let characterSet = CharacterSet(charactersIn: string)
        return value.addingPercentEncoding(withAllowedCharacters: characterSet)
    }
}
