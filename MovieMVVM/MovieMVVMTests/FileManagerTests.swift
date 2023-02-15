// FileManagerTests.swift
// Copyright © Vlaadkaaaa. All rights reserved.

@testable import MovieMVVM
import XCTest

/// Тесты для сервиса кеширования изображений
final class FileManagerTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let mockText = "movie"
        static let mockNumber = 20
    }

    // MARK: - Private Property

    private var fileManager: FileManagerProtocol?

    // MARK: - Public Method

    override func setUpWithError() throws {
        try super.setUpWithError()
        fileManager = FileManagerService()
    }

    override func tearDownWithError() throws {
        fileManager = nil
    }

    func testSaveImage() {
        let mockData = Data(count: Constants.mockNumber)
        fileManager?.saveImageToFile(url: Constants.mockText, data: mockData)
        let data = fileManager?.getImageDataFromDisk(url: Constants.mockText)
        XCTAssertEqual(data, mockData)
    }
}
