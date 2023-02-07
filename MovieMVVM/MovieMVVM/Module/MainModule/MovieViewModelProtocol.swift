// MovieViewModelProtocol.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Протокол для
protocol MovieViewModelProtocol {
    var imageService: ImageNetworkServiceProtocol? { get set }
    var updateViewData: ((MovieViewData) -> Void)? { get set }
    func fetchMovie(category: MovieCategory?)
}
