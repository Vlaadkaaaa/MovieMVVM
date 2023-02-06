// NetworkManager.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// GetMoviesResult
enum GetMoviesResult {
    case successMovies(movies: MoviesNetwork)
    case successGenre(genre: Genres)
    case successDetail(movieDetail: MoviewDescriptionNetwork)
    case failure(error: Error)
}

/// Менеджер запросов
final class NetworkManager {
    // MARK: - Private Constants

    private enum Constants {
        static let apiRequestURL = "https://api.themoviedb.org/3/movie/"
        static let apiKeyURL = "api_key=d9e4494907230d135d6f6fd47beca82e"
        static let apiLanguageURL = "language=ru"
        static let imageRequestURL = "https://image.tmdb.org/t/p/w500"
        static let apiResponseURL = "append_to_response=videos"
        static let apiCreditsGenreURL = "credits"
    }

    // MARK: - Private Property

    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    // MARK: - Public Methods

    func getMovies(genre: String, completion: @escaping (GetMoviesResult) -> Void) {
        guard let url =
            URL(
                string: "\(Constants.apiRequestURL)\(genre)?\(Constants.apiKeyURL)&\(Constants.apiLanguageURL)"
            )
        else { return }
        session.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            if error == nil, let parseData = data {
                guard let posts = try? self.decoder.decode(MoviesNetwork.self, from: parseData) else { return }
                completion(.successMovies(movies: posts))
            } else {
                guard let error = error else { return }
                completion(.failure(error: error))
                print(error.localizedDescription)
            }
        }.resume()
    }

    func getGenre(movieId: String, completion: @escaping (GetMoviesResult) -> Void) {
        guard let url =
            URL(
                string: "\(Constants.apiRequestURL)\(movieId)?\(Constants.apiKeyURL)&" +
                    "\(Constants.apiResponseURL)&\(Constants.apiLanguageURL)"
            )
        else { return }
        session.dataTask(with: url) { data, _, error in
            if error == nil, let parseData = data {
                guard let genre = try? JSONDecoder().decode(Genres.self, from: parseData) else { return }
                completion(.successGenre(genre: genre))
            }
        }.resume()
    }
}
