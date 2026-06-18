//
//  TestProjectTests.swift
//  TestProjectTests
//
//  Created by Nishad Zulfuqarli on 09.06.26.
//

import XCTest
@testable import MovieAppSwiftUI

final class NowPlayingViewModelTests: XCTestCase {

    var viewModel: NowPlayingViewModel!

    override func setUp() {
        super.setUp()
        viewModel = NowPlayingViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testMovieListIsEmptyInitially() {
        XCTAssertTrue(viewModel.movieModel.isEmpty)
    }

    func testIsLoadingIsFalseInitially() {
        XCTAssertFalse(viewModel.isLoading)
    }

    func testGetMoviesLoadsData() async {
        // Given
        let expectation = XCTestExpectation(description: "Movies loaded")

        // When
        viewModel.getMovies()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertFalse(self.viewModel.movieModel.isEmpty)
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 5)
    }
}
