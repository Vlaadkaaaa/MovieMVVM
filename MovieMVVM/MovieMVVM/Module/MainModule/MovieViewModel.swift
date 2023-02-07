// MovieViewModel.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

final class MovieViewModel: MovieViewModelProtocol {
    // MARK: - Public Property

    var updateViewData: ((MovieViewData) -> Void)?
    var imageService: ImageNetworkServiceProtocol?

    init(networkService: NetworkServiceProtocol, imageService: ImageNetworkServiceProtocol?) {
        self.networkService = networkService
        self.imageService = imageService
    }

    // MARK: - Private Protperty

    private let networkService: NetworkServiceProtocol?

    // MARK: - Public Method

    func fetchMovie(category: MovieCategory?) {
        networkService?.fetchMovies(category: category, page: 1) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(movies):
                self.updateViewData?(.success(movies.movies))
            case let .failure(error):
                self.updateViewData?(.failure(error: error))
            }
        }
    }
}
