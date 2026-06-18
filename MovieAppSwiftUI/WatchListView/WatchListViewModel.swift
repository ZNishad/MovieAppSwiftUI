//
//  WatchListViewModel.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 21.05.26.
//

import Foundation

class WatchListViewModel: ObservableObject {
    @Published var movieList: [MovieModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var page: Int = 1


    func watchListMovie() {
        page = 1
        isLoading = true
        MovieManager.shared.getWatchListMovie(page: page, completion: { [weak self] response in
            guard let self else { return }
            self.isLoading = false
            switch response {
            case .success(let model):
                self.page = model.page ?? 0
                self.movieList = model.results ?? []
            case .error(let model):
                self.errorMessage = model.errorMessage
            }
        })
    }

    func loadNextPage() {
        page += 1
        isLoading = true
        MovieManager.shared.getWatchListMovie(page: page, completion: { [weak self] response in
            guard let self else { return }
            self.isLoading = false
            switch response {
            case .success(let model):
                self.movieList += model.results ?? []
            case .error(let model):
                self.errorMessage = model.errorMessage
            }

        })
    }

}
