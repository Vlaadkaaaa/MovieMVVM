// MovieBilderTests.swift
// Copyright © Vlaadkaaaa. All rights reserved.

@testable import MovieMVVM
import XCTest

/// Тесты для сборщика модулей
final class MovieBilderTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let idNumber = 0
        static let overviewText = ""
        static let posterPathText = ""
        static let releaseDateText = ""
        static let titleText = ""
        static let voteAverageNumber = 0.0
        static let voteCoubtNumber = 0
    }

    // MARK: - Private Property

    private var movieBilder: BilderProtocol?
    private var mockMovie = Movie(
        id: Constants.idNumber,
        overview: Constants.overviewText,
        posterPath: Constants.posterPathText,
        releaseDate: Constants.releaseDateText,
        title: Constants.titleText,
        voteAverage: Constants.voteAverageNumber,
        voteCount: Constants.voteCoubtNumber
    )

    // MARK: - Public Methods

    override func setUpWithError() throws {
        movieBilder = Bilder()
    }

    override func tearDownWithError() throws {
        movieBilder = nil
    }

    func testMovieScreen() {
        let movieVC = movieBilder?.createMainModule()
        XCTAssertTrue(movieVC is MovieViewController)
    }

    func testMovieDetailScreen() {
        let detailVC = movieBilder?.createDetailModule(movie: mockMovie)
        XCTAssertTrue(detailVC is MovieDetailViewController)
    }
}
