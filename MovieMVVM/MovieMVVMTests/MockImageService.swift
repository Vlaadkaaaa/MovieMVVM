// MockImageService.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation
@testable import MovieMVVM

/// Мок сервис получения изображения
final class MockImageService: ImageServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let mockText = "movie"
        static let mockNumber = 20
    }

    // MARK: - Public Property

    func loadImage(path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard Constants.mockText == path else { return }
        let data = Data(count: Constants.mockNumber)
        completion(.success(data))
    }
}
