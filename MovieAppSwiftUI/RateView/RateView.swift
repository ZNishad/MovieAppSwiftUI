//
//  RateView.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 22.05.26.
//

import SwiftUI

struct RateView: View {
    var body: some View {
        rateMovie
    }

    let movieId: Int
    @StateObject private var rateViewModel = RateViewModel()
    @State private var rating: Double = 5.0
    @Environment(\.dismiss) private var dismiss
}

// MARK: - Views
extension RateView {
    
    @ViewBuilder
    private var rateMovie: some View {
        VStack(spacing: 24) {
            Text("Rate this movie")
                .font(.system(size: 18, weight: .bold))

            Text(String(format: "%.1f", rating))
                .font(.system(size: 36, weight: .bold))

            Slider(value: $rating, in: 0...10, step: 0.5)
                .tint(.orange)
                .padding(.horizontal)

            Button("OK") {
                rateViewModel.setRating(movieId: movieId, rating: rating)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundStyle(.white)
            .cornerRadius(24)
            .padding(.horizontal)

        }
        .alert(rateViewModel.setRatingSuccessMessage, isPresented: $rateViewModel.showAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
        .padding()
        .presentationDetents([.fraction(0.4)])
    }
}
