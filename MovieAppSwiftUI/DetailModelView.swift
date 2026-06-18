//
//  DetailModelView.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 15.05.26.
//

import Foundation
import SwiftUI

class DetailViewModel: ObservableObject {

    @Published var movieDetail: MovieDetailsModel? = nil
    @Published var moviewReviews: ReviewModel? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = ""


    func getMovieDetails(movieId: Int) {
        isLoading = true
        MovieManager.shared.getMovieDetails(movieId: movieId, completion: { [weak self] response in
            guard let self else { return }
            isLoading = false
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
            isLoading = false
            switch response {
            case .success(let model):
                self.moviewReviews = model
            case .error(let model):
                self.errorMessage = model.errorMessage
            }
        })
    }
}
