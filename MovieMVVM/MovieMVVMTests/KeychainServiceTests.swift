// KeychainServiceTests.swift
// Copyright © Vlaadkaaaa. All rights reserved.

@testable import MovieMVVM
import XCTest

/// Тесты для сервиса Keychain
final class KeychainServiceTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let mockValue = "mock"
        static let personalApiKeyText = "apiKey"
    }

    // MARK: - Private Properties

    private var keychainService: KeychainServiceProtocol?

    // MARK: - Public Methods

    override func setUpWithError() throws {
        try super.setUpWithError()
        keychainService = KeychainService()
    }

    override func tearDownWithError() throws {
        keychainService = nil
    }

    func testKeychainService() {
        keychainService?.saveKey(name: Constants.mockValue)
        let fetchKey = keychainService?.fetchKey(name: Constants.personalApiKeyText)
        XCTAssertNotNil(fetchKey)
        guard let key = fetchKey else { return }
        XCTAssertEqual(Constants.mockValue, key)
    }
}
