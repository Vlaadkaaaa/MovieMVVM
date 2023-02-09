// NetworkService.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Менеджер запросов
final class NetworkService: NetworkServiceProtocol {
    // MARK: - Private Constants

    private enum UrlComponent {
        static let movieBaseUrlText = "https://api.themoviedb.org/3/movie/"
        static let languageValueText = "ru-RU"
        static let regionValueText = "ru"
    }

    private enum QueryItems {
        static let languageQueryText = "language"
        static let regionQueryText = "region"
        static let apiKeyQueryText = "api_key"
        static let pageQueryText = "page"
    }

    private enum Constants {
        static let apiKey = "apiKey"
        static let emptyText = ""
    }

    // MARK: - Private Property

    private let keychainService = KeychainService()
    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    // MARK: - Public Methods

    func fetchMovies(category: MovieCategory?, page: Int, completion: @escaping (Result<Movies, Error>) -> Void) {
        fetchJson(id: nil, category: category, page: page, completion: completion)
    }

    func fetchDetail(id: String, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        fetchJson(id: id, category: nil, page: nil, completion: completion)
    }

    func fetchCast(id: String, completion: @escaping (Result<Casts, Error>) -> Void) {
        fetchJson(id: id, category: nil, page: nil, completion: completion)
    }

    // MARK: - Private Methods

    private func fetchJson<T: Decodable>(
        id: String?,
        category: MovieCategory?,
        page: Int?,
        completion: @escaping ((Result<T, Error>) -> Void)
    ) {
        guard let url = configureUrlComponents(id: id, categoryOfMovies: category, page: page)?.url else { return }
        session.dataTask(with: url) { data, _, error in
            guard let data else { return }
            do {
                let movie = try JSONDecoder().decode(T.self, from: data)
                completion(.success(movie))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    private func configureUrlComponents(
        id: String?,
        categoryOfMovies: MovieCategory?,
        page: Int?
    ) -> URLComponents? {
        guard var urlComponents = URLComponents(
            string:
            UrlComponent
                .movieBaseUrlText + (id ?? Constants.emptyText) + (categoryOfMovies?.rawValue ?? Constants.emptyText)
        )
        else { return URLComponents() }
        urlComponents.queryItems = [
            URLQueryItem(name: QueryItems.apiKeyQueryText, value: keychainService.fetchKey(name: Constants.apiKey)),
            URLQueryItem(name: QueryItems.languageQueryText, value: UrlComponent.languageValueText),
            URLQueryItem(name: QueryItems.regionQueryText, value: UrlComponent.regionValueText)
        ]
        if page != nil {
            urlComponents.queryItems?.append(URLQueryItem(name: QueryItems.pageQueryText, value: "\(page ?? 0)"))
        }
        return urlComponents
    }
}
