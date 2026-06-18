//
//  MainSegmentManager.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 08.06.26.
//

import Foundation
import Combine

class MainSegmentManager: ObservableObject {
    @Published var currentSegment: Int = 0

    let nowPlayingVM = NowPlayingViewModel()
    let upComingVM = UpcomingViewModel()
    let topRatedVM = TopRatedViewModel()
    let popularVM = PopularViewModel()

    private var cancellables = Set<AnyCancellable>()

    init() {
        [nowPlayingVM.objectWillChange,
         upComingVM.objectWillChange,
         topRatedVM.objectWillChange,
         popularVM.objectWillChange].forEach { publisher in
            publisher
                .sink { [weak self] _ in self?.objectWillChange.send() }
                .store(in: &cancellables)
        }

        nowPlayingVM.getMovies()
    }

    var currentMovieList: [MovieModel] {
        switch currentSegment {
        case 0: return nowPlayingVM.movieModel
        case 1: return upComingVM.movieModel
        case 2: return topRatedVM.movieModel
        case 3: return popularVM.movieModel
        default: return []
        }
    }

    func selectSegment(_ index: Int) {
        currentSegment = index
        switch index {
        case 0: nowPlayingVM.getMovies()
        case 1: upComingVM.getMovies()
        case 2: topRatedVM.getMovies()
        case 3: popularVM.getMovies()
        default: break
        }
    }

    func loadNextPage() {
        switch currentSegment {
        case 0: nowPlayingVM.loadNextPage()
        case 1: upComingVM.loadNextPage()
        case 2: topRatedVM.loadNextPage()
        case 3: popularVM.loadNextPage()
        default: break
        }
    }

    var isLoading: Bool {
        switch currentSegment {
        case 0: return nowPlayingVM.isLoading
        case 1: return upComingVM.isLoading
        case 2: return topRatedVM.isLoading
        case 3: return popularVM.isLoading
        default: return false
        }
    }
}
