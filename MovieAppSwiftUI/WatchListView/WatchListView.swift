//
//  WatchListView.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 21.05.26.
//

import SwiftUI

struct WatchListView: View {
    var body: some View {
        
        emptyViewCondition

    }
    @StateObject var watchListViewModel = WatchListViewModel()
}

// MARK: - Views
extension WatchListView {

    @ViewBuilder
    private var emptyViewCondition: some View {
        VStack(spacing: 12) {
            if watchListViewModel.movieList.isEmpty {
                emptyView
            } else {
                resultsView
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 18)
        .background(Color.mainBackground)
        .onAppear {
            watchListViewModel.watchListMovie()
        }
        .navigationTitle("Watch List")
        .navigationBarTitleDisplayMode(.inline)

    }

    @ViewBuilder
    private var emptyView: some View {
        Spacer()
        Image(.emptyWishlist)
            .resizable()
            .scaledToFill()
            .frame(width: 250, height: 190, alignment: .center)
        Spacer()
    }

    @ViewBuilder
    private var resultsView: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 18) {
                ForEach(Array(watchListViewModel.movieList.enumerated()), id: \.offset) { index, model in
                    movieRow(model: model, index: index)
                }

                if watchListViewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .tint(.white)
                            .padding()
                        Spacer()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .refreshable {
            await loadData()
        }
    }


    @ViewBuilder
    private func movieRow(model: MovieModel, index: Int) -> some View {
        NavigationLink(destination: DetailView(movie: model)) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: model.posterFullPath ?? "")) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.7)
                }
                .frame(width: 125, height: 175)
                .cornerRadius(12)

                VStack(alignment: .leading) {
                    Text(model.title ?? "")
                        .foregroundStyle(.white)
                        .font(.system(size: 18))

                    Spacer()

                    HStack(spacing: 8) {
                        Image(systemName: "star")
                            .resizable()
                            .scaledToFill()
                            .foregroundStyle(.orange)
                            .frame(width: 15, height: 15)

                        Text(String(model.voteAverage ?? 0).prefix(3))
                            .font(.system(size: 14))
                            .foregroundStyle(.orange)

                        Spacer()
                    }

                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .resizable()
                            .scaledToFill()
                            .foregroundStyle(.orange)
                            .frame(width: 15, height: 15)

                        Text(String(model.releaseDate ?? "0"))
                            .font(.system(size: 14))
                            .foregroundStyle(.white)

                        Spacer()
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .onAppear {
            if index == watchListViewModel.movieList.count - 1 {
                watchListViewModel.loadNextPage()
            }
        }
    }

    private func loadData() async {
        try? await Task.sleep(for: .seconds(1.2))
//        watchListViewModel.movieList = []
        watchListViewModel.watchListMovie()
    }
}
