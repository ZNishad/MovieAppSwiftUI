//
//  SegmentView.swift
//  MovieAppSwiftUI
//
//  Created by Nishad Zulfuqarli on 22.06.26.
//

import SwiftUI

struct MainSegmentView: View {
    var body: some View {

        VStack {
            segmentView
            movieGridView
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onChange(of: selectedSegment) { _, newValue in
            segmentManager.selectSegment(newValue)
        }
        .onChange(of: shouldRefresh) { _, newValue in
            if newValue {
                segmentManager.nowPlayingVM.movieModel = []
                segmentManager.nowPlayingVM.getMovies()
                segmentManager.currentSegment = 0
                selectedSegment = 0
            }
        }

    }

    @Binding var shouldRefresh: Bool

    @StateObject private var segmentManager = MainSegmentManager()

    @State private var selectedSegment: Int = 0

    private let segmentLabel: [String] = ["Now playing", "Upcoming", "Top Rated", "Popular"]

    @Namespace private var SegmentAnimation

    let column = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
}

extension MainSegmentView {
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
                        .onTapGesture {
                            selectedSegment = index
                        }
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

    }

    @ViewBuilder
    private var movieGridView: some View {
        if segmentManager.isLoading {
            ProgressView()
                .tint(.white)
                .frame(maxWidth: .infinity)
                .padding(.top, 50)
        } else {
            LazyVGrid(columns: column, spacing: 13) {
                ForEach(Array(segmentManager.currentMovieList.enumerated()), id: \.offset) { index, movie in
                    NavigationLink(destination: DetailView(movie: movie)) {
                        AsyncImage(url: URL(string: movie.posterFullPath ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.7)
                        }
                        .aspectRatio(2/3, contentMode: .fit)
                        .cornerRadius(12)
                    }
                    .onAppear {
                        if index == segmentManager.currentMovieList.count - 1 {
                            segmentManager.loadNextPage()
                        }
                    }
                }
            }
            .padding()
        }
    }
}
