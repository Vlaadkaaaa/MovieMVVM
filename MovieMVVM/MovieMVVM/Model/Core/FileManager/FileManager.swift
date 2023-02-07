// FileManager.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Кэширование фото
final class FileManagerService: FileManagerProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let separatorText: Character = "/"
        static let imagesFolderText = "images"
    }

    // MARK: - Private Property

    private let fileManager = FileManager.default
    private var imagesMap: [String: Data] = [:]

    // MARK: - Public Methods

    func getImageDataFromDisk(url: String) -> Data? {
        guard
            let filePath = fetchImagePath(url: url),
            let data = try? Data(contentsOf: filePath)
        else { return nil }
        imagesMap[url] = data
        return data
    }

    func saveImageToFile(url: String, data: Data) {
        guard let filePath = fetchImagePath(url: url) else { return }
        fileManager.createFile(atPath: filePath.path, contents: data)
    }

    // MARK: - Private Methods

    private func fetchImageFromDisk(url: String) -> Data? {
        guard
            let filePath = fetchImagePath(url: url),
            let image = try? Data(contentsOf: filePath)
        else { return nil }
        imagesMap[url] = image
        return image
    }

    private func fetchImagePath(url: String) -> URL? {
        guard
            let folderURL = fetchCasheFolderPath(),
            let fileName = url.split(separator: Constants.separatorText).last
        else { return nil }
        return folderURL.appendingPathComponent("\(fileName)")
    }

    private func fetchCasheFolderPath() -> URL? {
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return nil }
        let url = documentDirectory.appendingPathComponent(Constants.imagesFolderText)
        try? fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }
}
