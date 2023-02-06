// Movies.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Фильмы
struct Movies: Decodable {
    /// Номер страницы
    let page: Int
    /// Список фильмов текущей страницы
    let movies: [Movie]
    /// Количество страниц
    let totalPages: Int
    /// Количество фильмов
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
