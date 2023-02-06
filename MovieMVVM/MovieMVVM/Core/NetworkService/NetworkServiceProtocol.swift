// NetworkServiceProtocol.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Пртокол для сетевого слоя
protocol NetworkServiceProtocol {
    func fetchCast(id: String, completion: @escaping (Result<Casts, Error>) -> Void)
    func fetchDetail(id: String, completion: @escaping (Result<MovieDetail, Error>) -> Void)
    func fetchMovies(category: String?, page: Int, completion: @escaping (Result<Movies, Error>) -> Void)
}
