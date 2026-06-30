//
//  NowPlayingViewModel.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 08.06.26.
//

import Foundation

class NowPlayingViewModel: SegmentViewModelProtocol {
    @Published var movieModel: [MovieModel] = []

    @Published var isLoading: Bool = false

    var page: Int = 1

    var errorMessage: String = ""

    func getMovies() {
        guard movieModel.isEmpty else { return }
        isLoading = true
        MovieManager.shared.getNowPlaying(page: 1) { [weak self] response in
            guard let self else { return }
            self.isLoading = false
            switch response {
            case .success(let model):
                self.page = model.page ?? 1
                self.movieModel = model.results ?? []
            case .error(let model):
                self.errorMessage = model.errorMessage
            }
        }
    }

    func loadNextPage() {
            MovieManager.shared.getNowPlaying(page: page + 1) { [weak self] response in
                guard let self else { return }
                switch response {
                case .success(let model):
                    self.page = model.page ?? self.page
                    self.movieModel += model.results ?? []
                case .error(let model):
                    self.errorMessage = model.errorMessage
                }
            }
        }


}
