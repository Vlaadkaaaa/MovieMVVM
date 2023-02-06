// MoviesGenreNetwork.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// MovieGenreNetwork
struct MovieGenreNetwork: Codable {
    let genres: [Genres]
}

/// Genres
struct Genres: Codable {
    let name: String
}
