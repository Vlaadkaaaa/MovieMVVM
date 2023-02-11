// KeychainService.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import KeychainSwift

/// Менеджер работы с критическими данными
final class KeychainService: KeychainServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let personalApiKeyText = "apiKey"
        static let errorText = "Ошибка получения"
    }

    // MARK: - Private Property

    private let keychain = KeychainSwift()

    // MARK: - Public Methods

    func saveKey(name: String) {
        keychain.set(name, forKey: Constants.personalApiKeyText)
    }

    func fetchKey(name: String) -> String {
        keychain.get(name) ?? Constants.errorText
    }
}
