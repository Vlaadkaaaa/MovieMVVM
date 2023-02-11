// Bilder.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Сборщик модулей
final class Bilder: BilderProtocol {
    let imageAPIService = ImageAPIService()
    let fileManager = FileManagerService()

    func createMainModule() -> UIViewController {
        let proxy = Proxy(imageService: imageAPIService, fileManagerService: fileManager)
        let imageService = ImageService(proxy: proxy)
        let coreDataService = CoreDataService()
        let keychainService = KeychainService()
        let networkService = NetworkService(keychainService: keychainService)
        let viewModel = MovieViewModel(
            networkService: networkService,
            imageService: imageService,
            coreDataService: coreDataService,
            keychainService: keychainService
        )
        let view = MovieViewController(movieViewModel: viewModel)
        return view
    }

    func createDetailModule(movie: Movie) -> UIViewController {
        let proxy = Proxy(imageService: imageAPIService, fileManagerService: fileManager)
        let imageService = ImageService(proxy: proxy)
        let keychainService = KeychainService()
        let networkService = NetworkService(keychainService: keychainService)
        let viewModel = MovieDetailViewModel(networkService: networkService, imageService: imageService)
        let view = MovieDetailViewController(detailViewModel: viewModel)
        view.data = movie
        return view
    }
}
