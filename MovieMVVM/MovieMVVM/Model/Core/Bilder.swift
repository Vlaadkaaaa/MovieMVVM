// Bilder.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Сборщик модулей
final class Bilder: BilderProtocol {
    let networkService = NetworkService()
    let imageAPIService = ImageAPIService()
    let fileManager = FileManagerService()

    func createMainModule() -> UIViewController {
        let proxy = Proxy(imageService: imageAPIService, fileManagerService: fileManager)
        let imageService = ImageService(proxy: proxy)
        let viewModel = MovieViewModel(networkService: networkService, imageService: imageService)
        let view = MovieViewController(movieViewModel: viewModel)
        return view
    }

    func createDetailModule(movie: Movie) -> UIViewController {
        let proxy = Proxy(imageService: imageAPIService, fileManagerService: fileManager)
        let imageService = ImageService(proxy: proxy)
        let viewModel = MovieDetailViewModel(networkService: networkService, imageService: imageService)
        let view = MovieDetailViewController(detailViewModel: viewModel)
        view.data = movie
        return view
    }
}
