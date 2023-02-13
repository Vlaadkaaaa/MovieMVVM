// NetworkServiceTests.swift
// Copyright © Vlaadkaaaa. All rights reserved.

@testable import MovieMVVM
import XCTest

/// Тесты для сервиса работы с сетью
final class NetworkServiceTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let idText = "123"
        static let pageNumber = 0
    }

    // MARK: - Private Property

    private var mockNetworkService: NetworkServiceProtocol?

    // MARK: - Public Methods

    override func setUpWithError() throws {
        mockNetworkService = MockNetworkService()
    }

    override func tearDownWithError() throws {
        mockNetworkService = nil
    }

    func testFetchDetail() {
        mockNetworkService?.fetchDetail(id: Constants.idText) { result in
            switch result {
            case let .success(detail):
                XCTAssertNotNil(detail)
            case let .failure(error):
                XCTAssertNotNil(error)
            }
        }
    }

    func testFetchCast() {
        mockNetworkService?.fetchCast(id: Constants.idText) { result in
            switch result {
            case let .success(casts):
                XCTAssertNotNil(casts)
            case let .failure(error):
                XCTAssertNotNil(error)
            }
        }
    }

    func testFecthMovies() {
        mockNetworkService?.fetchMovies(category: .topRated, page: Constants.pageNumber) { result in
            switch result {
            case let .success(movies):
                XCTAssertNotNil(movies)
                XCTAssertEqual(movies.page, Constants.pageNumber)
            case let .failure(error):
                XCTAssertNotNil(error)
            }
        }
    }
}
