// MovieDetailViewModelProtocol.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Проткол для ViewModel экрана с деталями о фильме
protocol MovieDetailViewModelProtocol {
    var imageService: ImageServiceProtocol? { get set }
    var updateViewData: (([Cast]) -> Void)? { get set }
    var updateGenre: ((String) -> Void)? { get set }
    var updateImage: ((Data) -> Void)? { get set }
    var updateColor: ((String) -> Void)? { get set }
    func fetchCast(id: String)
    func fetchDetail(id: String)
    func fetchImageData(path: String)
    func updateColor(rating: Double)
}
