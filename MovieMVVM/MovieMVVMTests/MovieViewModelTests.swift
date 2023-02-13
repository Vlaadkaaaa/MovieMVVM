// MovieViewModelTests.swift
// Copyright © Vlaadkaaaa. All rights reserved.

@testable import MovieMVVM
import XCTest

/// Тесты для ViewModel главного экрана
final class MovieViewModelTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let idNumber = 0
        static let overviewText = ""
        static let posterPathText = ""
        static let releaseDateText = ""
        static let titleText = ""
        static let voteAverageNumber = 0.0
        static let voteCoubtNumber = 0
        static let apiKeyText = "mock"
        static let personalApiKeyText = "apiKey"
    }

    // MARK: - Private Property

    private var mockNetworkService: NetworkServiceProtocol?
    private var mockImageService: ImageServiceProtocol?
    private var mockCoreDataService: CoreDataServiceProtocol?
    private var mockKeychainService: KeychainServiceProtocol?
    private var viewModel: MovieViewModelProtocol?

    // MARK: - Public Methods

    override func setUpWithError() throws {
        mockNetworkService = MockNetworkService()
        mockImageService = MockImageService()
        mockCoreDataService = MockCoreDataService()
        mockKeychainService = MockKeychainService()
        guard let mockNetworkService else { return }
        viewModel = MovieViewModel(
            networkService: mockNetworkService,
            imageService: mockImageService,
            coreDataService: mockCoreDataService,
            keychainService: mockKeychainService
        )
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testUpdateApiKey() {
        viewModel?.updateApiKey(Constants.apiKeyText)
        let fetchKey = mockKeychainService?.fetchKey(name: Constants.personalApiKeyText)
        XCTAssertNotNil(fetchKey)
        XCTAssertEqual(Constants.apiKeyText, fetchKey)
    }

    func testCheckApiKey() {
        viewModel?.checkApiKey {
            guard let fetchKey = mockKeychainService?.fetchKey(name: Constants.personalApiKeyText) else { return }
            XCTAssertTrue(!fetchKey.isEmpty)
        }
    }

    func testCategory() {
        viewModel?.setupCategory(choose: 0)
        XCTAssertEqual(viewModel?.currentCategory, .popular)
        viewModel?.setupCategory(choose: 1)
        XCTAssertEqual(viewModel?.currentCategory, .upcoming)
        viewModel?.setupCategory(choose: 2)
        XCTAssertEqual(viewModel?.currentCategory, .topRated)
    }
}
