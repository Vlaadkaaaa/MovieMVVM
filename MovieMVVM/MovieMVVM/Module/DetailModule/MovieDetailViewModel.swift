// MovieDetailViewModel.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    // MARK: - Public Property

    var updateViewData: (([Cast]) -> Void)?
    var updateGenre: ((String) -> Void)?
    var updateImage: ((Data) -> Void)?
    var updateColor: ((String) -> Void)?
    var imageService: ImageNetworkServiceProtocol?

    // MARK: - Init

    init(networkService: NetworkServiceProtocol?, imageService: ImageNetworkServiceProtocol?) {
        self.networkService = networkService
        self.imageService = imageService
    }

    // MARK: - Private Protperty

    private var networkService: NetworkServiceProtocol?

    // MARK: - Public Method

    func fetchCast(id: String) {
        networkService?.fetchCast(id: id) { result in
            switch result {
            case let .success(cast):
                self.updateViewData?(cast.cast)
            case let .failure(error):
                print(error)
            }
        }
    }

    func fetchDetail(id: String) {
        networkService?.fetchDetail(id: id) { result in
            switch result {
            case let .success(detail):
                self.updateGenre(genres: detail.genres)
            case let .failure(error):
                print(error)
            }
        }
    }

    func fetchImageData(path: String) {
        imageService?.fetchImageData(path: path) { result in
            switch result {
            case let .success(data):
                self.updateImage?(data)
            case let .failure(error):
                print(error)
            }
        }
    }

    func updateColor(rating: Double) {
        switch rating {
        case 5 ..< 7:
            updateColor?("lightGray")
        case 7 ... 10:
            updateColor?("systemGreen")
        default:
            updateColor?("systemRed")
        }
    }

    // MARK: - Private Method

    private func updateGenre(genres: [Genre]) {
        var genresEmpty = ""
        for genre in genres {
            if genresEmpty.isEmpty {
                genresEmpty += genre.name
            } else {
                genresEmpty += ", " + genre.name
            }
            updateGenre?(genresEmpty)
        }
    }
}
