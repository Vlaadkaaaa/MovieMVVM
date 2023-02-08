// MovieDetailViewModelProtocol.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Проткол для ViewModel экрана с деталями о фильме
protocol MovieDetailViewModelProtocol {
    var imageService: ImageServiceProtocol? { get set }
    var updateViewDataHandler: (([Cast]) -> Void)? { get set }
    var updateGenreHandler: ((String) -> Void)? { get set }
    var updateImageHandler: ((Data) -> Void)? { get set }
    var updateColorHandler: ((String) -> Void)? { get set }
    func fetchCast(id: String)
    func fetchDetail(id: String)
    func fetchImageData(path: String)
    func updateColor(rating: Double)
}
