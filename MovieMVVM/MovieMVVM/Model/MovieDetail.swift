// MovieDetail.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Жанры
struct MovieDetail: Decodable {
    /// Список жанров
    let genres: [Genre]
}
