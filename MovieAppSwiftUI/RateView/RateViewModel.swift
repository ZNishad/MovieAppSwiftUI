//
//  RateViewModel.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 22.05.26.
//

import Foundation

class RateViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var setRatingSuccessMessage: String = ""
    @Published var showAlert: Bool = false

    func setRating(movieId: Int, rating: Double) {
        isLoading = true
        MovieManager.shared.setRating(movieId: movieId, rating: rating, completion: { [weak self] response in
            guard let self else { return }
            self.isLoading = false
            switch response {
            case .success(_):
                self.setRatingSuccessMessage = "Rating submitted successfully!"
                self.showAlert = true
            case .error(let model):
                self.errorMessage = model.errorMessage
            }
        })
    }
}
