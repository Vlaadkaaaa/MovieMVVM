// Bilder.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Проткол сборщика модулей
protocol BilderProtocol {
    func createMainModule() -> UIViewController
    func createDetailModule(movie: Movie) -> UIViewController
}

final class Bilder: BilderProtocol {
    func createMainModule() -> UIViewController {
        let networkService = NetworkService()
        let imageService = ImageNetworkService()
        let viewModel = MovieViewModel(networkService: networkService, imageService: imageService)
        let view = MovieViewController(movieViewModel: viewModel)
        return view
    }

    func createDetailModule(movie: Movie) -> UIViewController {
        let networkService = NetworkService()
        let imageService = ImageNetworkService()
        let viewModel = MovieDetailViewModel(networkService: networkService, imageService: imageService)
        let view = MovieDetailViewController(detailViewModel: viewModel)
        view.data = movie
        return view
    }
}
