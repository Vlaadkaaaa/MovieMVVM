// MovieDetailViewModel.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// ViewModel для экрана с деталями о фильме
final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let lightGrayColorName = "lightGray"
        static let greenColorName = "green"
        static let redColorName = "red"
        static let emptyText = ""
        static let divideText = ", "
    }

    // MARK: - Public Property

    var updateViewDataHandler: (([Cast]) -> Void)?
    var updateGenreHandler: ((String) -> Void)?
    var updateImageHandler: ((Data) -> Void)?
    var updateColorHandler: ((String) -> Void)?
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
        networkService?.fetchCast(id: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(cast):
                self.updateViewDataHandler?(cast.cast)
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
        imageService?.loadImage(path: path) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self.updateImageHandler?(data)
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
                self.updateColorHandler?(Constants.lightGrayColorName)
            }
        case 7 ... 10:
            DispatchQueue.main.async {
                self.updateColorHandler?(Constants.greenColorName)
            }
        default:
            DispatchQueue.main.async {
                self.updateColorHandler?(Constants.redColorName)
            }
        }
    }

    // MARK: - Private Method

    private func updateGenre(genres: [Genre]) {
        var genresEmpty = Constants.emptyText
        for genre in genres {
            if genresEmpty.isEmpty {
                genresEmpty += genre.name
            } else {
                genresEmpty += Constants.divideText + genre.name
            }
            updateGenreHandler?(genresEmpty)
        }
    }
}
