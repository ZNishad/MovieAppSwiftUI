//
//  SearchViewModel.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 21.05.26.
//

import Foundation

class SearchViewModel: ObservableObject {

    @Published var movieList: [MovieModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var page: Int = 1

    func getSearchMovieList(search: String) {
        isLoading = true
        MovieManager.shared.searchMovie(page: 1, searchString: search, completion: { [weak self] response in
            guard let self else { return }
            self.isLoading = false
            switch response {
            case .success(let model):
                page = self.page
                self.movieList = model.results ?? []
            case .error(let model):
                self.errorMessage = model.errorMessage
            }
        })
    }

    func loadNextPage (search: String) {
        page += 1
        isLoading = true
        MovieManager.shared.searchMovie(page: page, searchString: search, completion: { [weak self] response in
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
