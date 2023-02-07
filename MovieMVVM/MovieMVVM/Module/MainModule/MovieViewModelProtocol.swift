// MovieViewModelProtocol.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Протокол для ViewModel экрана списка фильмов
protocol MovieViewModelProtocol {
    var imageService: ImageServiceProtocol? { get set }
    var updateViewData: ((MovieViewData) -> Void)? { get set }
    func fetchMovie(category: MovieCategory?)
}
