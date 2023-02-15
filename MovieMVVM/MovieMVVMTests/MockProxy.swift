// MockProxy.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation
@testable import MovieMVVM

/// Мок прокси
final class MockProxy: ProxyProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let mockText = "movie"
        static let mockNumber = 20
    }

    // MARK: - Public Methods

    func getImage(path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard Constants.mockText == path else { return }
        let data = Data(count: Constants.mockNumber)
        completion(.success(data))
    }
}
