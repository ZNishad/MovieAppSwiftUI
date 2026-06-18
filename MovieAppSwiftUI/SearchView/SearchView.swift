//
//  File.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 21.05.26.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        VStack(spacing: 12) {
            searchFieldView

            if searchViewModel.movieList.isEmpty {
                emptyView
            } else {
                resultsView
            }
        }
        .padding(.horizontal, 18)
        .background(Color.mainBackground)
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                } label: {
                    Image(systemName: "info")
                        .foregroundStyle(.white)
                }
            }
        }
//        .onDisappear {
//            searchText = ""
//            searchViewModel.movieList = []
//        }
    }

    @State private var searchText: String = ""
    @StateObject var searchViewModel = SearchViewModel()
}

// MARK: - Views
extension SearchView {

    @ViewBuilder
    private var searchFieldView: some View {
        TextField("", text: $searchText, prompt: Text("Search").foregroundColor(.gray))
            .padding()
            .background(Color(.textFieldBackground))
            .cornerRadius(16)
            .foregroundStyle(.white)
            .overlay(alignment: .trailing) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                    .padding(.trailing, 18)
                    .onTapGesture {
                        searchViewModel.getSearchMovieList(search: searchText)
                    }
            }
            .onSubmit {
                searchViewModel.getSearchMovieList(search: searchText)
            }
    }

    @ViewBuilder
    private var emptyView: some View {
        Spacer()
        Image(.searchCantBeFound)
            .resizable()
            .scaledToFill()
            .frame(width: 250, height: 190, alignment: .center)
        Spacer()
    }

    @ViewBuilder
    private var resultsView: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 18) {
                ForEach(Array(searchViewModel.movieList.enumerated()), id: \.offset) { index, model in
                    movieRow(model: model, index: index)
                }

                if searchViewModel.isLoading {
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
            if index == searchViewModel.movieList.count - 1 {
                searchViewModel.loadNextPage(search: searchText)
            }
        }
    }
}
