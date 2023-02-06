// Movie.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Информация о фильме
struct Movie: Decodable {
    /// ID - фильма
    let id: Int
    /// Описание
    let overview: String
    /// Ссылка на постер
    let posterPath: String
    /// Дата релиза
    let releaseDate: String
    /// Заголовок
    let title: String
    /// Рейтинг
    let voteAverage: Double
    /// Количество оценок
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
