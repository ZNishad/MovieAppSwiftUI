//
//  DetailView.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 14.05.26.
//

import SwiftUI

struct DetailView: View {
    let movie: MovieModel

    private let screenHeight = UIScreen.main.bounds.height

    @StateObject private var detailViewModel = DetailViewModel()

    @StateObject private var detailSegmentViewModel = DetailSegmentViewModel()

    @State private var showRateView = false


    var body: some View {
        ScrollView {
            backdropView
            infoView
            DetailSegmentView(movieId: movie.id ?? 0, detailViewModel: detailViewModel, detailSegmentViewModel: detailSegmentViewModel)

            Spacer()
        }
        .background(Color.mainBackground.ignoresSafeArea())
        .frame(maxHeight: .infinity)
        .onAppear {
            detailViewModel.getMovieDetails(movieId: movie.id ?? 0)
            detailViewModel.getMovieState(movieId: movie.id ?? 0)
            detailSegmentViewModel.getMovieReviews(movieId: movie.id ?? 0)
            detailSegmentViewModel.getMovieCasts(movieId: movie.id ?? 0)
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    detailViewModel.addToWatchList(movieId: movie.id ?? 0, isSaved: detailViewModel.movieState)

                } label: {
                    Image(systemName: detailViewModel.movieState ? "bookmark" : "bookmark.fill")
                        .foregroundStyle(.white)
                }
            }
            
        }
        .alert(detailViewModel.addWatchListSuccessMessage, isPresented: $detailViewModel.showAlert) {
            Button("OK", role: .cancel) {
                detailViewModel.getMovieState(movieId: movie.id ?? 0)
            }
        }
        .sheet(isPresented: $showRateView) {
            RateView(movieId: movie.id ?? 0)
        }
        .refreshable {
            await loadData()
        }
    }


}

// MARK: - Views
extension DetailView {

    @ViewBuilder
    private var backdropView: some View {
        VStack(spacing: 0) {
            ZStack {
                AsyncImage(url: URL(string: detailViewModel.movieDetail?.backdropFullPath ?? "")) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.7)
                }
                .frame(maxWidth: .infinity)
                .frame(height: screenHeight * 0.27)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.orange)
                    Text(String(format: "%.1f", detailViewModel.movieDetail?.voteAverage ?? 0))
                        .foregroundStyle(.orange)
                        .font(.system(size: 14, weight: .bold))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.6))
                .cornerRadius(8)
                .padding(12)
                .offset(x: 160, y: 80)
                .onTapGesture { showRateView = true }
            }

            HStack(alignment: .top) {
                AsyncImage(url: URL(string: detailViewModel.movieDetail?.posterFullPath ?? "")) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 100, height: 140)
                .cornerRadius(12)
                .offset(y: -70)

                Text(detailViewModel.movieDetail?.title ?? "")
                    .font(.system(size: 26))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .bold()
                    .minimumScaleFactor(0.7)
                    .padding(.leading, 12)
                    .padding(.vertical, 12)
                    .frame(height: 80)

                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }

    @ViewBuilder
    private var infoView: some View {
        HStack(spacing: 16) {
            infoItem(icon: "calendar", text: String(detailViewModel.movieDetail?.releaseDate?.prefix(4) ?? ""))
            Rectangle().frame(width: 1, height: 20).foregroundStyle(.gray)
            infoItem(icon: "clock", text: String(detailViewModel.movieDetail?.runtime ?? 0) + "minutes")
            Rectangle().frame(width: 1, height: 20).foregroundStyle(.gray)
            infoItem(icon: "square.stack", text: String(detailViewModel.movieDetail?.genres?.first?.name ?? ""))
        }
        .padding(.horizontal, 18)
        .offset(y: -65)
    }

    private func infoItem(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).foregroundStyle(.gray)
            Text(text).foregroundStyle(.gray).font(.system(size: 14))
        }
    }

    private func loadData() async {
        try? await Task.sleep(for: .seconds(1.2))
        detailViewModel.movieDetail = nil
        detailViewModel.getMovieDetails(movieId: movie.id ?? 0)
        detailViewModel.getMovieState(movieId: movie.id ?? 0)
        detailSegmentViewModel.moviewReviews = nil
        detailSegmentViewModel.movieCast = nil
        detailSegmentViewModel.getMovieReviews(movieId: movie.id ?? 0)
        detailSegmentViewModel.getMovieCasts(movieId: movie.id ?? 0)
    }
}
