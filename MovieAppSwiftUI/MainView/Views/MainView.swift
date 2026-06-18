//
//  MainView.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 13.05.26.
//

import SwiftUI

struct MainView: View {

    @State private var searchText: String = ""

    @StateObject private var mainViewModel = MainViewModel()

    @StateObject private var segmentManager = MainSegmentManager()

    let column = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    @State private var selectedMovie: MovieModel? = nil

    @State private var selectedSegment: Int = 0

    @Namespace private var SegmentAnimation

    private let segmentLabel: [String] = ["Now playing", "Upcoming", "Top Rated", "Popular"]

    @Binding var selectedTab: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                headerView
                searchView
                topFiveView
                segmentView
                movieGridView
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
        .onChange(of: selectedSegment) { _, newValue in
            segmentManager.selectSegment(newValue)
        }
    }
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
//        .overlay(alignment: .trailing) {
//
//        }
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

    private func loadData() async {
        try? await Task.sleep(for: .seconds(1.2))
        mainViewModel.topFiveMovie = []
        segmentManager.nowPlayingVM.movieModel = []
        mainViewModel.getTopRatedMovieList()
        segmentManager.nowPlayingVM.getMovies()
        segmentManager.currentSegment = 0
        selectedSegment = 0
    }
}

extension MovieModel: Identifiable {}
