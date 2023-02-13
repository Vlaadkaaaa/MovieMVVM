// MovieDetailViewModelTests.swift
// Copyright © Vlaadkaaaa. All rights reserved.

@testable import MovieMVVM
import XCTest

/// Тесты для ViewModel экрана конкретного фильма
final class MovieDetailViewModelTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let idCastText = ""
        static let idMovieText = ""
        static let pathText = ""
    }

    // MARK: - Private Property

    private var mockNetworkService: NetworkServiceProtocol?
    private var mockImageService: ImageServiceProtocol?
    private var viewModel: MovieDetailViewModelProtocol?

    // MARK: - Public Methods

    override func setUpWithError() throws {
        mockNetworkService = MockNetworkService()
        mockImageService = MockImageService()
        viewModel = MovieDetailViewModel(networkService: mockNetworkService, imageService: mockImageService)
    }

    override func tearDownWithError() throws {
        mockNetworkService = nil
        mockImageService = nil
        viewModel = nil
    }

    func testFetchCasts() throws {
        viewModel?.fetchCast(id: Constants.idCastText)
        mockNetworkService?.fetchCast(id: Constants.idCastText) { result in
            switch result {
            case let .success(casts):
                XCTAssertNotNil(casts)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
    }

    func testFetchDetail() throws {
        viewModel?.fetchDetail(id: Constants.idMovieText)
        mockNetworkService?.fetchDetail(id: Constants.idMovieText) { result in
            switch result {
            case let .success(casts):
                XCTAssertNotNil(casts)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
    }

    func testFetchImageData() throws {
        viewModel?.fetchImageData(path: Constants.pathText)
        mockImageService?.loadImage(path: Constants.pathText) { result in
            switch result {
            case let .success(data):
                XCTAssertNotNil(data)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
    }
}
