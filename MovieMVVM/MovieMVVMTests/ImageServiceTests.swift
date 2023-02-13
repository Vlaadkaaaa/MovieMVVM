// ImageServiceTests.swift
// Copyright © Vlaadkaaaa. All rights reserved.

@testable import MovieMVVM
import XCTest

/// Тесты для сервиса работы с изображениями
final class ImageServiceTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let mockText = "movie"
        static let mockNumber = 20
    }

    // MARK: - Private Property

    private var mockProxy: ProxyProtocol?
    private var imageService: ImageServiceProtocol?

    override func setUpWithError() throws {
        mockProxy = MockProxy()
        guard let mockProxy else { return }
        imageService = ImageService(proxy: mockProxy)
    }

    override func tearDownWithError() throws {
        mockProxy = nil
        imageService = nil
    }

    func testLoadImage() {
        imageService?.loadImage(path: Constants.mockText) { result in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, Data(count: Constants.mockNumber))
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
    }
}
