// Casts.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Актеры
struct Casts: Decodable {
    /// ID - Фильма
    let id: Int
    /// Список актеров
    let cast: [Cast]
}
