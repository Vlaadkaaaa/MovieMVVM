// ImageNetworkService.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Сервис загрузки изображений из сети
final class ImageNetworkService: ImageNetworkServiceProtocol {
    // MARK: - Private Constants

    private enum UrlComponent {
        static let posterPathImageUrl = "https://image.tmdb.org/t/p/w500"
    }

    // MARK: - Public Method

    func fetchImageData(path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "\(UrlComponent.posterPathImageUrl)\(path)") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else { return }
            do {
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
