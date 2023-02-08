// MovieDetailViewModelProtocol.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Проткол для ViewModel экрана с деталями о фильме
protocol MovieDetailViewModelProtocol {
    var updateViewDataHandler: CastsHandler? { get set }
    var updateGenreHandler: StringHandler? { get set }
    var updateImageHandler: DataHandler? { get set }
    var updateColorHandler: StringHandler? { get set }
    var castHandler: CastHandler? { get set }
    func fetchCast(id: String)
    func fetchDetail(id: String)
    func fetchImageData(path: String)
    func updateColor(rating: Double)
    func updateCast(_ cast: Cast)
}
