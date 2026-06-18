//
//  SegmentViewModelProtocol.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 08.06.26.
//

import Foundation

protocol SegmentViewModelProtocol: ObservableObject {
    
    var movieModel: [MovieModel] { get set }
    var isLoading: Bool { get set }
    var page: Int { get set }
    var errorMessage: String { get set}

    func getMovies()
    func loadNextPage()
}
