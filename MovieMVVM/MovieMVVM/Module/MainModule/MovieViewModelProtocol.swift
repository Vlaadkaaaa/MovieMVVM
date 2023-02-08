// MovieViewModelProtocol.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Протокол для ViewModel экрана списка фильмов
protocol MovieViewModelProtocol {
    var updateViewDataHandler: MovieDataHandler? { get set }
    var updateMovieCellHandler: MovieDataStringHandler? { get set }
    func fetchMovie()
    func updateMovieCell(_ movie: Movie)
    func setupCategory(chose index: Int)
}
