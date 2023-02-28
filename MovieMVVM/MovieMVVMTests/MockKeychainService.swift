// MockKeychainService.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation
@testable import MovieMVVM

/// Мок сервис Keychain
final class MockKeychainService: KeychainServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let mockText = "mock"
    }

    // MARK: - Private Property

    private var keyValue: String?

    // MARK: - Public Methods

    func saveKey(name: String) {
        keyValue = name
    }

    func fetchKey(name: String) -> String {
        Constants.mockText
    }
}
