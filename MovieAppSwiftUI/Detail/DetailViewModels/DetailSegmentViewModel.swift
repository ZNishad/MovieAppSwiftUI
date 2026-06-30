//
//  DetailSegmentViewModel.swift
//  MovieAppSwiftUI
//
//  Created by Nishad Zulfuqarli on 30.06.26.
//

import Foundation

class DetailSegmentViewModel: ObservableObject {
    @Published var moviewReviews: ReviewModel? = nil
    @Published var movieCast: CastModel? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    func getMovieReviews(movieId: Int) {
        isLoading = true
        MovieManager.shared.getMovieRevies(movieId: movieId, completion: { [weak self] response in
            guard let self else { return }
            self.isLoading = false
            switch response {
            case .success(let model):
                self.moviewReviews = model
            case .error(let model):
                self.errorMessage = model.errorMessage
            }
        })
    }

    func getMovieCasts(movieId: Int) {
        isLoading = true
        MovieManager.shared.getMovieCastList(movieId: movieId, completion: { [weak self] response in
            guard let self else { return }
            self.isLoading = false
            switch response {
            case .success(let model):
                self.movieCast = model
            case .error(let model):
                self.errorMessage = model.errorMessage
            }
        })
    }
}
