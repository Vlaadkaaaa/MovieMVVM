// ImageServiceProtocol.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Протокл для сервиса работы с прокси
protocol ImageServiceProtocol {
    func loadImage(path: String, completion: @escaping (Result<Data, Error>) -> Void)
}
