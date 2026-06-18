//
//  DetailModelView.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 15.05.26.
//

import Foundation

class DetailViewModel: ObservableObject {

    @Published var movieDetail: MovieDetailsModel? = nil
    @Published var moviewReviews: ReviewModel? = nil
    @Published var movieCast: CastModel? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = ""
    @Published var showAlert: Bool = false
    @Published var addWatchListSuccessMessage: String = ""
    @Published var movieState: Bool = false


    func getMovieDetails(movieId: Int) {
        isLoading = true
        MovieManager.shared.getMovieDetails(movieId: movieId, completion: { [weak self] response in
            guard let self else { return }
            self.isLoading = false
            switch response {
            case .success(let model):
                self.movieDetail = model
            case .error(let model):
                self.errorMessage = model.errorMessage
            }
        })
    }

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

    func addToWatchList(movieType: String = "movie", movieId: Int, isSaved: Bool) {
        isLoading = true
        MovieManager.shared.setToWatchList(movieType: movieType, movieId: movieId, isSaved: isSaved, completion: { [weak self] response in
            guard let self else { return }
            self.isLoading = false
            switch response {
            case .success(_):
                self.addWatchListSuccessMessage = self.movieState ? "Movie added to watch list successfully!": "Movie deleted from watch list successfully!"
                self.showAlert = true
            case .error(let model):
                self.errorMessage = model.errorMessage
            }
        })
    }

    func getMovieState(movieId: Int) {
        isLoading = true
        MovieManager.shared.getMovieState(movieId: movieId, completion: { [weak self] response in
            guard let self else { return }
            self.isLoading = false
            switch response {
            case .success(let model):
                self.movieState = !model.watchlist
            case .error(let model):
                self.errorMessage = model.errorMessage
            }
        })
    }
}
