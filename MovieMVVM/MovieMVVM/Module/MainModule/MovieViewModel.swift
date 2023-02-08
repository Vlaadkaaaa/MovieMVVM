// MovieViewModel.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// ViewModel для главного экрана
final class MovieViewModel: MovieViewModelProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let oneStarImageName = "oneStar"
        static let twoStarImageName = "twoStar"
        static let threeStarImageName = "threeStar"
        static let fourStarImageName = "fourStar"
        static let fiveStarImageName = "fiveStar"
    }

    // MARK: - Public Property

    var updateViewDataHandler: MovieDataHandler?
    var updateMovieCellHandler: MovieDataStringHandler?

    // MARK: - Init

    init(networkService: NetworkServiceProtocol, imageService: ImageServiceProtocol?) {
        self.networkService = networkService
        self.imageService = imageService
    }

    // MARK: - Private Protperty

    private var imageService: ImageServiceProtocol?
    private let networkService: NetworkServiceProtocol?
    private var currentCategory: MovieCategory = .popular

    // MARK: - Public Method

    func fetchMovie() {
        networkService?.fetchMovies(category: currentCategory, page: 1) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(movies):
                self.updateViewDataHandler?(.success(movies.movies))
            case let .failure(error):
                self.updateViewDataHandler?(.failure(error: error))
            }
        }
    }

    func updateMovieCell(_ movie: Movie) {
        updateMovieCellHandler?(movie, fetchMovieImage(path: movie.posterPath), fetchRating(number: movie.voteAverage))
    }

    func setupCategory(chose index: Int) {
        switch index {
        case 0:
            currentCategory = .popular
        case 1:
            currentCategory = .upcoming
        default:
            currentCategory = .topRated
        }
        fetchMovie()
    }

    // MARK: - Private Method

    private func fetchMovieImage(path: String) -> Data {
        var data: Data?
        imageService?.loadImage(path: path) { result in
            switch result {
            case let .success(castData):
                data = castData
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
        return data ?? Data()
    }

    private func fetchRating(number: Double) -> String {
        switch number {
        case 0 ... 2: return Constants.oneStarImageName
        case 2 ... 4: return Constants.twoStarImageName
        case 4 ... 6: return Constants.threeStarImageName
        case 6 ... 8: return Constants.fourStarImageName
        case 8 ... 10: return Constants.fiveStarImageName
        default: return Constants.oneStarImageName
        }
    }
}
