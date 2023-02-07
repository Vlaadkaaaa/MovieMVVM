// ProxyProtocol.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Проткол для прокси
protocol ProxyProtocol {
    func getImage(path: String, completion: @escaping (Result<Data, Error>) -> Void)
}
