// MockCoreDataService.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation
@testable import MovieMVVM

/// Мок сервис работы с БД
final class MockCoreDataService: CoreDataServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let idNumber = 0
        static let emptyText = ""
        static let voteAverageNumber = 0.0
        static let voteCountNumber = 0
    }

    // MARK: - Private Property

    private var mockMovies = [Movie(
        id: Constants.idNumber,
        overview: Constants.emptyText,
        posterPath: Constants.emptyText,
        releaseDate: Constants.emptyText,
        title: Constants.emptyText,
        voteAverage: Constants.voteAverageNumber,
        voteCount: Constants.voteCountNumber
    )]

    // MARK: - Public Methods

    func getData(category: String) -> [Movie]? {
        mockMovies
    }

    func saveData(_ data: [Movie], category: String) {
        mockMovies = data
    }
}
