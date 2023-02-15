// MockNetworkService.swift
// Copyright © Vlaadkaaaa. All rights reserved.

@testable import MovieMVVM
import UIKit

/// Мок сервис работы с сетью
final class MockNetworkService: NetworkServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let idNumber = 0
        static let emptyText = ""
        static let voteAverageNumber = 0.0
        static let voteCountNumber = 0
        static let totalNumber = 10
    }

    // MARK: - Private Property

    private var mockMovies = Movies(page: 0, movies: [Movie(
        id: Constants.idNumber,
        overview: Constants.emptyText,
        posterPath: Constants.emptyText,
        releaseDate: Constants.emptyText,
        title: Constants.emptyText,
        voteAverage: Constants.voteAverageNumber,
        voteCount: Constants.voteCountNumber
    )], totalPages: Constants.totalNumber, totalResults: Constants.totalNumber)

    private var mockCasts = Casts(
        id: Constants.idNumber,
        cast: [Cast(name: Constants.emptyText, profilePath: Constants.emptyText, character: Constants.emptyText)]
    )

    private var mockMovieDetail = MovieDetail(genres: [Genre(name: Constants.emptyText)])

    // MARK: - Public Methods

    func fetchMovies(
        category: MovieCategory?,
        page: Int,
        completion: @escaping (Result<Movies, Error>) -> Void
    ) {
        completion(.success(mockMovies))
    }

    func fetchCast(id: String, completion: @escaping (Result<Casts, Error>) -> Void) {
        completion(.success(mockCasts))
    }

    func fetchDetail(id: String, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        completion(.success(mockMovieDetail))
    }
}
