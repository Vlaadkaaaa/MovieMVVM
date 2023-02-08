// ImageService.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Сервис работы с прокси
final class ImageService: ImageServiceProtocol {
    // MARK: - Private Property

    private var proxy: ProxyProtocol

    // MARK: - Init

    init(proxy: ProxyProtocol) {
        self.proxy = proxy
    }

    // MARK: - Public Method

    func loadImage(path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        proxy.getImage(path: path, completion: completion)
    }
}
