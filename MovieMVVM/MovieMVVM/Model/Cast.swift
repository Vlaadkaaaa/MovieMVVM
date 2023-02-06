// Cast.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Актер
struct Cast: Decodable {
    /// Имя
    let name: String
    /// Ссылка на фото
    let profilePath: String?
    /// Описание
    let character: String?

    enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
        case character
    }
}
