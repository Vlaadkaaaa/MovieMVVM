// CoreDataServiceProtocol.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Протокол для сервиса работы с БД
protocol CoreDataServiceProtocol {
    func getData(category: String) -> [Movie]?
    func saveData(_ data: [Movie], category: String)
}
