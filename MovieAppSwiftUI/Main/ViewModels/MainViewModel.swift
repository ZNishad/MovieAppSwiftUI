//
//  File.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 13.05.26.
//

import Foundation

class MainViewModel: ObservableObject {

    @Published var topFiveMovie: [MovieModel] = []

    @Published var isLoading: Bool = false

    @Published var errorMessage: String? = nil

    func getTopRatedMovieList() {
        isLoading = true
        MovieManager.shared.getTopRated(page: 1) { [weak self] response in
            guard let self else { return }
            self.isLoading = false
            switch response {
            case .success(let model):   
                self.topFiveMovie = Array((model.results ?? []).prefix(5))
            case .error(let model):
                self.errorMessage = model.errorMessage
            }
        }
    }
}
