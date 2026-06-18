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

    @Environment(\.dismiss) private var dismiss

    @StateObject private var detailViewModel = DetailViewModel()

    @State private var selectedSegment: Int = 0

    @Namespace private var SegmentAnimation

    private let segmentLabel: [String] = ["About Moview", "Reviews", "Cast"]

    @State private var expandedReviews: Set<String> = []

    let column = [GridItem(.flexible()), GridItem(.flexible())]

    @State private var showRateView = false
    
    var body: some View {
        ScrollView {
            backdropView
            infoView
            segmentView

            switch selectedSegment {
            case 0: aboutMovie
            case 1: reviewsView
            case 2: castView
            default: EmptyView()
            }

            Spacer()
        }
        .background(Color.mainBackground.ignoresSafeArea())
        .frame(maxHeight: .infinity)
        .onAppear {
            detailViewModel.getMovieDetails(movieId: movie.id ?? 0)
            detailViewModel.getMovieReviews(movieId: movie.id ?? 0)
            detailViewModel.getMovieCasts(movieId: movie.id ?? 0)
            detailViewModel.getMovieState(movieId: movie.id ?? 0)
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    detailViewModel.addToWatchList(movieId: movie.id ?? 0, isSaved: detailViewModel.movieState)

                } label: {
                    Image(systemName: "bookmark")
                        .foregroundStyle(detailViewModel.movieState ? .green : .red)
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
                    Image(systemName: "star.fill").foregroundStyle(.orange)
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

    @ViewBuilder
    private var segmentView: some View {
        HStack(spacing: 12) {
            ForEach(Array(segmentLabel.enumerated()), id: \.offset) { index, segment in
                VStack(spacing: 4) {
                    Text(segment)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .font(.system(size: 16))
                        .onTapGesture { selectedSegment = index }

                    if selectedSegment == index {
                        Rectangle()
                            .frame(height: 2)
                            .foregroundStyle(.textFieldBackground)
                            .matchedGeometryEffect(id: "indicator", in: SegmentAnimation)
                    } else {
                        Rectangle()
                            .frame(height: 2)
                            .foregroundStyle(.clear)
                    }
                }
            }
        }
        .padding(.horizontal, 18)
        .animation(.spring(duration: 0.3), value: selectedSegment)
        .offset(y: -50)
    }

    @ViewBuilder
    private var aboutMovie: some View {
        Text(detailViewModel.movieDetail?.overview ?? "")
            .font(.system(size: 14))
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .offset(y: -45)
    }

    @ViewBuilder
    private var reviewsView: some View {
        LazyVStack(spacing: 22) {
            ForEach(detailViewModel.moviewReviews?.results ?? [], id: \.id) { review in
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        AsyncImage(url: URL(string: review.authorDetails.getFullAvatarPath ?? "")) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Image(.defaultAvatar).resizable().scaledToFill()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(.circle)

                        Spacer()

                        Text(String(Double(review.authorDetails.rating ?? 0)))
                            .foregroundStyle(.blue)
                            .font(.system(size: 13))
                            .frame(width: 50, alignment: .center)
                    }
                    .frame(width: 51, height: 71)

                    VStack(alignment: .leading, spacing: 12) {
                        Text(review.author)
                            .foregroundStyle(.white)
                            .font(.system(size: 14, weight: .bold))

                        Text(review.content)
                            .foregroundStyle(.white)
                            .font(.system(size: 13))
                            .lineLimit(expandedReviews.contains(review.id) ? nil : 4)
                            .onTapGesture {
                                withAnimation(.spring(duration: 0.3)) {
                                    if expandedReviews.contains(review.id) {
                                        expandedReviews.remove(review.id)
                                    } else {
                                        expandedReviews.insert(review.id)
                                    }
                                }
                            }
                    }
                    .padding(.leading, 5)

                    Spacer()
                }
            }
        }
        .padding(.horizontal, 18)
        .offset(y: -40)
    }

    @ViewBuilder
    private var castView: some View {
        LazyVGrid(columns: column, spacing: 25) {
            ForEach(detailViewModel.movieCast?.cast ?? [], id: \.id) { casts in
                VStack(spacing: 12) {
                    AsyncImage(url: URL(string: casts.getCastProfileFullPath ?? "")) { image in
                        image.resizable().scaledToFill()
                            .minimumScaleFactor(0.7)
                            .offset(y: 15)
                    } placeholder: {
                        Image(.defaultAvatar).resizable().scaledToFill()
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(.circle)

                    Text(casts.name)
                        .foregroundStyle(.white)
                        .font(.system(size: 18))
                }
            }
        }
        .padding(.horizontal, 18)
        .offset(y: -40)
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
        detailViewModel.getMovieReviews(movieId: movie.id ?? 0)
        detailViewModel.getMovieCasts(movieId: movie.id ?? 0)
        detailViewModel.getMovieState(movieId: movie.id ?? 0)
    }
}
