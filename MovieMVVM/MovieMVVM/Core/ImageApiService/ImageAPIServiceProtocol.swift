// ImageAPIServiceProtocol.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Протокол для сервиса загрузки изображений из сети
protocol ImageAPIServiceProtocol {
    func fetchImageData(path: String, completion: @escaping (Result<Data, Error>) -> Void)
}
