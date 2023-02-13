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
        static let apiKeyText = "apiKey"
    }

    // MARK: - Public Property

    var updateViewDataHandler: MovieDataHandler?
    var updateMovieCellHandler: MovieDataStringHandler?
    var currentCategory: MovieCategory = .popular

    // MARK: - Init

    init(
        networkService: NetworkServiceProtocol,
        imageService: ImageServiceProtocol?,
        coreDataService: CoreDataServiceProtocol?,
        keychainService: KeychainServiceProtocol?
    ) {
        self.networkService = networkService
        self.imageService = imageService
        self.coreDataService = coreDataService
        self.keychainService = keychainService
    }

    // MARK: - Private Protperty

    private let imageService: ImageServiceProtocol?
    private let keychainService: KeychainServiceProtocol?
    private let networkService: NetworkServiceProtocol?
    private var coreDataService: CoreDataServiceProtocol?

    // MARK: - Public Method

    func updateMovieCell(_ movie: Movie) {
        updateMovieCellHandler?(movie, fetchMovieImage(path: movie.posterPath), fetchRating(number: movie.voteAverage))
    }

    func updateApiKey(_ key: String) {
        UserDefaults.standard.set(true, forKey: Constants.apiKeyText)
        keychainService?.saveKey(name: key)
        loadMovie()
    }

    func checkApiKey(completion: VoidHandler) {
        if UserDefaults.standard.bool(forKey: Constants.apiKeyText) {
            loadMovie()
        } else {
            completion()
        }
    }

    func setupCategory(choose index: Int) {
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

    private func fetchMovie() {
        updateViewDataHandler?(.loading)
        loadMovie()
    }

    private func loadMovie() {
        if let data = coreDataService?.getData(category: currentCategory.rawValue), !data.isEmpty {
            updateViewDataHandler?(.success(data))
            return
        }
        networkService?.fetchMovies(category: currentCategory, page: 1) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(movies):
                self.coreDataService?.saveData(movies.movies, category: self.currentCategory.rawValue)
                guard let movie = self.coreDataService?.getData(category: self.currentCategory.rawValue) else { return }
                self.updateViewDataHandler?(.success(movie))
            case let .failure(error):
                self.updateViewDataHandler?(.failure(error: error))
            }
        }
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
