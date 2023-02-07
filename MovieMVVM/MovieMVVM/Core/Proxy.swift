// Proxy.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Прокси
final class Proxy: ProxyProtocol {
    // MARK: - Private Property

    private let imageService: ImageAPIServiceProtocol
    private let fileManagerService: FileManagerProtocol

    // MARK: - Init

    init(imageService: ImageAPIServiceProtocol, fileManagerService: FileManagerProtocol) {
        self.imageService = imageService
        self.fileManagerService = fileManagerService
    }

    // MARK: - Public Method

    func getImage(path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let image = fileManagerService.getImageDataFromDisk(url: path) else {
            fetchImage(path, completion: completion)
            return
        }
        completion(.success(image))
    }

    // MARK: - Private Method

    private func fetchImage(_ path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        imageService.fetchImageData(path: path) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(data):
                self.fileManagerService.saveImageToFile(url: path, data: data)
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
