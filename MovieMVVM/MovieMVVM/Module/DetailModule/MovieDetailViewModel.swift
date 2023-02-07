// MovieDetailViewModel.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// ViewModel для экрана с деталями о фильме
final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    // MARK: - Public Property

    var updateViewData: (([Cast]) -> Void)?
    var updateGenre: ((String) -> Void)?
    var updateImage: ((Data) -> Void)?
    var updateColor: ((String) -> Void)?
    var imageService: ImageServiceProtocol?

    // MARK: - Init

    init(networkService: NetworkServiceProtocol?, imageService: ImageServiceProtocol?) {
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
        imageService?.loadImage(path: path) { result in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self.updateImage?(data)
                }
            case let .failure(error):
                print(error)
            }
        }
    }

    func updateColor(rating: Double) {
        switch rating {
        case 5 ..< 7:
            DispatchQueue.main.async {
                self.updateColor?("lightGray")
            }
        case 7 ... 10:
            DispatchQueue.main.async {
                self.updateColor?("green")
            }
        default:
            DispatchQueue.main.async {
                self.updateColor?("red")
            }
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
