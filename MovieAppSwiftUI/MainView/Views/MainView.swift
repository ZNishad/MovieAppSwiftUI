//
//  MainView.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 13.05.26.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                headerView
                searchView
                topFiveView
                SegmentView(shouldRefresh: $refreshSegment)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.mainBackground.ignoresSafeArea())
        .onAppear {
            mainViewModel.getTopRatedMovieList()
        }
        .refreshable {
            await loadData()
        }
    }

    @State private var refreshSegment: Bool = false

    @State private var searchText: String = ""

    @StateObject private var mainViewModel = MainViewModel()

    @State private var selectedMovie: MovieModel? = nil

    @Namespace private var SegmentAnimation

    private let segmentLabel: [String] = ["Now playing", "Upcoming", "Top Rated", "Popular"]

    @Binding var selectedTab: Int

}

extension MainView {

    @ViewBuilder
    private var headerView: some View {
        Text("What do you want to watch?")
            .font(.system(size: 24))
            .foregroundStyle(.white)
            .bold()
            .padding(.leading, 18)
    }

    @ViewBuilder
    private var searchView: some View {
        HStack {
            TextField("", text: $searchText, prompt: Text("Search").foregroundColor(.gray))
                .allowsHitTesting(false)
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
        }
        .padding()
        .background(Color(.textFieldBackground))
        .cornerRadius(16)
        .foregroundStyle(.white)
        .padding(.horizontal, 18)
        .onTapGesture {
            selectedTab = 1
        }
    }

    @ViewBuilder
    private var topFiveView: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(Array(mainViewModel.topFiveMovie.enumerated()), id: \.offset) { index, movie in
                    NavigationLink(destination: DetailView(movie: movie)) {
                        ZStack(alignment: .bottomLeading) {
                            AsyncImage(url: URL(string: movie.posterFullPath ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(width: 150, height: 210)
                            .cornerRadius(12)

                            StrokeText(
                                text: "\(index + 1)",
                                fontSize: 96,
                                fillColor: .mainBackground,
                                strokeColor: .strokeText,
                                strokeWidth: -1
                            )
                            .frame(width: 80, height: 100)
                            .offset(x: -15, y: 20)
                        }
                    }
                }
            }
            .padding(.horizontal, 18)
        }
        .scrollIndicators(.hidden)
        .frame(height: 230)
    }

    private func loadData() async {
        try? await Task.sleep(for: .seconds(1.2))
        mainViewModel.topFiveMovie = []
        mainViewModel.getTopRatedMovieList()
        refreshSegment.toggle()
    }
}

extension MovieModel: Identifiable {}
