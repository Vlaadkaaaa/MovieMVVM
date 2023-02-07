// FileManagerProtocol.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Протокол для кеширования фото
protocol FileManagerProtocol {
    func getImageDataFromDisk(url: String) -> Data?
    func saveImageToFile(url: String, data: Data)
}
