// BilderProtocol.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Проткол сборщика модулей
protocol BilderProtocol {
    func createMainModule() -> UIViewController
    func createDetailModule(movie: Movie) -> UIViewController
}
